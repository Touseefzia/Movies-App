import 'package:json_annotation/json_annotation.dart';
part 'api_response_model.g.dart';

@JsonSerializable()
class ApiResponseModel {
  @JsonKey(name: 'success')
  bool? success;
  @JsonKey(name: 'data')
  dynamic data;
  @JsonKey(name: 'message')
  String? message;

  ApiResponseModel({
    this.success,
    this.data,
    this.message,
  });



  factory ApiResponseModel.fromJson(Map<String, dynamic> json) => _$ApiResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApiResponseModelToJson(this);
}