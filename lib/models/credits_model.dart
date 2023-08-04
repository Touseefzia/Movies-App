import 'package:json_annotation/json_annotation.dart';

import 'cast_model.dart';
part 'credits_model.g.dart';

@JsonSerializable()
class CreditsModel {
  @JsonKey(name: 'id')
  int? id;
  @JsonKey(name: 'cast')
  List<CastModel>? cast;

  CreditsModel({
    this.id,
    this.cast
  });



  factory CreditsModel.fromJson(Map<String, dynamic> json) => _$CreditsModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreditsModelToJson(this);
}