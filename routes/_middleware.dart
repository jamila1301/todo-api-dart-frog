import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_auth/dart_frog_auth.dart';
import 'package:todo_api/data_sources/authentication_service.dart';
import 'package:todo_api/database/database_connector.dart';
import 'package:todo_api/models/user.dart';

AuthenticationService? _authenticationService;
DatabaseConnector? _databaseConnector;

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(
        basicAuthentication<User>(
          authenticator: (context, username, password) async {
            final authService = context.read<AuthenticationService>();

            final user = await authService.login(
              username: username,
              password: password,
            );

            return user;
          },
          applies: (RequestContext context) async {
            return context.request.uri !=
                    Uri.parse('http://localhost:8080/auth/login') &&
                context.request.uri !=
                    Uri.parse('http://localhost:8080/auth/register') &&
                context.request.uri !=
                    Uri.parse('http://localhost:8080/auth/user');
          },
        ),
      )
      .use(
        provider<AuthenticationService>(
          (_) => _authenticationService ??= AuthenticationService(
            connector: _databaseConnector!,
          ),
        ),
      )
      .use(databaseConnectorProvider);
}

Handler databaseConnectorProvider(Handler handler) {
  return (context) async {
    _databaseConnector ??= DatabaseConnector();
    await _databaseConnector!.initialize();

    final response = await handler
        .use(
          provider<DatabaseConnector>(
            (_) => _databaseConnector!,
          ),
        )
        .call(context);

    await _databaseConnector!.close();

    return response;
  };
}
