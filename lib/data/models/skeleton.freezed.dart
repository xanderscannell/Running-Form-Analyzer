// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'skeleton.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Skeleton _$SkeletonFromJson(Map<String, dynamic> json) {
  return _Skeleton.fromJson(json);
}

/// @nodoc
mixin _$Skeleton {
  Map<JointType, Joint> get joints => throw _privateConstructorUsedError;
  List<JointConnection> get connections => throw _privateConstructorUsedError;
  bool get isDetected => throw _privateConstructorUsedError;
  bool get segmentLockEnabled => throw _privateConstructorUsedError;

  /// Stored segment lengths (aspect-corrected) when lock is enabled
  Map<String, double> get segmentLengths => throw _privateConstructorUsedError;

  /// Image aspect ratio (width/height) used for segment length calculations
  double get imageAspectRatio => throw _privateConstructorUsedError;
  DateTime? get detectedAt => throw _privateConstructorUsedError;

  /// Serializes this Skeleton to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Skeleton
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SkeletonCopyWith<Skeleton> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SkeletonCopyWith<$Res> {
  factory $SkeletonCopyWith(Skeleton value, $Res Function(Skeleton) then) =
      _$SkeletonCopyWithImpl<$Res, Skeleton>;
  @useResult
  $Res call({
    Map<JointType, Joint> joints,
    List<JointConnection> connections,
    bool isDetected,
    bool segmentLockEnabled,
    Map<String, double> segmentLengths,
    double imageAspectRatio,
    DateTime? detectedAt,
  });
}

/// @nodoc
class _$SkeletonCopyWithImpl<$Res, $Val extends Skeleton>
    implements $SkeletonCopyWith<$Res> {
  _$SkeletonCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Skeleton
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? joints = null,
    Object? connections = null,
    Object? isDetected = null,
    Object? segmentLockEnabled = null,
    Object? segmentLengths = null,
    Object? imageAspectRatio = null,
    Object? detectedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            joints: null == joints
                ? _value.joints
                : joints // ignore: cast_nullable_to_non_nullable
                      as Map<JointType, Joint>,
            connections: null == connections
                ? _value.connections
                : connections // ignore: cast_nullable_to_non_nullable
                      as List<JointConnection>,
            isDetected: null == isDetected
                ? _value.isDetected
                : isDetected // ignore: cast_nullable_to_non_nullable
                      as bool,
            segmentLockEnabled: null == segmentLockEnabled
                ? _value.segmentLockEnabled
                : segmentLockEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            segmentLengths: null == segmentLengths
                ? _value.segmentLengths
                : segmentLengths // ignore: cast_nullable_to_non_nullable
                      as Map<String, double>,
            imageAspectRatio: null == imageAspectRatio
                ? _value.imageAspectRatio
                : imageAspectRatio // ignore: cast_nullable_to_non_nullable
                      as double,
            detectedAt: freezed == detectedAt
                ? _value.detectedAt
                : detectedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SkeletonImplCopyWith<$Res>
    implements $SkeletonCopyWith<$Res> {
  factory _$$SkeletonImplCopyWith(
    _$SkeletonImpl value,
    $Res Function(_$SkeletonImpl) then,
  ) = __$$SkeletonImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    Map<JointType, Joint> joints,
    List<JointConnection> connections,
    bool isDetected,
    bool segmentLockEnabled,
    Map<String, double> segmentLengths,
    double imageAspectRatio,
    DateTime? detectedAt,
  });
}

/// @nodoc
class __$$SkeletonImplCopyWithImpl<$Res>
    extends _$SkeletonCopyWithImpl<$Res, _$SkeletonImpl>
    implements _$$SkeletonImplCopyWith<$Res> {
  __$$SkeletonImplCopyWithImpl(
    _$SkeletonImpl _value,
    $Res Function(_$SkeletonImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Skeleton
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? joints = null,
    Object? connections = null,
    Object? isDetected = null,
    Object? segmentLockEnabled = null,
    Object? segmentLengths = null,
    Object? imageAspectRatio = null,
    Object? detectedAt = freezed,
  }) {
    return _then(
      _$SkeletonImpl(
        joints: null == joints
            ? _value._joints
            : joints // ignore: cast_nullable_to_non_nullable
                  as Map<JointType, Joint>,
        connections: null == connections
            ? _value._connections
            : connections // ignore: cast_nullable_to_non_nullable
                  as List<JointConnection>,
        isDetected: null == isDetected
            ? _value.isDetected
            : isDetected // ignore: cast_nullable_to_non_nullable
                  as bool,
        segmentLockEnabled: null == segmentLockEnabled
            ? _value.segmentLockEnabled
            : segmentLockEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        segmentLengths: null == segmentLengths
            ? _value._segmentLengths
            : segmentLengths // ignore: cast_nullable_to_non_nullable
                  as Map<String, double>,
        imageAspectRatio: null == imageAspectRatio
            ? _value.imageAspectRatio
            : imageAspectRatio // ignore: cast_nullable_to_non_nullable
                  as double,
        detectedAt: freezed == detectedAt
            ? _value.detectedAt
            : detectedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SkeletonImpl extends _Skeleton {
  const _$SkeletonImpl({
    required final Map<JointType, Joint> joints,
    required final List<JointConnection> connections,
    this.isDetected = false,
    this.segmentLockEnabled = false,
    final Map<String, double> segmentLengths = const {},
    this.imageAspectRatio = 1.0,
    this.detectedAt,
  }) : _joints = joints,
       _connections = connections,
       _segmentLengths = segmentLengths,
       super._();

  factory _$SkeletonImpl.fromJson(Map<String, dynamic> json) =>
      _$$SkeletonImplFromJson(json);

  final Map<JointType, Joint> _joints;
  @override
  Map<JointType, Joint> get joints {
    if (_joints is EqualUnmodifiableMapView) return _joints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_joints);
  }

  final List<JointConnection> _connections;
  @override
  List<JointConnection> get connections {
    if (_connections is EqualUnmodifiableListView) return _connections;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_connections);
  }

  @override
  @JsonKey()
  final bool isDetected;
  @override
  @JsonKey()
  final bool segmentLockEnabled;

  /// Stored segment lengths (aspect-corrected) when lock is enabled
  final Map<String, double> _segmentLengths;

  /// Stored segment lengths (aspect-corrected) when lock is enabled
  @override
  @JsonKey()
  Map<String, double> get segmentLengths {
    if (_segmentLengths is EqualUnmodifiableMapView) return _segmentLengths;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_segmentLengths);
  }

  /// Image aspect ratio (width/height) used for segment length calculations
  @override
  @JsonKey()
  final double imageAspectRatio;
  @override
  final DateTime? detectedAt;

  @override
  String toString() {
    return 'Skeleton(joints: $joints, connections: $connections, isDetected: $isDetected, segmentLockEnabled: $segmentLockEnabled, segmentLengths: $segmentLengths, imageAspectRatio: $imageAspectRatio, detectedAt: $detectedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SkeletonImpl &&
            const DeepCollectionEquality().equals(other._joints, _joints) &&
            const DeepCollectionEquality().equals(
              other._connections,
              _connections,
            ) &&
            (identical(other.isDetected, isDetected) ||
                other.isDetected == isDetected) &&
            (identical(other.segmentLockEnabled, segmentLockEnabled) ||
                other.segmentLockEnabled == segmentLockEnabled) &&
            const DeepCollectionEquality().equals(
              other._segmentLengths,
              _segmentLengths,
            ) &&
            (identical(other.imageAspectRatio, imageAspectRatio) ||
                other.imageAspectRatio == imageAspectRatio) &&
            (identical(other.detectedAt, detectedAt) ||
                other.detectedAt == detectedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_joints),
    const DeepCollectionEquality().hash(_connections),
    isDetected,
    segmentLockEnabled,
    const DeepCollectionEquality().hash(_segmentLengths),
    imageAspectRatio,
    detectedAt,
  );

  /// Create a copy of Skeleton
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SkeletonImplCopyWith<_$SkeletonImpl> get copyWith =>
      __$$SkeletonImplCopyWithImpl<_$SkeletonImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SkeletonImplToJson(this);
  }
}

abstract class _Skeleton extends Skeleton {
  const factory _Skeleton({
    required final Map<JointType, Joint> joints,
    required final List<JointConnection> connections,
    final bool isDetected,
    final bool segmentLockEnabled,
    final Map<String, double> segmentLengths,
    final double imageAspectRatio,
    final DateTime? detectedAt,
  }) = _$SkeletonImpl;
  const _Skeleton._() : super._();

  factory _Skeleton.fromJson(Map<String, dynamic> json) =
      _$SkeletonImpl.fromJson;

  @override
  Map<JointType, Joint> get joints;
  @override
  List<JointConnection> get connections;
  @override
  bool get isDetected;
  @override
  bool get segmentLockEnabled;

  /// Stored segment lengths (aspect-corrected) when lock is enabled
  @override
  Map<String, double> get segmentLengths;

  /// Image aspect ratio (width/height) used for segment length calculations
  @override
  double get imageAspectRatio;
  @override
  DateTime? get detectedAt;

  /// Create a copy of Skeleton
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SkeletonImplCopyWith<_$SkeletonImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
