import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:todo_api/data_sources/authentication_service.dart';
import 'package:todo_api/exceptions/user_does_not_exist_exception.dart';
import 'package:todo_api/models/success_result.dart';
import 'package:todo_api/models/user.dart';
import 'package:todo_api/utils/response_ext.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => _getUser(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

Future<Response> _getUser(RequestContext context) async {
  try {
    final user = await context.read<AuthenticationService>().getUser(
          context.read<User>().id,
        );

    return Response.json(
      body: SuccessResult<User>(
        statusCode: HttpStatus.ok,
        data: user,
      ).toJson((user) => user.toJson()),
    );
  } on UserDoesNotExistException catch (e) {
    return ResponseHelper.prettyError(
      statusCode: HttpStatus.notFound,
      message: e.message,
    );
  } on Object catch (e) {
    return ResponseHelper.prettyError(
      statusCode: HttpStatus.internalServerError,
      message: e.toString(),
    );
  }
}
