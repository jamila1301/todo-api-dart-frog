class IncorrectCredentialsException implements Exception {
  const IncorrectCredentialsException(this.message);

  final String message;

  @override
  String toString() => 'IncorrectCredentialsException: $message';
}
