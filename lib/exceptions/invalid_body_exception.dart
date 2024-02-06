/// {@template invalid_body_exception}
/// Exception thrown when the user is already registered.
/// {@endtemplate}
class InvalidBodyException implements Exception {
  /// {@macro invalid_body_exception}
  const InvalidBodyException(this.message);

  /// message
  final String message;

  @override
  String toString() => 'InvalidBodyException: $message';
}
