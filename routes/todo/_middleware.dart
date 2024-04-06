import 'package:dart_frog/dart_frog.dart';
import 'package:todo_api/data_sources/todo_service.dart';
import 'package:todo_api/database/database_connector.dart';

Handler middleware(Handler handler) {
  return handler.use(
    provider<TodoService>(
      (context) => TodoService(context.read<DatabaseConnector>()),
    ),
  );
}
