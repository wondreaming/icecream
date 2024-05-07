// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_destination_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteDestination _$DeleteDestinationFromJson(Map<String, dynamic> json) =>
    DeleteDestination(
      status: (json['status'] as num).toInt(),
      message: json['message'] as String,
      data: json['data'] as String?,
    );

Map<String, dynamic> _$DeleteDestinationToJson(DeleteDestination instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };
