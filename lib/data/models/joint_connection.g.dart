// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'joint_connection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JointConnectionImpl _$$JointConnectionImplFromJson(
  Map<String, dynamic> json,
) => _$JointConnectionImpl(
  from: $enumDecode(_$JointTypeEnumMap, json['from']),
  to: $enumDecode(_$JointTypeEnumMap, json['to']),
);

Map<String, dynamic> _$$JointConnectionImplToJson(
  _$JointConnectionImpl instance,
) => <String, dynamic>{
  'from': _$JointTypeEnumMap[instance.from]!,
  'to': _$JointTypeEnumMap[instance.to]!,
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
