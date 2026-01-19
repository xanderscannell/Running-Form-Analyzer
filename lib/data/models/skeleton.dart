import 'dart:math' as math;
import 'dart:ui';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'joint.dart';
import 'joint_connection.dart';

part 'skeleton.freezed.dart';

/// Represents the complete skeleton/pose with all joints and connections
@freezed
class Skeleton with _$Skeleton {
  const factory Skeleton({
    required Map<JointType, Joint> joints,
    required List<JointConnection> connections,
    @Default(false) bool isDetected,
    @Default(false) bool segmentLockEnabled,
    /// Stored segment lengths (normalized) when lock is enabled
    @Default({}) Map<String, double> segmentLengths,
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

  /// Get a unique key for a connection (for segment length storage)
  static String _connectionKey(JointConnection conn) {
    return '${conn.from.name}-${conn.to.name}';
  }

  /// Calculate distance between two points
  static double _distance(Offset a, Offset b) {
    final dx = a.dx - b.dx;
    final dy = a.dy - b.dy;
    return math.sqrt(dx * dx + dy * dy);
  }

  /// Capture current segment lengths for locking
  Skeleton captureSegmentLengths() {
    final lengths = <String, double>{};
    for (final conn in connections) {
      final fromJoint = joints[conn.from];
      final toJoint = joints[conn.to];
      if (fromJoint != null && toJoint != null) {
        lengths[_connectionKey(conn)] = _distance(
          fromJoint.position,
          toJoint.position,
        );
      }
    }
    return copyWith(
      segmentLengths: lengths,
      segmentLockEnabled: true,
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

  /// Calculate angle from point a to point b
  static double _angle(Offset from, Offset to) {
    return math.atan2(to.dy - from.dy, to.dx - from.dx);
  }

  /// Rotate a point around a pivot by a given angle delta
  static Offset _rotateAround(Offset point, Offset pivot, double angleDelta) {
    final dx = point.dx - pivot.dx;
    final dy = point.dy - pivot.dy;
    final cos = math.cos(angleDelta);
    final sin = math.sin(angleDelta);
    return Offset(
      pivot.dx + dx * cos - dy * sin,
      pivot.dy + dx * sin + dy * cos,
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
    );

    // Calculate the rotation angle
    final oldAngle = _angle(parentJoint.position, oldPosition);
    final newAngle = _angle(parentJoint.position, constrainedPosition);
    final angleDelta = newAngle - oldAngle;

    // Update the dragged joint
    updatedJoints[type] = existingJoint.withPosition(constrainedPosition);

    // Rotate all descendants around the dragged joint's NEW position
    // This maintains their relative angles
    for (final descendant in _getDescendants(type)) {
      final descJoint = updatedJoints[descendant];
      if (descJoint != null && descJoint.isVisible) {
        // First, rotate around the parent (same as the dragged joint)
        final rotatedAroundParent = _rotateAround(
          descJoint.position,
          parentJoint.position,
          angleDelta,
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
  static Offset _constrainPosition(
    Offset anchorPos,
    Offset otherPos,
    double targetLength,
  ) {
    final currentDist = _distance(anchorPos, otherPos);
    if (currentDist < 0.0001) {
      // Points are too close, move in arbitrary direction
      return Offset(anchorPos.dx + targetLength, anchorPos.dy);
    }

    // Calculate unit vector from anchor to other
    final dx = otherPos.dx - anchorPos.dx;
    final dy = otherPos.dy - anchorPos.dy;
    final unitX = dx / currentDist;
    final unitY = dy / currentDist;

    // Place other point at target distance along the same direction
    return Offset(
      anchorPos.dx + unitX * targetLength,
      anchorPos.dy + unitY * targetLength,
    );
  }
}
