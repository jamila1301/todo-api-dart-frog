import 'package:dart_frog/dart_frog.dart';
import 'package:todo_api/data_sources/category_service.dart';
import 'package:todo_api/database/database_connector.dart';

Handler middleware(Handler handler) {
  return handler.use(
    provider<CategoryService>(
      (context) => CategoryService(context.read<DatabaseConnector>()),
    ),
  );
}
