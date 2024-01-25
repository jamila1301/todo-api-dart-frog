import 'package:dart_frog/dart_frog.dart';
import 'package:todo_api/models/error_response.dart';

abstract class ResponseHelper {
  static Response prettyError({
    required int statusCode,
    required String message,
  }) {
    return Response.json(
      statusCode: statusCode,
      body: ErrorResponse(
        statusCode: statusCode,
        message: message,
      ),
    );
  }
}
