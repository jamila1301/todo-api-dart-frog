// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodoRequestModel _$TodoRequestModelFromJson(Map<String, dynamic> json) =>
    TodoRequestModel(
      title: json['title'] as String,
      categoryId: json['category_id'] as int,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$TodoRequestModelToJson(TodoRequestModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'category_id': instance.categoryId,
    };
