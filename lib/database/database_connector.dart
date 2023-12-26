import 'package:postgres/postgres.dart';

/// Database Connector
class DatabaseConnector {
  /// Database connection instance
  Connection? connection;

  /// Initialize database connection
  Future<void> initialize() async {
    connection = await Connection.open(
      Endpoint(
        host: 'localhost',
        database: 'todo',
        username: 'thisisyusub',
        password: '123456',
      ),
      settings: const ConnectionSettings(
        sslMode: SslMode.disable,
      ),
    );
  }

  /// Close database connection
  Future<void> close() => connection!.close();
}
