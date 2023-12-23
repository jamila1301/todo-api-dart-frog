import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_auth/dart_frog_auth.dart';
import 'package:todo_api/data_sources/authentication_service.dart';
import 'package:todo_api/models/user.dart';

AuthenticationService? _authenticationService;

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(
        basicAuthentication<User>(
          authenticator: (context, username, password) {
            final authService = context.read<AuthenticationService>();

            final user = authService.login(
              username: username,
              password: password,
            );

            return user;
          },
          applies: (RequestContext context) async {
            return context.request.uri !=
                    Uri.parse('http://localhost:8080/auth/login') &&
                context.request.uri !=
                    Uri.parse('http://localhost:8080/auth/register');
          },
        ),
      )
      .use(
        provider<AuthenticationService>(
          (context) => _authenticationService ??= AuthenticationService(),
        ),
      );
}

// Handler todoDataSource(Handler handler) {
//   return (context) async {
//     _dataSource ??= TodoDataSource();
//     await _dataSource!.initialize();

//     final response = await handler
//         .use(provider<TodoDataSource>((_) => _dataSource!))
//         .call(context);

//     await _dataSource!.close();

//     return response;
//   };
// }
