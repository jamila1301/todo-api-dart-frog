import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:todo_api/data_sources/todo_service.dart';
import 'package:todo_api/exceptions/empty_data_exception.dart';
import 'package:todo_api/exceptions/unique_body_exception.dart';
import 'package:todo_api/models/success_result.dart';
import 'package:todo_api/models/todo.dart';
import 'package:todo_api/models/todo_request_model.dart';
import 'package:todo_api/utils/response_ext.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => _getTodos(context),
    HttpMethod.post => _createTodo(context),
    //  HttpMethod.put => _updateTodo(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

// Future<Response> _updateTodo(RequestContext context) async {
//   try {
//     final body = await context.request.json() as Map<String, dynamic>;
//     final id = body['id'] as int?;
//     final title = body['title'] as String?;

//     if (id == null || title == null) {
//       return Response(statusCode: HttpStatus.badRequest);
//     }

//     final index = cachedTodos.indexWhere((todo) => todo.id == id);
//     final updatedTodo = cachedTodos[index].copyWith(title: title);
//     cachedTodos[index] = updatedTodo;

//     return Response.json(body: updatedTodo.toJson());
//   } catch (e) {
//     return Response(
//       statusCode: HttpStatus.internalServerError,
//       body: e.toString(),
//     );
//   }
// }

Future<Response> _createTodo(RequestContext context) async {
  try {
    final body = await context.request.json() as Map<String, dynamic>;
    final requestModel = TodoRequestModel.fromJson(body);

    final todo = await context.read<TodoService>().createTodo(
          requestModel,
        );

    return Response.json(
      body: SuccessResult<Todo>(
        statusCode: HttpStatus.ok,
        data: todo,
      ).toJson((todo) => todo.toJson()),
    );
  } on UniqueBodyException catch (e) {
    return ResponseHelper.prettyError(
      statusCode: HttpStatus.badRequest,
      message: e.message,
    );
  } catch (e) {
    return ResponseHelper.prettyError(
      statusCode: HttpStatus.internalServerError,
      message: e.toString(),
    );
  }
}

Future<Response> _getTodos(RequestContext context) async {
  try {
    final todoService = context.read<TodoService>();
    final queryParams = context.request.uri.queryParameters;
    final categoryId = queryParams['category_id'];

    if (categoryId == null) {
      return ResponseHelper.prettyError(
        statusCode: HttpStatus.badRequest,
        message: 'category_id as query params required!',
      );
    }

    final todos = await todoService.getTodoListByCategoryId(
      categoryId: int.parse(categoryId),
    );

    return Response.json(
      body: SuccessResult<List<Todo>>(
        statusCode: HttpStatus.ok,
        data: todos,
      ).toJson(TodoList.toJson),
    );
  } on EmptyDataException catch (e) {
    return ResponseHelper.prettyError(
      statusCode: HttpStatus.notFound,
      message: e.message,
    );
  } catch (e) {
    return ResponseHelper.prettyError(
      statusCode: HttpStatus.badRequest,
      message: e.toString(),
    );
  }
}
