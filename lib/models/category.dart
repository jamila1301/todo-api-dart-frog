import 'package:postgres/postgres.dart';

/// {@template category}
/// Category model
/// {@endtemplate}
class Category {
  /// {@macro category}
  const Category({
    required this.id,
    required this.title,
  });

  /// {@macro category}
  factory Category.fromRow(ResultRow row) {
    return Category(
      id: row[0]! as int,
      title: row[1]! as String,
    );
  }

  /// id of the category
  final int id;

  /// title of the category
  final String title;
}
