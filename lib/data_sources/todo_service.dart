import 'package:postgres/postgres.dart';
import 'package:todo_api/database/database_connector.dart';
import 'package:todo_api/exceptions/empty_data_exception.dart';
import 'package:todo_api/exceptions/unique_body_exception.dart';
import 'package:todo_api/models/todo.dart';
import 'package:todo_api/models/todo_request_model.dart';

class TodoService {
  TodoService(this.connector);

  final DatabaseConnector connector;

  Future<List<Todo>> getTodoListByCategoryId({required int categoryId}) async {
    try {
      final todosResult = await connector.connection!.execute(
        'SELECT * FROM todos WHERE category_id = $categoryId',
      );

      if (todosResult.isEmpty) {
        throw const EmptyDataException(
          'Todos for current category is empty!',
        );
      }

      final categories = <Todo>[];

      for (var i = 0; i < todosResult.length; i++) {
        final categoryRow = todosResult[i];

        categories.add(
          Todo(
            id: categoryRow[0]! as int,
            title: categoryRow[1]! as String,
            description: categoryRow[2] as String?,
            isCompleted: categoryRow[4]! as bool,
            isImportant: categoryRow[5]! as bool,
            createdAt: categoryRow[6]! as DateTime,
            completedAt: categoryRow[7] as DateTime?,
          ),
        );
      }

      return categories;
    } catch (_) {
      rethrow;
    }
  }

  Future<Todo> createTodo(TodoRequestModel model) async {
    try {
      await connector.connection!.execute(
        'INSERT INTO todos (title, description, category_id) '
        "VALUES('${model.title}', '${model.description}', ${model.categoryId})",
      );

      final todoResult = await connector.connection!.execute(
        'SELECT * FROM todos WHERE category_id = ${model.categoryId} '
        "AND title='${model.title}'",
      );

      final categoryRow = todoResult.first;

      return Todo(
        id: categoryRow[0]! as int,
        title: categoryRow[1]! as String,
        description: categoryRow[2] as String?,
        isCompleted: categoryRow[4]! as bool,
        isImportant: categoryRow[5]! as bool,
        createdAt: categoryRow[6]! as DateTime,
        completedAt: categoryRow[7] as DateTime?,
      );
    } on ServerException catch (e) {
      if (e.code != null && e.code == '23505') {
        throw UniqueBodyException(
          "Todo with '${model.title}' for this category is already exist!",
        );
      }

      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
