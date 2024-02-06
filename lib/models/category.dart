import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

class CategoryList {
  /// Contructor
  const CategoryList();

  /// toJson of User model
  static List<dynamic> toJson(List<Category> categories) {
    final list = <Map<String, dynamic>>[];

    for (var i = 0; i < categories.length; i++) {
      list.add(categories[i].toJson());
    }

    return list;
  }
}

/// User Model
@JsonSerializable()
class Category extends Equatable {
  /// Contructor
  const Category({
    required this.id,
    required this.title,
  });

  /// fromJson of User
  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  /// id
  final int id;

  /// title
  final String title;

  /// toJson of User model
  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  @override
  List<Object?> get props => [id, title];
}
