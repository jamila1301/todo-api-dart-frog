import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// User Model
@JsonSerializable()
class User extends Equatable {
  /// Contructor
  const User({
    required this.id,
    required this.username,
    required this.password,
    required this.fullName,
  });

  /// fromJson of User
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// id
  final String id;

  /// username
  final String username;

  /// password
  @JsonKey(includeToJson: false)
  final String password;

  /// fullName
  final String fullName;

  /// toJson of User model
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object?> get props => [id, username, password, fullName];
}
