class UserDoesNotExistException implements Exception {
  const UserDoesNotExistException(this.message);

  final String message;

  @override
  String toString() => 'UserDoesNotExistException: $message';
}
