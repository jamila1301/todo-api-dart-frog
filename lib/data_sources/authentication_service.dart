import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:todo_api/database/database_connector.dart';
import 'package:todo_api/exceptions/incorrect_credentials_exception.dart';
import 'package:todo_api/exceptions/user_already_registered_exception.dart';
import 'package:todo_api/models/user.dart';

// ignore: public_member_api_docs
final class AuthenticationService {
  // ignore: public_member_api_docs
  AuthenticationService({
    required this.connector,
  });
  // ignore: public_member_api_docs
  final DatabaseConnector connector;

  /// list of users
  Future<User> getUser(int id) async {
    final result = await connector.connection!.execute(
      'SELECT * FROM users '
      'WHERE id = $id',
    );

    final userRow = result.first;

    return User(
      id: userRow[0]! as int,
      fullName: userRow[1]! as String,
      username: userRow[2]! as String,
    );
  }

// ignore: public_member_api_docs
  Future<User?> login({
    required String username,
    required String password,
  }) async {
    final digest = sha256.convert(utf8.encode(password));

    final userResult = await connector.connection!.execute(
      "SELECT * FROM users WHERE user_name = '$username'",
    );

    if (userResult.isEmpty) {
      throw const IncorrectCredentialsException(
        'Credentials are incorrect!',
      );
    }

    final userRow = userResult.first;
    final isPasswordEqual = (userRow[3]! as String) == digest.toString();

    if (!isPasswordEqual) {
      throw const IncorrectCredentialsException(
        'Credentials are incorrect!',
      );
    }

    return User(
      id: userRow[0]! as int,
      username: userRow[1]! as String,
      fullName: userRow[2]! as String,
    );
  }

// ignore: public_member_api_docs
  Future<User> register({
    required String fullName,
    required String username,
    required String password,
  }) async {
    try {
      final digest = sha256.convert(utf8.encode(password));

      final result = await connector.connection!.execute(
        'INSERT INTO users (full_name, user_name, password) '
        "VALUES('$fullName', '$username', '$digest')",
      );

      if (result.affectedRows == 0) {
        throw Exception('User not created!');
      }

      final userResult = await connector.connection!.execute(
        "SELECT * FROM users WHERE user_name = '$username'",
      );

      final userRow = userResult.first;

      return User(
        id: userRow[0]! as int,
        username: userRow[1]! as String,
        fullName: userRow[2]! as String,
      );
    } catch (e) {
      throw UserAlreadyRegisteredException(e.toString());
    }
  }
}
