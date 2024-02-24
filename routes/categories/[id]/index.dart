import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:todo_api/data_sources/category_service.dart';
import 'package:todo_api/exceptions/empty_data_exception.dart';
import 'package:todo_api/models/category.dart';
import 'package:todo_api/models/success_result.dart';
import 'package:todo_api/models/user.dart';
import 'package:todo_api/utils/response_ext.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  return switch (context.request.method) {
    HttpMethod.get => _getCategory(context, id),
    HttpMethod.delete => _deleteCategory(context, id),
    HttpMethod.patch => _updateCategory(context, id),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

Future<Response> _getCategory(RequestContext context, String id) async {
  try {
    final categoryService = context.read<CategoryService>();
    final category = await categoryService.getCategoryById(
      userId: context.read<User>().id,
      categoryId: id,
    );

    return Response.json(
      body: SuccessResult<Category>(
        statusCode: HttpStatus.ok,
        data: category,
      ).toJson((category) => category.toJson()),
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

Future<Response> _deleteCategory(RequestContext context, String id) async {
  try {
    await context.read<CategoryService>().deleteCategory(
          userId: context.read<User>().id,
          categoryId: id,
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

Future<Response> _updateCategory(RequestContext context, String id) async {
  try {
    final body = await context.request.json();
    final title = (body as Map<String, dynamic>)['title'] as String?;

    if (title == null) {
      return ResponseHelper.prettyError(
        statusCode: HttpStatus.badRequest,
        message: 'title is required in body',
      );
    }

    final categoryService = context.read<CategoryService>();

    final category = await categoryService.updateCategory(
      userId: context.read<User>().id,
      categoryId: id,
      newTitle: title,
    );

    return Response.json(
      body: SuccessResult<Category>(
        statusCode: HttpStatus.ok,
        data: category,
      ).toJson((category) => category.toJson()),
    );
  } on EmptyDataException catch (e) {
    return ResponseHelper.prettyError(
      statusCode: HttpStatus.notFound,
      message: e.message,
    );
  } on FormatException catch (_) {
    return ResponseHelper.prettyError(
      statusCode: HttpStatus.badRequest,
      message: 'title is required in body',
    );
  } catch (e) {
    return ResponseHelper.prettyError(
      statusCode: HttpStatus.badRequest,
      message: e.toString(),
    );
  }
}
