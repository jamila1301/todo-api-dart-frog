import 'package:postgres/postgres.dart';
import 'package:todo_api/database/database_connector.dart';
import 'package:todo_api/exceptions/empty_data_exception.dart';
import 'package:todo_api/exceptions/same_title_exception.dart';
import 'package:todo_api/exceptions/unique_body_exception.dart';
import 'package:todo_api/models/category.dart';

class CategoryService {
  CategoryService(this.connector);

  final DatabaseConnector connector;

  Future<List<Category>> getCategoriesOfUser({required int userId}) async {
    try {
      final categoriesResult = await connector.connection!.execute(
        'SELECT * FROM categories WHERE user_id = $userId',
      );

      if (categoriesResult.isEmpty) {
        throw const EmptyDataException(
          'Categories for current user is empty!',
        );
      }

      final categories = <Category>[];

      for (var i = 0; i < categoriesResult.length; i++) {
        final categoryRow = categoriesResult[i];

        categories.add(
          Category(
            id: categoryRow[0]! as int,
            title: categoryRow[1]! as String,
          ),
        );
      }

      return categories;
    } catch (_) {
      rethrow;
    }
  }

  Future<Category> getCategoryById({
    required int userId,
    required String categoryId,
  }) async {
    try {
      final categoriesResult = await connector.connection!.execute(
        'SELECT * FROM categories WHERE user_id = $userId AND id = $categoryId',
      );

      if (categoriesResult.isEmpty) {
        throw const EmptyDataException(
          'Category for current user is not found!',
        );
      }

      final categoryRow = categoriesResult[0];

      return Category(
        id: categoryRow[0]! as int,
        title: categoryRow[1]! as String,
      );
    } catch (_) {
      rethrow;
    }
  }

  Future<Category> createCategory({
    required int userId,
    required String title,
  }) async {
    try {
      await connector.connection!.execute(
        'INSERT INTO categories (user_id, title) '
        "VALUES($userId, '$title')",
      );

      final categoryResult = await connector.connection!.execute(
        "SELECT * FROM categories WHERE user_id = $userId AND title='$title'",
      );

      final categoryRow = categoryResult.first;

      return Category(
        id: categoryRow[0]! as int,
        title: categoryRow[1]! as String,
      );
    } on ServerException catch (e) {
      if (e.code != null && e.code == '23505') {
        throw UniqueBodyException(
          "Category with '$title' for this user is already exist!",
        );
      }

      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCategory({
    required int userId,
    required String categoryId,
  }) async {
    try {
      final categoryResult = await connector.connection!.execute(
        "SELECT * FROM categories WHERE user_id = $userId AND id='$categoryId'",
      );

      if (categoryResult.isEmpty) {
        throw const EmptyDataException(
          'Category with given id does not exist!',
        );
      }

      await connector.connection!.execute(
        'DELETE FROM categories WHERE user_id = $userId AND id=$categoryId',
      );
    } catch (_) {
      rethrow;
    }
  }

  Future<Category> updateCategory({
    required int userId,
    required String categoryId,
    required String newTitle,
  }) async {
    try {
      final currentCategory = await getCategoryById(
        userId: userId,
        categoryId: categoryId,
      );

      if (currentCategory.title == newTitle) {
        throw const SameTitleException(
          "you can't give the same title for category",
        );
      }

      await connector.connection!.execute(
        'UPDATE categories '
        "SET title = '$newTitle' "
        'WHERE user_id = $userId AND id = $categoryId',
      );

      return Category(
        id: currentCategory.id,
        title: newTitle,
      );
    } catch (_) {
      rethrow;
    }
  }
}
