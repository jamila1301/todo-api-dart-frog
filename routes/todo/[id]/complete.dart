import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:todo_api/data_sources/todo_service.dart';
import 'package:todo_api/models/success_result.dart';
import 'package:todo_api/models/todo.dart';
import 'package:todo_api/utils/response_ext.dart';

Future<Response> onRequest(
  RequestContext context,
  String id,
) {
  return switch (context.request.method) {
    HttpMethod.patch => _markAsCompleted(context, id),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

Future<Response> _markAsCompleted(RequestContext context, String id) async {
  try {
    final completedTodo = await context.read<TodoService>().completeTodo(id);

    return Response.json(
      body: SuccessResult<Todo>(
        statusCode: HttpStatus.ok,
        data: completedTodo,
      ).toJson((todo) => todo.toJson()),
    );
  } catch (e) {
    return ResponseHelper.prettyError(
      statusCode: HttpStatus.badRequest,
      message: e.toString(),
    );
  }
}
