/// {@template user_does_not_exist_exception}
/// Exception thrown when the user does not exist.
/// {@endtemplate}
class UserDoesNotExistException implements Exception {
  /// {@macro user_does_not_exist_exception}
  const UserDoesNotExistException(this.message);

  /// message
  final String message;

  @override
  String toString() => 'UserDoesNotExistException: $message';
}
