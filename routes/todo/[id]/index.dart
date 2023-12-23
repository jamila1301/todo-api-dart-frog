import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../index.dart';

Future<Response> onRequest(
  RequestContext context,
  String id,
) {
  return switch (context.request.method) {
    HttpMethod.get => _getTodoById(context, id),
    HttpMethod.delete => _deleteTodoById(context, id),
    HttpMethod.patch => _updateTodoById(context, id),
    _ => Future.value(
        Response(statusCode: HttpStatus.methodNotAllowed),
      ),
  };
}

Future<Response> _updateTodoById(
  RequestContext context,
  String id,
) async {
  try {
    final body = await context.request.json() as Map<String, dynamic>;
    final title = body['title'] as String?;

    final todo = cachedTodos.firstWhere(
      (todo) => todo.id == int.parse(id),
    );

    if (title == null) {
      return Response.json(body: todo.toJson());
    }

    todo.title = title;

    return Response.json(body: todo.toJson());
  } catch (e) {
    return Response(
      statusCode: HttpStatus.internalServerError,
      body: e.toString(),
    );
  }
}

Future<Response> _deleteTodoById(
  RequestContext context,
  String id,
) async {
  try {
    final todo = cachedTodos.where(
      (todo) => todo.id == int.parse(id),
    );

    if (todo.isEmpty) {
      return Response(
        statusCode: HttpStatus.notFound,
        body: 'Todo not found',
      );
    }

    cachedTodos.remove(todo.first);

    return Response(statusCode: HttpStatus.noContent);
  } catch (e) {
    return Response(
      statusCode: HttpStatus.internalServerError,
      body: e.toString(),
    );
  }
}

Future<Response> _getTodoById(
  RequestContext context,
  String id,
) async {
  try {
    final todo = cachedTodos.where(
      (todo) => todo.id == int.parse(id),
    );

    if (todo.isEmpty) {
      return Response(
        statusCode: HttpStatus.notFound,
        body: 'Todo not found',
      );
    }

    return Response.json(body: todo.first);
  } catch (e) {
    return Response(
      statusCode: HttpStatus.internalServerError,
      body: e.toString(),
    );
  }
}
