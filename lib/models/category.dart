import 'package:postgres/postgres.dart';

class Category {
  const Category({
    required this.id,
    required this.title,
  });

  factory Category.fromRow(ResultRow row) {
    return Category(
      id: row[0]! as int,
      title: row[1]! as String,
    );
  }

  final int id;
  final String title;
}
