// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'saved_analysis.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SavedAnalysis _$SavedAnalysisFromJson(Map<String, dynamic> json) {
  return _SavedAnalysis.fromJson(json);
}

/// @nodoc
mixin _$SavedAnalysis {
  /// Unique identifier (UUID)
  String get id => throw _privateConstructorUsedError;

  /// Name of the athlete
  String get athleteName => throw _privateConstructorUsedError;

  /// Path to the saved cropped image
  String get imagePath => throw _privateConstructorUsedError;

  /// Path to the thumbnail image
  String get thumbnailPath => throw _privateConstructorUsedError;

  /// The skeleton pose data
  Skeleton get skeleton => throw _privateConstructorUsedError;

  /// When the analysis was saved
  DateTime get savedAt => throw _privateConstructorUsedError;

  /// Serializes this SavedAnalysis to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SavedAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SavedAnalysisCopyWith<SavedAnalysis> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SavedAnalysisCopyWith<$Res> {
  factory $SavedAnalysisCopyWith(
    SavedAnalysis value,
    $Res Function(SavedAnalysis) then,
  ) = _$SavedAnalysisCopyWithImpl<$Res, SavedAnalysis>;
  @useResult
  $Res call({
    String id,
    String athleteName,
    String imagePath,
    String thumbnailPath,
    Skeleton skeleton,
    DateTime savedAt,
  });

  $SkeletonCopyWith<$Res> get skeleton;
}

/// @nodoc
class _$SavedAnalysisCopyWithImpl<$Res, $Val extends SavedAnalysis>
    implements $SavedAnalysisCopyWith<$Res> {
  _$SavedAnalysisCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SavedAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? athleteName = null,
    Object? imagePath = null,
    Object? thumbnailPath = null,
    Object? skeleton = null,
    Object? savedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            athleteName: null == athleteName
                ? _value.athleteName
                : athleteName // ignore: cast_nullable_to_non_nullable
                      as String,
            imagePath: null == imagePath
                ? _value.imagePath
                : imagePath // ignore: cast_nullable_to_non_nullable
                      as String,
            thumbnailPath: null == thumbnailPath
                ? _value.thumbnailPath
                : thumbnailPath // ignore: cast_nullable_to_non_nullable
                      as String,
            skeleton: null == skeleton
                ? _value.skeleton
                : skeleton // ignore: cast_nullable_to_non_nullable
                      as Skeleton,
            savedAt: null == savedAt
                ? _value.savedAt
                : savedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }

  /// Create a copy of SavedAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SkeletonCopyWith<$Res> get skeleton {
    return $SkeletonCopyWith<$Res>(_value.skeleton, (value) {
      return _then(_value.copyWith(skeleton: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SavedAnalysisImplCopyWith<$Res>
    implements $SavedAnalysisCopyWith<$Res> {
  factory _$$SavedAnalysisImplCopyWith(
    _$SavedAnalysisImpl value,
    $Res Function(_$SavedAnalysisImpl) then,
  ) = __$$SavedAnalysisImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String athleteName,
    String imagePath,
    String thumbnailPath,
    Skeleton skeleton,
    DateTime savedAt,
  });

  @override
  $SkeletonCopyWith<$Res> get skeleton;
}

/// @nodoc
class __$$SavedAnalysisImplCopyWithImpl<$Res>
    extends _$SavedAnalysisCopyWithImpl<$Res, _$SavedAnalysisImpl>
    implements _$$SavedAnalysisImplCopyWith<$Res> {
  __$$SavedAnalysisImplCopyWithImpl(
    _$SavedAnalysisImpl _value,
    $Res Function(_$SavedAnalysisImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SavedAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? athleteName = null,
    Object? imagePath = null,
    Object? thumbnailPath = null,
    Object? skeleton = null,
    Object? savedAt = null,
  }) {
    return _then(
      _$SavedAnalysisImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        athleteName: null == athleteName
            ? _value.athleteName
            : athleteName // ignore: cast_nullable_to_non_nullable
                  as String,
        imagePath: null == imagePath
            ? _value.imagePath
            : imagePath // ignore: cast_nullable_to_non_nullable
                  as String,
        thumbnailPath: null == thumbnailPath
            ? _value.thumbnailPath
            : thumbnailPath // ignore: cast_nullable_to_non_nullable
                  as String,
        skeleton: null == skeleton
            ? _value.skeleton
            : skeleton // ignore: cast_nullable_to_non_nullable
                  as Skeleton,
        savedAt: null == savedAt
            ? _value.savedAt
            : savedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SavedAnalysisImpl implements _SavedAnalysis {
  const _$SavedAnalysisImpl({
    required this.id,
    required this.athleteName,
    required this.imagePath,
    required this.thumbnailPath,
    required this.skeleton,
    required this.savedAt,
  });

  factory _$SavedAnalysisImpl.fromJson(Map<String, dynamic> json) =>
      _$$SavedAnalysisImplFromJson(json);

  /// Unique identifier (UUID)
  @override
  final String id;

  /// Name of the athlete
  @override
  final String athleteName;

  /// Path to the saved cropped image
  @override
  final String imagePath;

  /// Path to the thumbnail image
  @override
  final String thumbnailPath;

  /// The skeleton pose data
  @override
  final Skeleton skeleton;

  /// When the analysis was saved
  @override
  final DateTime savedAt;

  @override
  String toString() {
    return 'SavedAnalysis(id: $id, athleteName: $athleteName, imagePath: $imagePath, thumbnailPath: $thumbnailPath, skeleton: $skeleton, savedAt: $savedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SavedAnalysisImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.athleteName, athleteName) ||
                other.athleteName == athleteName) &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath) &&
            (identical(other.thumbnailPath, thumbnailPath) ||
                other.thumbnailPath == thumbnailPath) &&
            (identical(other.skeleton, skeleton) ||
                other.skeleton == skeleton) &&
            (identical(other.savedAt, savedAt) || other.savedAt == savedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    athleteName,
    imagePath,
    thumbnailPath,
    skeleton,
    savedAt,
  );

  /// Create a copy of SavedAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SavedAnalysisImplCopyWith<_$SavedAnalysisImpl> get copyWith =>
      __$$SavedAnalysisImplCopyWithImpl<_$SavedAnalysisImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SavedAnalysisImplToJson(this);
  }
}

abstract class _SavedAnalysis implements SavedAnalysis {
  const factory _SavedAnalysis({
    required final String id,
    required final String athleteName,
    required final String imagePath,
    required final String thumbnailPath,
    required final Skeleton skeleton,
    required final DateTime savedAt,
  }) = _$SavedAnalysisImpl;

  factory _SavedAnalysis.fromJson(Map<String, dynamic> json) =
      _$SavedAnalysisImpl.fromJson;

  /// Unique identifier (UUID)
  @override
  String get id;

  /// Name of the athlete
  @override
  String get athleteName;

  /// Path to the saved cropped image
  @override
  String get imagePath;

  /// Path to the thumbnail image
  @override
  String get thumbnailPath;

  /// The skeleton pose data
  @override
  Skeleton get skeleton;

  /// When the analysis was saved
  @override
  DateTime get savedAt;

  /// Create a copy of SavedAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SavedAnalysisImplCopyWith<_$SavedAnalysisImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
