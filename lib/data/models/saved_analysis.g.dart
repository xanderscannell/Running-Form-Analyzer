// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_analysis.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SavedAnalysisImpl _$$SavedAnalysisImplFromJson(Map<String, dynamic> json) =>
    _$SavedAnalysisImpl(
      id: json['id'] as String,
      athleteName: json['athleteName'] as String,
      imagePath: json['imagePath'] as String,
      thumbnailPath: json['thumbnailPath'] as String,
      skeleton: Skeleton.fromJson(json['skeleton'] as Map<String, dynamic>),
      savedAt: DateTime.parse(json['savedAt'] as String),
    );

Map<String, dynamic> _$$SavedAnalysisImplToJson(_$SavedAnalysisImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'athleteName': instance.athleteName,
      'imagePath': instance.imagePath,
      'thumbnailPath': instance.thumbnailPath,
      'skeleton': instance.skeleton,
      'savedAt': instance.savedAt.toIso8601String(),
    };
