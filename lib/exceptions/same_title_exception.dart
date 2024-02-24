/// {@template same_title_exception}
/// Exception thrown when the same name given for to-do or category
/// {@endtemplate}
class SameTitleException implements Exception {
  /// {@macro same_title_exception}
  const SameTitleException(this.message);

  /// message
  final String message;

  @override
  String toString() => 'SameTitleException: $message';
}
