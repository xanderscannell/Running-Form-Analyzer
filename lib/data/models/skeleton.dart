import 'dart:math' as math;
import 'dart:ui';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'joint.dart';
import 'joint_connection.dart';

part 'skeleton.freezed.dart';
part 'skeleton.g.dart';

/// Represents the complete skeleton/pose with all joints and connections
@freezed
class Skeleton with _$Skeleton {
  const factory Skeleton({
    required Map<JointType, Joint> joints,
    required List<JointConnection> connections,
    @Default(false) bool isDetected,
    @Default(false) bool segmentLockEnabled,
    /// Stored segment lengths (aspect-corrected) when lock is enabled
    @Default({}) Map<String, double> segmentLengths,
    /// Image aspect ratio (width/height) used for segment length calculations
    @Default(1.0) double imageAspectRatio,
    DateTime? detectedAt,
  }) = _Skeleton;

  const Skeleton._();

  /// Get all visible joints
  List<Joint> get visibleJoints =>
      joints.values.where((j) => j.isVisible).toList();

  /// Get connections where both joints are visible
  List<JointConnection> get visibleConnections => connections
      .where((c) =>
          joints[c.from]?.isVisible == true && joints[c.to]?.isVisible == true)
      .toList();

  /// Update a single joint's position
  Skeleton updateJointPosition(JointType type, Offset newPosition) {
    final updatedJoints = Map<JointType, Joint>.from(joints);
    final existingJoint = updatedJoints[type];
    if (existingJoint != null) {
      updatedJoints[type] = existingJoint.withPosition(newPosition);
    }
    return copyWith(joints: updatedJoints);
  }

  /// Toggle visibility for a specific joint
  Skeleton toggleJointVisibility(JointType type, bool isVisible) {
    final updatedJoints = Map<JointType, Joint>.from(joints);
    final existingJoint = updatedJoints[type];
    if (existingJoint != null) {
      updatedJoints[type] = existingJoint.copyWith(isVisible: isVisible);
    }
    return copyWith(joints: updatedJoints);
  }

  /// Apply visibility config to all joints
  Skeleton applyVisibilityConfig(Map<JointType, bool> visibilityMap) {
    final updatedJoints = Map<JointType, Joint>.from(joints);
    for (final entry in visibilityMap.entries) {
      final existingJoint = updatedJoints[entry.key];
      if (existingJoint != null) {
        updatedJoints[entry.key] =
            existingJoint.copyWith(isVisible: entry.value);
      }
    }
    return copyWith(joints: updatedJoints);
  }

  /// Create an empty skeleton with default connections
  factory Skeleton.empty(List<JointConnection> connections) {
    return Skeleton(
      joints: {},
      connections: connections,
      isDetected: false,
    );
  }

  factory Skeleton.fromJson(Map<String, dynamic> json) =>
      _$SkeletonFromJson(json);

  /// Get a unique key for a connection (for segment length storage)
  static String _connectionKey(JointConnection conn) {
    return '${conn.from.name}-${conn.to.name}';
  }

  /// Calculate distance between two points in aspect-corrected space
  /// The aspectRatio is width/height of the image
  static double _distance(Offset a, Offset b, double aspectRatio) {
    // Scale X coordinates by aspect ratio to get consistent distances
    // This converts normalized coords to a space where X and Y have equal scale
    final dx = (a.dx - b.dx) * aspectRatio;
    final dy = a.dy - b.dy;
    return math.sqrt(dx * dx + dy * dy);
  }

  /// Capture current segment lengths for locking
  /// [aspectRatio] is the image width / height
  Skeleton captureSegmentLengths(double aspectRatio) {
    final lengths = <String, double>{};
    for (final conn in connections) {
      final fromJoint = joints[conn.from];
      final toJoint = joints[conn.to];
      if (fromJoint != null && toJoint != null) {
        lengths[_connectionKey(conn)] = _distance(
          fromJoint.position,
          toJoint.position,
          aspectRatio,
        );
      }
    }
    return copyWith(
      segmentLengths: lengths,
      segmentLockEnabled: true,
      imageAspectRatio: aspectRatio,
    );
  }

  /// Disable segment locking
  Skeleton disableSegmentLock() {
    return copyWith(
      segmentLockEnabled: false,
      segmentLengths: {},
    );
  }

  /// Hierarchy definition: maps each joint to its parent
  /// Hip is the root (no parent) - moving hip translates entire skeleton
  /// Spine: hip → shoulder → nose
  /// Arms branch from shoulder, legs branch from hip
  static const Map<JointType, JointType> _parentMap = {
    // Spine (hip is root, so not in map)
    JointType.shoulder: JointType.hip,
    JointType.nose: JointType.shoulder,
    // Left arm
    JointType.leftElbow: JointType.shoulder,
    JointType.leftWrist: JointType.leftElbow,
    // Right arm
    JointType.rightElbow: JointType.shoulder,
    JointType.rightWrist: JointType.rightElbow,
    // Left leg
    JointType.leftKnee: JointType.hip,
    JointType.leftHeel: JointType.leftKnee,
    JointType.leftFootIndex: JointType.leftHeel,
    // Right leg
    JointType.rightKnee: JointType.hip,
    JointType.rightHeel: JointType.rightKnee,
    JointType.rightFootIndex: JointType.rightHeel,
  };

  /// Get all children of a joint (joints that have this joint as parent)
  List<JointType> _getChildren(JointType type) {
    return _parentMap.entries
        .where((e) => e.value == type)
        .map((e) => e.key)
        .toList();
  }

  /// Get all descendants of a joint (children, grandchildren, etc.)
  Set<JointType> _getDescendants(JointType type) {
    final descendants = <JointType>{};
    final queue = <JointType>[type];

    while (queue.isNotEmpty) {
      final current = queue.removeAt(0);
      for (final child in _getChildren(current)) {
        if (!descendants.contains(child)) {
          descendants.add(child);
          queue.add(child);
        }
      }
    }
    return descendants;
  }

  /// Calculate angle from point a to point b in aspect-corrected space
  static double _angle(Offset from, Offset to, double aspectRatio) {
    final dx = (to.dx - from.dx) * aspectRatio;
    final dy = to.dy - from.dy;
    return math.atan2(dy, dx);
  }

  /// Rotate a point around a pivot by a given angle delta in aspect-corrected space
  /// This preserves segment lengths during rotation for non-square images
  static Offset _rotateAround(Offset point, Offset pivot, double angleDelta, double aspectRatio) {
    // Convert to aspect-corrected space
    final dxCorrected = (point.dx - pivot.dx) * aspectRatio;
    final dyCorrected = point.dy - pivot.dy;

    // Rotate in aspect-corrected space
    final cos = math.cos(angleDelta);
    final sin = math.sin(angleDelta);
    final rotatedX = dxCorrected * cos - dyCorrected * sin;
    final rotatedY = dxCorrected * sin + dyCorrected * cos;

    // Convert back to normalized space
    return Offset(
      pivot.dx + rotatedX / aspectRatio,
      pivot.dy + rotatedY,
    );
  }

  /// Update joint position with hierarchical rotation constraint
  /// - The dragged joint rotates around its parent (parent stays fixed)
  /// - All descendants of the dragged joint move rigidly with it
  Skeleton updateJointPositionLocked(JointType type, Offset newPosition) {
    if (!segmentLockEnabled || segmentLengths.isEmpty) {
      return updateJointPosition(type, newPosition);
    }

    final updatedJoints = Map<JointType, Joint>.from(joints);
    final existingJoint = updatedJoints[type];
    if (existingJoint == null) return this;

    final oldPosition = existingJoint.position;
    final parentType = _parentMap[type];

    // If no parent (e.g., nose), just move freely with descendants
    if (parentType == null) {
      final delta = newPosition - oldPosition;
      updatedJoints[type] = existingJoint.withPosition(newPosition);

      // Move all descendants by the same delta
      for (final descendant in _getDescendants(type)) {
        final descJoint = updatedJoints[descendant];
        if (descJoint != null && descJoint.isVisible) {
          updatedJoints[descendant] = descJoint.withPosition(
            descJoint.position + delta,
          );
        }
      }
      return copyWith(joints: updatedJoints);
    }

    final parentJoint = updatedJoints[parentType];
    if (parentJoint == null) {
      return updateJointPosition(type, newPosition);
    }

    // Find the segment length between parent and this joint
    final segmentKey = _findSegmentKey(parentType, type);
    final segmentLength = segmentKey != null ? segmentLengths[segmentKey] : null;

    if (segmentLength == null) {
      return updateJointPosition(type, newPosition);
    }

    // Calculate the new position constrained to the segment length
    // (rotate around parent, maintaining distance)
    final constrainedPosition = _constrainPosition(
      parentJoint.position,
      newPosition,
      segmentLength,
      imageAspectRatio,
    );

    // Calculate the rotation angle in aspect-corrected space
    final oldAngle = _angle(parentJoint.position, oldPosition, imageAspectRatio);
    final newAngle = _angle(parentJoint.position, constrainedPosition, imageAspectRatio);
    final angleDelta = newAngle - oldAngle;

    // Update the dragged joint
    updatedJoints[type] = existingJoint.withPosition(constrainedPosition);

    // Rotate all descendants around the parent joint
    // This maintains their relative angles and segment lengths in aspect-corrected space
    for (final descendant in _getDescendants(type)) {
      final descJoint = updatedJoints[descendant];
      if (descJoint != null && descJoint.isVisible) {
        final rotatedAroundParent = _rotateAround(
          descJoint.position,
          parentJoint.position,
          angleDelta,
          imageAspectRatio,
        );
        updatedJoints[descendant] = descJoint.withPosition(rotatedAroundParent);
      }
    }

    return copyWith(joints: updatedJoints);
  }

  /// Find the segment key for the connection between two joints
  String? _findSegmentKey(JointType a, JointType b) {
    for (final conn in connections) {
      if ((conn.from == a && conn.to == b) || (conn.from == b && conn.to == a)) {
        return _connectionKey(conn);
      }
    }
    return null;
  }

  /// Constrain otherPos to be exactly targetLength away from anchorPos
  /// in aspect-corrected space
  static Offset _constrainPosition(
    Offset anchorPos,
    Offset otherPos,
    double targetLength,
    double aspectRatio,
  ) {
    final currentDist = _distance(anchorPos, otherPos, aspectRatio);
    if (currentDist < 0.0001) {
      // Points are too close, move in arbitrary direction
      // targetLength is in aspect-corrected space, so divide by aspectRatio for X
      return Offset(anchorPos.dx + targetLength / aspectRatio, anchorPos.dy);
    }

    // Calculate direction in aspect-corrected space
    final dxCorrected = (otherPos.dx - anchorPos.dx) * aspectRatio;
    final dyCorrected = otherPos.dy - anchorPos.dy;

    // Unit vector in aspect-corrected space
    final unitX = dxCorrected / currentDist;
    final unitY = dyCorrected / currentDist;

    // Place other point at target distance along the same direction
    // Convert back from aspect-corrected space to normalized space for X
    return Offset(
      anchorPos.dx + (unitX * targetLength) / aspectRatio,
      anchorPos.dy + unitY * targetLength,
    );
  }
}
