import '../../data/models/joint.dart';
import '../../data/models/joint_connection.dart';

class JointConstants {
  JointConstants._();

  /// Maps JointType to its category
  static JointCategory getCategoryForJoint(JointType type) {
    return switch (type) {
      JointType.nose ||
      JointType.leftEyeInner ||
      JointType.leftEye ||
      JointType.leftEyeOuter ||
      JointType.rightEyeInner ||
      JointType.rightEye ||
      JointType.rightEyeOuter ||
      JointType.leftEar ||
      JointType.rightEar ||
      JointType.leftMouth ||
      JointType.rightMouth =>
        JointCategory.face,
      JointType.leftShoulder ||
      JointType.rightShoulder ||
      JointType.shoulder ||
      JointType.leftElbow ||
      JointType.rightElbow ||
      JointType.leftWrist ||
      JointType.rightWrist =>
        JointCategory.upperBody,
      JointType.leftPinky ||
      JointType.rightPinky ||
      JointType.leftIndex ||
      JointType.rightIndex ||
      JointType.leftThumb ||
      JointType.rightThumb =>
        JointCategory.hands,
      JointType.leftHip ||
      JointType.rightHip ||
      JointType.hip ||
      JointType.leftKnee ||
      JointType.rightKnee ||
      JointType.leftAnkle ||
      JointType.rightAnkle =>
        JointCategory.lowerBody,
      JointType.leftHeel ||
      JointType.rightHeel ||
      JointType.leftFootIndex ||
      JointType.rightFootIndex =>
        JointCategory.feet,
    };
  }

  /// Display name for each joint type
  static String getJointDisplayName(JointType type) {
    return switch (type) {
      JointType.nose => 'Head',
      JointType.leftEyeInner => 'Left Eye (Inner)',
      JointType.leftEye => 'Left Eye',
      JointType.leftEyeOuter => 'Left Eye (Outer)',
      JointType.rightEyeInner => 'Right Eye (Inner)',
      JointType.rightEye => 'Right Eye',
      JointType.rightEyeOuter => 'Right Eye (Outer)',
      JointType.leftEar => 'Left Ear',
      JointType.rightEar => 'Right Ear',
      JointType.leftMouth => 'Left Mouth',
      JointType.rightMouth => 'Right Mouth',
      JointType.leftShoulder => 'Left Shoulder',
      JointType.rightShoulder => 'Right Shoulder',
      JointType.shoulder => 'Shoulder',
      JointType.leftElbow => 'Left Elbow',
      JointType.rightElbow => 'Right Elbow',
      JointType.leftWrist => 'Left Hand',
      JointType.rightWrist => 'Right Hand',
      JointType.leftPinky => 'Left Pinky',
      JointType.rightPinky => 'Right Pinky',
      JointType.leftIndex => 'Left Index',
      JointType.rightIndex => 'Right Index',
      JointType.leftThumb => 'Left Thumb',
      JointType.rightThumb => 'Right Thumb',
      JointType.leftHip => 'Left Hip',
      JointType.rightHip => 'Right Hip',
      JointType.hip => 'Hip',
      JointType.leftKnee => 'Left Knee',
      JointType.rightKnee => 'Right Knee',
      JointType.leftAnkle => 'Left Ankle',
      JointType.rightAnkle => 'Right Ankle',
      JointType.leftHeel => 'Left Heel',
      JointType.rightHeel => 'Right Heel',
      JointType.leftFootIndex => 'Left Toe',
      JointType.rightFootIndex => 'Right Toe',
    };
  }

  /// Display name for each category
  static String getCategoryDisplayName(JointCategory category) {
    return switch (category) {
      JointCategory.face => 'Face',
      JointCategory.upperBody => 'Upper Body',
      JointCategory.hands => 'Hands',
      JointCategory.lowerBody => 'Lower Body',
      JointCategory.feet => 'Feet',
    };
  }

  /// Get all joints in a category
  static List<JointType> getJointsInCategory(JointCategory category) {
    return JointType.values
        .where((type) => getCategoryForJoint(type) == category)
        .toList();
  }

  /// Simplified skeleton connections for running analysis
  /// Uses single shoulder and hip (no triangles) for proper segment locking
  /// Structure: head -> shoulder -> hip, with arms and legs branching off
  static List<JointConnection> get defaultConnections => const [
        // Spine chain (no triangles)
        JointConnection(from: JointType.nose, to: JointType.shoulder),
        JointConnection(from: JointType.shoulder, to: JointType.hip),

        // Left arm chain
        JointConnection(from: JointType.shoulder, to: JointType.leftElbow),
        JointConnection(from: JointType.leftElbow, to: JointType.leftWrist),

        // Right arm chain
        JointConnection(from: JointType.shoulder, to: JointType.rightElbow),
        JointConnection(from: JointType.rightElbow, to: JointType.rightWrist),

        // Left leg chain (hip -> knee -> heel -> toe)
        JointConnection(from: JointType.hip, to: JointType.leftKnee),
        JointConnection(from: JointType.leftKnee, to: JointType.leftHeel),
        JointConnection(from: JointType.leftHeel, to: JointType.leftFootIndex),

        // Right leg chain (hip -> knee -> heel -> toe)
        JointConnection(from: JointType.hip, to: JointType.rightKnee),
        JointConnection(from: JointType.rightKnee, to: JointType.rightHeel),
        JointConnection(from: JointType.rightHeel, to: JointType.rightFootIndex),
      ];

  /// The simplified set of joints used for running analysis (11 joints total)
  static const Set<JointType> simplifiedJoints = {
    JointType.nose,           // Head
    JointType.shoulder,       // Single shoulder (midpoint)
    JointType.leftElbow,      // Left elbow
    JointType.rightElbow,     // Right elbow
    JointType.leftWrist,      // Left hand
    JointType.rightWrist,     // Right hand
    JointType.hip,            // Single hip (midpoint)
    JointType.leftKnee,       // Left knee
    JointType.rightKnee,      // Right knee
    JointType.leftHeel,       // Left heel
    JointType.rightHeel,      // Right heel
    JointType.leftFootIndex,  // Left toe
    JointType.rightFootIndex, // Right toe
  };

  /// Default visibility - only show simplified joints for running analysis
  static Map<JointType, bool> get defaultVisibility {
    final Map<JointType, bool> visibility = {};
    for (final joint in JointType.values) {
      visibility[joint] = simplifiedJoints.contains(joint);
    }
    return visibility;
  }
}
