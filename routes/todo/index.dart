import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => _getTodos(context),
    HttpMethod.post => _createTodo(context),
    HttpMethod.put => _updateTodo(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

Future<Response> _updateTodo(RequestContext context) async {
  try {
    final body = await context.request.json() as Map<String, dynamic>;
    final id = body['id'] as int?;
    final title = body['title'] as String?;

    if (id == null || title == null) {
      return Response(statusCode: HttpStatus.badRequest);
    }

    final index = cachedTodos.indexWhere((todo) => todo.id == id);
    final updatedTodo = cachedTodos[index].copyWith(title: title);
    cachedTodos[index] = updatedTodo;

    return Response.json(body: updatedTodo.toJson());
  } catch (e) {
    return Response(
      statusCode: HttpStatus.internalServerError,
      body: e.toString(),
    );
  }
}

Future<Response> _createTodo(RequestContext context) async {
  try {
    final body = await context.request.json() as Map<String, dynamic>;
    final title = body['title'] as String?;

    if (title == null) {
      return Response(statusCode: HttpStatus.badRequest);
    }

    final todo = Todo(
      id: cachedTodos.length + 1,
      title: title,
    );

    cachedTodos.add(todo);

    return Response.json(body: todo.toJson());
  } catch (e) {
    return Response(
      statusCode: HttpStatus.internalServerError,
      body: e.toString(),
    );
  }
}

Future<Response> _getTodos(RequestContext context) async {
  final queries = context.request.uri.queryParameters;
  final query = queries['query'];

  final todos = <Todo>[];

  if (query == null) {
    todos.addAll(cachedTodos);
  } else {
    final queriedTodos = cachedTodos.where(
      (todo) => todo.title.contains(query),
    );

    todos.addAll(queriedTodos);
  }

  final body = <Map<String, dynamic>>[];

  for (final todo in todos) {
    body.add(todo.toJson());
  }

  return Response.json(body: body);
}

final cachedTodos = [
  Todo(
    id: 1,
    title: 'Learn Dart',
  ),
  Todo(
    id: 2,
    title: 'Learn Flutter',
  ),
  Todo(
    id: 3,
    title: 'Learn Dart Frog',
  ),
];

class Todo {
  Todo({
    required this.id,
    required this.title,
  });

  int id;
  String title;

  /// implement to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }

  Todo copyWith({
    String? title,
  }) {
    return Todo(
      id: id,
      title: title ?? this.title,
    );
  }

  @override
  String toString() {
    return 'Todo{id: $id, title: $title}';
  }
}
