import 'package:postgres/postgres.dart';

final class TodoDataSource {
  Connection? conn;

  // init connection async
  Future<void> initialize() async {
    conn = await Connection.open(
      Endpoint(
        host: 'localhost',
        database: 'todo',
        username: 'thisisyusub',
        password: '12345',
      ),
      settings: const ConnectionSettings(
        sslMode: SslMode.disable,
      ),
    );
  }

  // add new category
  Future<Map<String, dynamic>> addCategory(String name) async {
    await conn!.execute(
      "INSERT INTO category(title) VALUES('$name')",
    );

    final result = await conn!.execute(
      "SELECT * FROM category WHERE title='$name'",
    );

    return {
      'id': result[0][0]! as int,
      'title': result[0][1]! as String,
    };
  }

  // get categories
  Future<List<Map<String, dynamic>>> getCategories() async {
    final result = await conn!.execute('SELECT * FROM category');

    final categories = <Map<String, dynamic>>[];

    for (final row in result) {
      categories.add({
        'id': row[0]! as int,
        'title': row[1]! as String,
      });
    }

    return categories;
  }

  // close connection
  Future<void> close() async {
    await conn?.close();
  }
}
