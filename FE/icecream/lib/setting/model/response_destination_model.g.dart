// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_destination_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseDestination _$ResponseDestinationFromJson(Map<String, dynamic> json) =>
    ResponseDestination(
      status: (json['status'] as num).toInt(),
      message: json['message'] as String,
      data: json['data'] as String?,
    );

Map<String, dynamic> _$ResponseDestinationToJson(
        ResponseDestination instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };
