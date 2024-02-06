import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:todo_api/data_sources/category_service.dart';
import 'package:todo_api/exceptions/empty_data_exception.dart';
import 'package:todo_api/exceptions/invalid_body_exception.dart';
import 'package:todo_api/exceptions/unique_body_exception.dart';
import 'package:todo_api/models/category.dart';
import 'package:todo_api/models/success_result.dart';
import 'package:todo_api/models/user.dart';
import 'package:todo_api/utils/response_ext.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => _getCategories(context),
    HttpMethod.post => _createCategory(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

Future<Response> _createCategory(RequestContext context) async {
  try {
    final body = await context.request.json();

    final isMap = body! is Map<String, dynamic>;
    final title = (body as Map<String, dynamic>)['title'] as String?;

    if (!isMap || title == null) {
      throw const InvalidBodyException('title is required in body');
    }

    final category = await context.read<CategoryService>().createCategory(
          userId: context.read<User>().id,
          title: title,
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
  } on InvalidBodyException catch (e) {
    return ResponseHelper.prettyError(
      statusCode: HttpStatus.badRequest,
      message: e.message,
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

Future<Response> _getCategories(RequestContext context) async {
  try {
    final categoryService = context.read<CategoryService>();
    final categories = await categoryService.getCategoriesOfUser(
      userId: context.read<User>().id,
    );

    return Response.json(
      body: SuccessResult<List<Category>>(
        statusCode: HttpStatus.ok,
        data: categories,
      ).toJson(CategoryList.toJson),
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
