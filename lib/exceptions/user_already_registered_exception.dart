/// {@template user_already_registered_exception}
/// Exception thrown when the user is already registered.
/// {@endtemplate}
class UserAlreadyRegisteredException implements Exception {
  /// {@macro user_already_registered_exception}
  const UserAlreadyRegisteredException(this.message);

  /// message
  final String message;

  @override
  String toString() => 'UserAlreadyRegisteredException: $message';
}
