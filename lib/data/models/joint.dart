import 'dart:ui';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'joint.freezed.dart';
part 'joint.g.dart';

/// All 33 pose landmarks from ML Kit plus synthetic joints
enum JointType {
  // ML Kit landmarks
  nose,
  leftEyeInner,
  leftEye,
  leftEyeOuter,
  rightEyeInner,
  rightEye,
  rightEyeOuter,
  leftEar,
  rightEar,
  leftMouth,
  rightMouth,
  leftShoulder,
  rightShoulder,
  leftElbow,
  rightElbow,
  leftWrist,
  rightWrist,
  leftPinky,
  rightPinky,
  leftIndex,
  rightIndex,
  leftThumb,
  rightThumb,
  leftHip,
  rightHip,
  leftKnee,
  rightKnee,
  leftAnkle,
  rightAnkle,
  leftHeel,
  rightHeel,
  leftFootIndex,
  rightFootIndex,

  // Synthetic joints (computed as midpoints)
  shoulder, // Midpoint of leftShoulder and rightShoulder
  hip,      // Midpoint of leftHip and rightHip
}

/// Categories for grouping joints in the UI
enum JointCategory {
  face,
  upperBody,
  hands,
  lowerBody,
  feet,
}

/// Represents a single joint/landmark in the pose
@freezed
class Joint with _$Joint {
  const factory Joint({
    required JointType type,
    /// Position normalized to 0-1 range relative to image dimensions
    required double x,
    required double y,
    /// Confidence score from ML Kit (0-1)
    @Default(1.0) double confidence,
    /// Whether this joint is visible in the overlay
    @Default(true) bool isVisible,
    /// Whether the user has manually adjusted this joint's position
    @Default(false) bool isManuallyAdjusted,
  }) = _Joint;

  const Joint._();

  /// Get position as Offset
  Offset get position => Offset(x, y);

  /// Create a new Joint with updated position
  Joint withPosition(Offset newPosition) {
    return copyWith(
      x: newPosition.dx,
      y: newPosition.dy,
      isManuallyAdjusted: true,
    );
  }

  factory Joint.fromJson(Map<String, dynamic> json) => _$JointFromJson(json);
}
