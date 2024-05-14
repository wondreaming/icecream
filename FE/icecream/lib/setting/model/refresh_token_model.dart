import 'package:json_annotation/json_annotation.dart';
part 'refresh_token_model.g.dart';

@JsonSerializable()
class RefreashTokenModel {
  final String refreashToken;
  RefreashTokenModel(
      {
        required this.refreashToken
      });

  factory RefreashTokenModel.fromJson(Map<String, dynamic> json) =>
      _$RefreashTokenModelFromJson(json);

  Map<String, dynamic> toJson() => _$RefreashTokenModelToJson(this);
}
