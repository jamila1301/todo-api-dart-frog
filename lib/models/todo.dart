import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'todo.g.dart';

class TodoList {
  /// Contructor
  const TodoList();

  /// toJson of User model
  static List<dynamic> toJson(List<Todo> todoList) {
    final list = <Map<String, dynamic>>[];

    for (var i = 0; i < todoList.length; i++) {
      list.add(todoList[i].toJson());
    }

    return list;
  }
}

@JsonSerializable()
class Todo extends Equatable {
  /// Contructor
  const Todo({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.isImportant,
    required this.createdAt,
    this.description,
    this.completedAt,
  });

  /// fromJson of User
  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  /// id
  final int id;

  /// title
  final String title;

  /// description
  final String? description;

  /// completed status
  final bool isCompleted;

  /// importancy status
  final bool isImportant;

  /// created time
  final DateTime createdAt;

  /// updated time
  final DateTime? completedAt;

  /// toJson of User model
  Map<String, dynamic> toJson() => _$TodoToJson(this);

  @override
  List<Object?> get props => [id, title];
}
