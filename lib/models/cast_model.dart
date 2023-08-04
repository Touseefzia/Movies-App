import 'package:json_annotation/json_annotation.dart';
part 'cast_model.g.dart';

@JsonSerializable()
class CastModel {
  @JsonKey(name: 'adult')
  bool? adult;
  @JsonKey(name: 'gender')
  int? gender;
  @JsonKey(name: 'id')
  int? id;
  @JsonKey(name: 'known_for_department')
  String? knownForDepartment;
  @JsonKey(name: 'original_name')
  String? originalName;
  @JsonKey(name: 'profile_path')
  String? profilePath;
  @JsonKey(name: 'character')
  String? character;

  CastModel({
    this.adult,
    this.gender,
    this.id,
    this.knownForDepartment,
    this.originalName,
    this.profilePath,
    this.character
  });



  factory CastModel.fromJson(Map<String, dynamic> json) => _$CastModelFromJson(json);

  Map<String, dynamic> toJson() => _$CastModelToJson(this);
}