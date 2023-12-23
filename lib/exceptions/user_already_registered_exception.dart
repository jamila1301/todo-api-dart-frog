class UserAlreadyRegisteredException implements Exception {
  const UserAlreadyRegisteredException(this.message);

  final String message;

  @override
  String toString() => 'UserAlreadyRegisteredException: $message';
}
