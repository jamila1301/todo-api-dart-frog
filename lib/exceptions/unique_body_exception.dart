/// {@template unique_body_exception}
/// Exception thrown when the user is already registered.
/// {@endtemplate}
class UniqueBodyException implements Exception {
  /// {@macro unique_body_exception}
  const UniqueBodyException(this.message);

  /// message
  final String message;

  @override
  String toString() => 'UniqueBodyException: $message';
}
