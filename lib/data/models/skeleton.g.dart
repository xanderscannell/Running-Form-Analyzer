// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skeleton.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SkeletonImpl _$$SkeletonImplFromJson(Map<String, dynamic> json) =>
    _$SkeletonImpl(
      joints: (json['joints'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
          $enumDecode(_$JointTypeEnumMap, k),
          Joint.fromJson(e as Map<String, dynamic>),
        ),
      ),
      connections: (json['connections'] as List<dynamic>)
          .map((e) => JointConnection.fromJson(e as Map<String, dynamic>))
          .toList(),
      isDetected: json['isDetected'] as bool? ?? false,
      segmentLockEnabled: json['segmentLockEnabled'] as bool? ?? false,
      segmentLengths:
          (json['segmentLengths'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ) ??
          const {},
      imageAspectRatio: (json['imageAspectRatio'] as num?)?.toDouble() ?? 1.0,
      detectedAt: json['detectedAt'] == null
          ? null
          : DateTime.parse(json['detectedAt'] as String),
    );

Map<String, dynamic> _$$SkeletonImplToJson(
  _$SkeletonImpl instance,
) => <String, dynamic>{
  'joints': instance.joints.map((k, e) => MapEntry(_$JointTypeEnumMap[k]!, e)),
  'connections': instance.connections,
  'isDetected': instance.isDetected,
  'segmentLockEnabled': instance.segmentLockEnabled,
  'segmentLengths': instance.segmentLengths,
  'imageAspectRatio': instance.imageAspectRatio,
  'detectedAt': instance.detectedAt?.toIso8601String(),
};

const _$JointTypeEnumMap = {
  JointType.nose: 'nose',
  JointType.leftEyeInner: 'leftEyeInner',
  JointType.leftEye: 'leftEye',
  JointType.leftEyeOuter: 'leftEyeOuter',
  JointType.rightEyeInner: 'rightEyeInner',
  JointType.rightEye: 'rightEye',
  JointType.rightEyeOuter: 'rightEyeOuter',
  JointType.leftEar: 'leftEar',
  JointType.rightEar: 'rightEar',
  JointType.leftMouth: 'leftMouth',
  JointType.rightMouth: 'rightMouth',
  JointType.leftShoulder: 'leftShoulder',
  JointType.rightShoulder: 'rightShoulder',
  JointType.leftElbow: 'leftElbow',
  JointType.rightElbow: 'rightElbow',
  JointType.leftWrist: 'leftWrist',
  JointType.rightWrist: 'rightWrist',
  JointType.leftPinky: 'leftPinky',
  JointType.rightPinky: 'rightPinky',
  JointType.leftIndex: 'leftIndex',
  JointType.rightIndex: 'rightIndex',
  JointType.leftThumb: 'leftThumb',
  JointType.rightThumb: 'rightThumb',
  JointType.leftHip: 'leftHip',
  JointType.rightHip: 'rightHip',
  JointType.leftKnee: 'leftKnee',
  JointType.rightKnee: 'rightKnee',
  JointType.leftAnkle: 'leftAnkle',
  JointType.rightAnkle: 'rightAnkle',
  JointType.leftHeel: 'leftHeel',
  JointType.rightHeel: 'rightHeel',
  JointType.leftFootIndex: 'leftFootIndex',
  JointType.rightFootIndex: 'rightFootIndex',
  JointType.shoulder: 'shoulder',
  JointType.hip: 'hip',
};
