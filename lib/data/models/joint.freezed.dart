// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'joint.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Joint _$JointFromJson(Map<String, dynamic> json) {
  return _Joint.fromJson(json);
}

/// @nodoc
mixin _$Joint {
  JointType get type => throw _privateConstructorUsedError;

  /// Position normalized to 0-1 range relative to image dimensions
  double get x => throw _privateConstructorUsedError;
  double get y => throw _privateConstructorUsedError;

  /// Confidence score from ML Kit (0-1)
  double get confidence => throw _privateConstructorUsedError;

  /// Whether this joint is visible in the overlay
  bool get isVisible => throw _privateConstructorUsedError;

  /// Whether the user has manually adjusted this joint's position
  bool get isManuallyAdjusted => throw _privateConstructorUsedError;

  /// Serializes this Joint to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Joint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JointCopyWith<Joint> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JointCopyWith<$Res> {
  factory $JointCopyWith(Joint value, $Res Function(Joint) then) =
      _$JointCopyWithImpl<$Res, Joint>;
  @useResult
  $Res call({
    JointType type,
    double x,
    double y,
    double confidence,
    bool isVisible,
    bool isManuallyAdjusted,
  });
}

/// @nodoc
class _$JointCopyWithImpl<$Res, $Val extends Joint>
    implements $JointCopyWith<$Res> {
  _$JointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Joint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? x = null,
    Object? y = null,
    Object? confidence = null,
    Object? isVisible = null,
    Object? isManuallyAdjusted = null,
  }) {
    return _then(
      _value.copyWith(
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as JointType,
            x: null == x
                ? _value.x
                : x // ignore: cast_nullable_to_non_nullable
                      as double,
            y: null == y
                ? _value.y
                : y // ignore: cast_nullable_to_non_nullable
                      as double,
            confidence: null == confidence
                ? _value.confidence
                : confidence // ignore: cast_nullable_to_non_nullable
                      as double,
            isVisible: null == isVisible
                ? _value.isVisible
                : isVisible // ignore: cast_nullable_to_non_nullable
                      as bool,
            isManuallyAdjusted: null == isManuallyAdjusted
                ? _value.isManuallyAdjusted
                : isManuallyAdjusted // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$JointImplCopyWith<$Res> implements $JointCopyWith<$Res> {
  factory _$$JointImplCopyWith(
    _$JointImpl value,
    $Res Function(_$JointImpl) then,
  ) = __$$JointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    JointType type,
    double x,
    double y,
    double confidence,
    bool isVisible,
    bool isManuallyAdjusted,
  });
}

/// @nodoc
class __$$JointImplCopyWithImpl<$Res>
    extends _$JointCopyWithImpl<$Res, _$JointImpl>
    implements _$$JointImplCopyWith<$Res> {
  __$$JointImplCopyWithImpl(
    _$JointImpl _value,
    $Res Function(_$JointImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Joint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? x = null,
    Object? y = null,
    Object? confidence = null,
    Object? isVisible = null,
    Object? isManuallyAdjusted = null,
  }) {
    return _then(
      _$JointImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as JointType,
        x: null == x
            ? _value.x
            : x // ignore: cast_nullable_to_non_nullable
                  as double,
        y: null == y
            ? _value.y
            : y // ignore: cast_nullable_to_non_nullable
                  as double,
        confidence: null == confidence
            ? _value.confidence
            : confidence // ignore: cast_nullable_to_non_nullable
                  as double,
        isVisible: null == isVisible
            ? _value.isVisible
            : isVisible // ignore: cast_nullable_to_non_nullable
                  as bool,
        isManuallyAdjusted: null == isManuallyAdjusted
            ? _value.isManuallyAdjusted
            : isManuallyAdjusted // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$JointImpl extends _Joint {
  const _$JointImpl({
    required this.type,
    required this.x,
    required this.y,
    this.confidence = 1.0,
    this.isVisible = true,
    this.isManuallyAdjusted = false,
  }) : super._();

  factory _$JointImpl.fromJson(Map<String, dynamic> json) =>
      _$$JointImplFromJson(json);

  @override
  final JointType type;

  /// Position normalized to 0-1 range relative to image dimensions
  @override
  final double x;
  @override
  final double y;

  /// Confidence score from ML Kit (0-1)
  @override
  @JsonKey()
  final double confidence;

  /// Whether this joint is visible in the overlay
  @override
  @JsonKey()
  final bool isVisible;

  /// Whether the user has manually adjusted this joint's position
  @override
  @JsonKey()
  final bool isManuallyAdjusted;

  @override
  String toString() {
    return 'Joint(type: $type, x: $x, y: $y, confidence: $confidence, isVisible: $isVisible, isManuallyAdjusted: $isManuallyAdjusted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JointImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            (identical(other.isVisible, isVisible) ||
                other.isVisible == isVisible) &&
            (identical(other.isManuallyAdjusted, isManuallyAdjusted) ||
                other.isManuallyAdjusted == isManuallyAdjusted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    type,
    x,
    y,
    confidence,
    isVisible,
    isManuallyAdjusted,
  );

  /// Create a copy of Joint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JointImplCopyWith<_$JointImpl> get copyWith =>
      __$$JointImplCopyWithImpl<_$JointImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$JointImplToJson(this);
  }
}

abstract class _Joint extends Joint {
  const factory _Joint({
    required final JointType type,
    required final double x,
    required final double y,
    final double confidence,
    final bool isVisible,
    final bool isManuallyAdjusted,
  }) = _$JointImpl;
  const _Joint._() : super._();

  factory _Joint.fromJson(Map<String, dynamic> json) = _$JointImpl.fromJson;

  @override
  JointType get type;

  /// Position normalized to 0-1 range relative to image dimensions
  @override
  double get x;
  @override
  double get y;

  /// Confidence score from ML Kit (0-1)
  @override
  double get confidence;

  /// Whether this joint is visible in the overlay
  @override
  bool get isVisible;

  /// Whether the user has manually adjusted this joint's position
  @override
  bool get isManuallyAdjusted;

  /// Create a copy of Joint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JointImplCopyWith<_$JointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
