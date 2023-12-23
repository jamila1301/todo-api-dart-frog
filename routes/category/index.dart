import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:todo_api/data_sources/todo_data_source.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => _getCategories(context),
    HttpMethod.post => _createCategory(context),
    //  HttpMethod.put => _updateTodo(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

Future<Response> _getCategories(RequestContext context) async {
  final dataSource = context.read<TodoDataSource>();
  final categories = await dataSource.getCategories();

  return Response.json(body: categories);
}

Future<Response> _createCategory(RequestContext context) async {
  final dataSource = context.read<TodoDataSource>();
  final body = await context.request.json() as Map<String, dynamic>;
  final title = body['title'] as String?;

  if (title == null) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'name is required'},
    );
  }

  final result = await dataSource.addCategory(title);

  return Response.json(
    statusCode: HttpStatus.created,
    body: result,
  );
}
