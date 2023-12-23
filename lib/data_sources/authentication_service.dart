import 'package:todo_api/exceptions/user_already_registered_exception.dart';
import 'package:todo_api/exceptions/user_does_not_exist_exception.dart';
import 'package:todo_api/models/user.dart';

// ignore: public_member_api_docs
final class AuthenticationService {
  final _userDb = <String, User>{};

// ignore: public_member_api_docs
  Future<User> login({
    required String username,
    required String password,
  }) async {
    if (!_userDb.containsKey(username)) {
      throw const UserDoesNotExistException(
        'User is not registered!',
      );
    }

    return _userDb[username]!;
  }

// ignore: public_member_api_docs
  Future<void> register({
    required String fullName,
    required String username,
    required String password,
  }) async {
    if (_userDb.containsKey(username)) {
      throw UserAlreadyRegisteredException(
        'Username: $username already exists',
      );
    }

    final id = _userDb.length.toString();

    final user = User(
      id: id,
      fullName: fullName,
      username: username,
      password: password,
    );

    _userDb[username] = user;
  }
}
