import 'package:freezed_annotation/freezed_annotation.dart';
import 'joint.dart';

part 'joint_connection.freezed.dart';
part 'joint_connection.g.dart';

/// Represents a connection (line) between two joints in the skeleton
@freezed
class JointConnection with _$JointConnection {
  const factory JointConnection({
    required JointType from,
    required JointType to,
  }) = _JointConnection;

  factory JointConnection.fromJson(Map<String, dynamic> json) =>
      _$JointConnectionFromJson(json);
}
