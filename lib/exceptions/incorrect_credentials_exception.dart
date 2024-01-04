/// {@template incorrect_credentials_exception}
/// Exception thrown when the credentials are incorrect.
/// {@endtemplate}
class IncorrectCredentialsException implements Exception {
  /// {@macro incorrect_credentials_exception}
  const IncorrectCredentialsException(this.message);

  /// message
  final String message;

  @override
  String toString() => 'IncorrectCredentialsException: $message';
}
