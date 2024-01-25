import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'success_result.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class SuccessResult<T> extends Equatable {
  const SuccessResult({
    required this.statusCode,
    required this.data,
  });

  factory SuccessResult.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$SuccessResultFromJson(json, fromJsonT);

  final int statusCode;
  final T data;

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$SuccessResultToJson(this, toJsonT);

  @override
  List<Object?> get props => [statusCode, data];
}
