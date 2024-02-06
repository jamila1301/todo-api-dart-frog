/// {@template user_already_registered_exception}
/// Exception thrown when the user is already registered.
/// {@endtemplate}
class EmptyDataException implements Exception {
  /// {@macro user_already_registered_exception}
  const EmptyDataException(this.message);

  /// message
  final String message;

  @override
  String toString() => 'EmptyDataException: $message';
}
