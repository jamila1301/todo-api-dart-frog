import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:todo_api/data_sources/category_service.dart';
import 'package:todo_api/exceptions/empty_data_exception.dart';
import 'package:todo_api/models/user.dart';
import 'package:todo_api/utils/response_ext.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  return switch (context.request.method) {
    HttpMethod.delete => _deleteCategory(context, id),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

Future<Response> _deleteCategory(RequestContext context, String id) async {
  try {
    await context.read<CategoryService>().deleteCategory(
          userId: context.read<User>().id,
          categoryId: id,
        );

    return Response.json();
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
