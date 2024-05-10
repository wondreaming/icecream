import 'package:json_annotation/json_annotation.dart';
part 'response_destination_model.g.dart';

@JsonSerializable()
class ResponseDestination {
  final int status;
  final String message;
  final String? data;

  ResponseDestination({
    required this.status,
    required this.message,
    this.data,
  });

  factory ResponseDestination.fromJson(Map<String, dynamic> json) =>
      _$ResponseDestinationFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseDestinationToJson(this);
}
