import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:todo_api/data_sources/authentication_service.dart';
import 'package:todo_api/exceptions/incorrect_credentials_exception.dart';
import 'package:todo_api/exceptions/user_does_not_exist_exception.dart';
import 'package:todo_api/models/success_result.dart';
import 'package:todo_api/utils/response_ext.dart';

Future<Response> onRequest(RequestContext context) {
  return switch (context.request.method) {
    HttpMethod.post => _login(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

/*
{
  "username": "sdvsdvsd",
  "password": "ascsac",
}
*/

Future<Response> _login(RequestContext context) async {
  try {
    final body = await context.request.json() as Map<String, dynamic>;
    final username = body['username'] as String?;
    final password = body['password'] as String?;

    if (username == null || password == null) {
      return ResponseHelper.prettyError(
        statusCode: HttpStatus.badRequest,
        message: 'username and password required!',
      );
    }

    final authService = context.read<AuthenticationService>();

    final user = await authService.login(
      username: username,
      password: password,
    );

    return Response.json(
      body: SuccessResult(
        statusCode: HttpStatus.ok,
        data: user,
      ).toJson((value) => user.toJson()),
    );
  } on UserDoesNotExistException catch (e) {
    return ResponseHelper.prettyError(
      statusCode: HttpStatus.badRequest,
      message: e.message,
    );
  } on IncorrectCredentialsException catch (e) {
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
