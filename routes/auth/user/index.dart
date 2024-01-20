import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:todo_api/data_sources/authentication_service.dart';
import 'package:todo_api/models/user.dart';

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

    return Response.json(body: user);
  } catch (e) {
    return Response(
      statusCode: HttpStatus.internalServerError,
      body: e.toString(),
    );
  }
}
