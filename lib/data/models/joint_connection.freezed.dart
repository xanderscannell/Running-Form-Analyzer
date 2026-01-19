// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'joint_connection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$JointConnection {
  JointType get from => throw _privateConstructorUsedError;
  JointType get to => throw _privateConstructorUsedError;

  /// Create a copy of JointConnection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JointConnectionCopyWith<JointConnection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JointConnectionCopyWith<$Res> {
  factory $JointConnectionCopyWith(
    JointConnection value,
    $Res Function(JointConnection) then,
  ) = _$JointConnectionCopyWithImpl<$Res, JointConnection>;
  @useResult
  $Res call({JointType from, JointType to});
}

/// @nodoc
class _$JointConnectionCopyWithImpl<$Res, $Val extends JointConnection>
    implements $JointConnectionCopyWith<$Res> {
  _$JointConnectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JointConnection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? from = null, Object? to = null}) {
    return _then(
      _value.copyWith(
            from: null == from
                ? _value.from
                : from // ignore: cast_nullable_to_non_nullable
                      as JointType,
            to: null == to
                ? _value.to
                : to // ignore: cast_nullable_to_non_nullable
                      as JointType,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$JointConnectionImplCopyWith<$Res>
    implements $JointConnectionCopyWith<$Res> {
  factory _$$JointConnectionImplCopyWith(
    _$JointConnectionImpl value,
    $Res Function(_$JointConnectionImpl) then,
  ) = __$$JointConnectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({JointType from, JointType to});
}

/// @nodoc
class __$$JointConnectionImplCopyWithImpl<$Res>
    extends _$JointConnectionCopyWithImpl<$Res, _$JointConnectionImpl>
    implements _$$JointConnectionImplCopyWith<$Res> {
  __$$JointConnectionImplCopyWithImpl(
    _$JointConnectionImpl _value,
    $Res Function(_$JointConnectionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JointConnection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? from = null, Object? to = null}) {
    return _then(
      _$JointConnectionImpl(
        from: null == from
            ? _value.from
            : from // ignore: cast_nullable_to_non_nullable
                  as JointType,
        to: null == to
            ? _value.to
            : to // ignore: cast_nullable_to_non_nullable
                  as JointType,
      ),
    );
  }
}

/// @nodoc

class _$JointConnectionImpl implements _JointConnection {
  const _$JointConnectionImpl({required this.from, required this.to});

  @override
  final JointType from;
  @override
  final JointType to;

  @override
  String toString() {
    return 'JointConnection(from: $from, to: $to)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JointConnectionImpl &&
            (identical(other.from, from) || other.from == from) &&
            (identical(other.to, to) || other.to == to));
  }

  @override
  int get hashCode => Object.hash(runtimeType, from, to);

  /// Create a copy of JointConnection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JointConnectionImplCopyWith<_$JointConnectionImpl> get copyWith =>
      __$$JointConnectionImplCopyWithImpl<_$JointConnectionImpl>(
        this,
        _$identity,
      );
}

abstract class _JointConnection implements JointConnection {
  const factory _JointConnection({
    required final JointType from,
    required final JointType to,
  }) = _$JointConnectionImpl;

  @override
  JointType get from;
  @override
  JointType get to;

  /// Create a copy of JointConnection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JointConnectionImplCopyWith<_$JointConnectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
