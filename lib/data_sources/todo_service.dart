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
        'SELECT * FROM todos WHERE category_id = $categoryId '
        'ORDER BY created_at DESC',
      );

      if (todosResult.isEmpty) {
        throw const EmptyDataException(
          'Todos for current category is empty!',
        );
      }

      final todoList = <Todo>[];

      for (var i = 0; i < todosResult.length; i++) {
        final todoRow = todosResult[i];

        todoList.add(
          Todo(
            id: todoRow[0]! as int,
            title: todoRow[1]! as String,
            description: todoRow[2] as String?,
            isCompleted: todoRow[4]! as bool,
            isImportant: todoRow[5]! as bool,
            createdAt: todoRow[6]! as DateTime,
            completedAt: todoRow[7] as DateTime?,
          ),
        );
      }

      return todoList;
    } catch (_) {
      rethrow;
    }
  }

  Future<Todo> getTodoById({
    required String todoId,
  }) async {
    try {
      final todoResult = await connector.connection!.execute(
        'SELECT * FROM todos WHERE id = $todoId',
      );

      if (todoResult.isEmpty) {
        throw const EmptyDataException(
          'Todo for current user is not found!',
        );
      }

      final todoRow = todoResult[0];

      return Todo(
        id: todoRow[0]! as int,
        title: todoRow[1]! as String,
        description: todoRow[2] as String?,
        isCompleted: todoRow[4]! as bool,
        isImportant: todoRow[5]! as bool,
        createdAt: todoRow[6]! as DateTime,
        completedAt: todoRow[7] as DateTime?,
      );
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

      final todoRow = todoResult.first;

      return Todo(
        id: todoRow[0]! as int,
        title: todoRow[1]! as String,
        description: todoRow[2] as String?,
        isCompleted: todoRow[4]! as bool,
        isImportant: todoRow[5]! as bool,
        createdAt: todoRow[6]! as DateTime,
        completedAt: todoRow[7] as DateTime?,
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

  Future<void> deleteTodo({
    required String todoId,
  }) async {
    try {
      final todoResult = await connector.connection!.execute(
        "SELECT * FROM todos WHERE id='$todoId'",
      );

      if (todoResult.isEmpty) {
        throw const EmptyDataException(
          'Todo with given id does not exist!',
        );
      }

      await connector.connection!.execute(
        'DELETE FROM todos WHERE id=$todoId',
      );
    } catch (_) {
      rethrow;
    }
  }

  Future<Todo> completeTodo(String id) async {
    try {
      await connector.connection!.execute(
        'UPDATE todos '
        'SET is_completed = true, completed_at=NOW() '
        'WHERE id = $id',
      );

      return getTodoById(todoId: id);
    } catch (_) {
      rethrow;
    }
  }

  Future<Todo> markAsImportant(String id) async {
    try {
      await connector.connection!.execute(
        'UPDATE todos '
        'SET is_important = true '
        'WHERE id = $id',
      );

      return getTodoById(todoId: id);
    } catch (_) {
      rethrow;
    }
  }
}
