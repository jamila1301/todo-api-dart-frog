// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'success_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SuccessResult<T> _$SuccessResultFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    SuccessResult<T>(
      statusCode: json['status_code'] as int,
      data: fromJsonT(json['data']),
    );

Map<String, dynamic> _$SuccessResultToJson<T>(
  SuccessResult<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'status_code': instance.statusCode,
      'data': toJsonT(instance.data),
    };
