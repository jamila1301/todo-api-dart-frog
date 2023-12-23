import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:todo_api/data_sources/authentication_service.dart';
import 'package:todo_api/exceptions/user_already_registered_exception.dart';

Future<Response> onRequest(RequestContext context) {
  return switch (context.request.method) {
    HttpMethod.post => _register(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

/*
{
  "username": "sdvsdvsd",
  "password": "ascsac",
  "fullName": "sdavds",
}
*/

Future<Response> _register(RequestContext context) async {
  try {
    final body = await context.request.json() as Map<String, dynamic>;

    final username = body['userName'] as String?;
    final password = body['password'] as String?;
    final fullName = body['fullName'] as String?;

    if (username == null || password == null || fullName == null) {
      return Response(
        statusCode: HttpStatus.badRequest,
        body: 'username, password and fullname required!',
      );
    }

    await context.read<AuthenticationService>().register(
          fullName: fullName,
          username: username,
          password: password,
        );

    return Response(statusCode: HttpStatus.created);
  } on UserAlreadyRegisteredException catch (e) {
    return Response(
      statusCode: HttpStatus.conflict,
      body: e.message,
    );
  } catch (e, s) {
    return Response(
      statusCode: HttpStatus.internalServerError,
      body: '$e => $s',
    );
  }
}
