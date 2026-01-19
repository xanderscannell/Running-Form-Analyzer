import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../models/joint.dart';
import '../models/skeleton.dart';
import '../../core/constants/joint_constants.dart';
import '../../core/utils/coordinate_utils.dart';

/// Repository for detecting poses in images using ML Kit
class PoseDetectionRepository {
  late final PoseDetector _poseDetector;

  PoseDetectionRepository() {
    final options = PoseDetectorOptions(
      mode: PoseDetectionMode.single,
      model: PoseDetectionModel.accurate,
    );
    _poseDetector = PoseDetector(options: options);
  }

  /// Detect pose in an image file
  /// Returns a Skeleton if a pose is detected, null otherwise
  Future<Skeleton?> detectPose(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final List<Pose> poses = await _poseDetector.processImage(inputImage);

    if (poses.isEmpty) return null;

    // Get image dimensions for coordinate normalization
    final imageFile = File(imagePath);
    final imageBytes = await imageFile.readAsBytes();
    final decodedImage = await _decodeImage(imageBytes);
    final imageWidth = decodedImage.width.toDouble();
    final imageHeight = decodedImage.height.toDouble();

    final pose = poses.first;
    final joints = <JointType, Joint>{};

    for (final landmark in pose.landmarks.values) {
      final jointType = _mapLandmarkToJointType(landmark.type);
      if (jointType != null) {
        final normalizedPos = CoordinateUtils.mlKitToNormalized(
          landmark.x,
          landmark.y,
          imageWidth,
          imageHeight,
        );

        joints[jointType] = Joint(
          type: jointType,
          x: normalizedPos.dx,
          y: normalizedPos.dy,
          confidence: landmark.likelihood,
        );
      }
    }

    // Compute synthetic shoulder (midpoint of left and right shoulders)
    final leftShoulder = joints[JointType.leftShoulder];
    final rightShoulder = joints[JointType.rightShoulder];
    if (leftShoulder != null && rightShoulder != null) {
      joints[JointType.shoulder] = Joint(
        type: JointType.shoulder,
        x: (leftShoulder.x + rightShoulder.x) / 2,
        y: (leftShoulder.y + rightShoulder.y) / 2,
        confidence: (leftShoulder.confidence + rightShoulder.confidence) / 2,
      );
    }

    // Compute synthetic hip (midpoint of left and right hips)
    final leftHip = joints[JointType.leftHip];
    final rightHip = joints[JointType.rightHip];
    if (leftHip != null && rightHip != null) {
      joints[JointType.hip] = Joint(
        type: JointType.hip,
        x: (leftHip.x + rightHip.x) / 2,
        y: (leftHip.y + rightHip.y) / 2,
        confidence: (leftHip.confidence + rightHip.confidence) / 2,
      );
    }

    return Skeleton(
      joints: joints,
      connections: JointConstants.defaultConnections,
      isDetected: true,
      detectedAt: DateTime.now(),
    );
  }

  /// Map ML Kit landmark type to our JointType enum
  JointType? _mapLandmarkToJointType(PoseLandmarkType type) {
    return switch (type) {
      PoseLandmarkType.nose => JointType.nose,
      PoseLandmarkType.leftEyeInner => JointType.leftEyeInner,
      PoseLandmarkType.leftEye => JointType.leftEye,
      PoseLandmarkType.leftEyeOuter => JointType.leftEyeOuter,
      PoseLandmarkType.rightEyeInner => JointType.rightEyeInner,
      PoseLandmarkType.rightEye => JointType.rightEye,
      PoseLandmarkType.rightEyeOuter => JointType.rightEyeOuter,
      PoseLandmarkType.leftEar => JointType.leftEar,
      PoseLandmarkType.rightEar => JointType.rightEar,
      PoseLandmarkType.leftMouth => JointType.leftMouth,
      PoseLandmarkType.rightMouth => JointType.rightMouth,
      PoseLandmarkType.leftShoulder => JointType.leftShoulder,
      PoseLandmarkType.rightShoulder => JointType.rightShoulder,
      PoseLandmarkType.leftElbow => JointType.leftElbow,
      PoseLandmarkType.rightElbow => JointType.rightElbow,
      PoseLandmarkType.leftWrist => JointType.leftWrist,
      PoseLandmarkType.rightWrist => JointType.rightWrist,
      PoseLandmarkType.leftPinky => JointType.leftPinky,
      PoseLandmarkType.rightPinky => JointType.rightPinky,
      PoseLandmarkType.leftIndex => JointType.leftIndex,
      PoseLandmarkType.rightIndex => JointType.rightIndex,
      PoseLandmarkType.leftThumb => JointType.leftThumb,
      PoseLandmarkType.rightThumb => JointType.rightThumb,
      PoseLandmarkType.leftHip => JointType.leftHip,
      PoseLandmarkType.rightHip => JointType.rightHip,
      PoseLandmarkType.leftKnee => JointType.leftKnee,
      PoseLandmarkType.rightKnee => JointType.rightKnee,
      PoseLandmarkType.leftAnkle => JointType.leftAnkle,
      PoseLandmarkType.rightAnkle => JointType.rightAnkle,
      PoseLandmarkType.leftHeel => JointType.leftHeel,
      PoseLandmarkType.rightHeel => JointType.rightHeel,
      PoseLandmarkType.leftFootIndex => JointType.leftFootIndex,
      PoseLandmarkType.rightFootIndex => JointType.rightFootIndex,
    };
  }

  /// Decode image bytes to get dimensions
  Future<ui.Image> _decodeImage(List<int> bytes) {
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(
      bytes is Uint8List ? bytes : Uint8List.fromList(bytes),
      (ui.Image image) => completer.complete(image),
    );
    return completer.future;
  }

  /// Clean up resources
  void dispose() {
    _poseDetector.close();
  }
}
