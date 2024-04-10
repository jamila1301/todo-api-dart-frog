import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:todo_api/data_sources/todo_service.dart';
import 'package:todo_api/exceptions/empty_data_exception.dart';
import 'package:todo_api/models/success_result.dart';
import 'package:todo_api/models/todo.dart';
import 'package:todo_api/utils/response_ext.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  return switch (context.request.method) {
    HttpMethod.get => _getTodoDetails(context, id),
    HttpMethod.delete => _deleteTodo(context, id),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

Future<Response> _getTodoDetails(RequestContext context, String id) async {
  try {
    final todoService = context.read<TodoService>();
    final todo = await todoService.getTodoById(
      todoId: id,
    );

    return Response.json(
      body: SuccessResult<Todo>(
        statusCode: HttpStatus.ok,
        data: todo,
      ).toJson((todo) => todo.toJson()),
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

Future<Response> _deleteTodo(RequestContext context, String id) async {
  try {
    await context.read<TodoService>().deleteTodo(
          todoId: id,
        );

    return Response.json(body: null);
  } on EmptyDataException catch (e) {
    return ResponseHelper.prettyError(
      statusCode: HttpStatus.notFound,
      message: e.message,
    );
  } catch (e) {
    return ResponseHelper.prettyError(
      statusCode: HttpStatus.internalServerError,
      message: e.toString(),
    );
  }
}
