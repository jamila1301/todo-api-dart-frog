import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'todo_request_model.g.dart';

@JsonSerializable()
class TodoRequestModel extends Equatable {
  /// Contructor
  const TodoRequestModel({
    required this.title,
    required this.categoryId,
    this.description,
  });

  /// fromJson of User
  factory TodoRequestModel.fromJson(Map<String, dynamic> json) =>
      _$TodoRequestModelFromJson(json);

  /// title
  final String title;

  /// description
  final String? description;

  final int categoryId;

  @override
  List<Object?> get props => [title, description, categoryId];
}
