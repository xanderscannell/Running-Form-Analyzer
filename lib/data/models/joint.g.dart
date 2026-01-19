// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'joint.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JointImpl _$$JointImplFromJson(Map<String, dynamic> json) => _$JointImpl(
  type: $enumDecode(_$JointTypeEnumMap, json['type']),
  x: (json['x'] as num).toDouble(),
  y: (json['y'] as num).toDouble(),
  confidence: (json['confidence'] as num?)?.toDouble() ?? 1.0,
  isVisible: json['isVisible'] as bool? ?? true,
  isManuallyAdjusted: json['isManuallyAdjusted'] as bool? ?? false,
);

Map<String, dynamic> _$$JointImplToJson(_$JointImpl instance) =>
    <String, dynamic>{
      'type': _$JointTypeEnumMap[instance.type]!,
      'x': instance.x,
      'y': instance.y,
      'confidence': instance.confidence,
      'isVisible': instance.isVisible,
      'isManuallyAdjusted': instance.isManuallyAdjusted,
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
