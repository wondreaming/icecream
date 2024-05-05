import 'package:json_annotation/json_annotation.dart';
part 'delete_destination_model.g.dart';

@JsonSerializable()
class DeleteDestination {
  final int status;
  final String message;
  final String? data;

  DeleteDestination({
    required this.status,
    required this.message,
    this.data,
  });

  factory DeleteDestination.fromJson(Map<String, dynamic> json)
  => _$DeleteDestinationFromJson(json);

  Map<String, dynamic> toJson()
  => _$DeleteDestinationToJson(this);
}

