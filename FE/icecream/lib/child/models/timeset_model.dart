class TimesetModel {
  int? status;
  String? message;
  List<Data>? data;

  TimesetModel({this.status, this.message, this.data});

  TimesetModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? destinationId;
  String? name;
  String? icon;
  int? latitude;
  int? longitude;
  String? startTime;
  String? endTime;
  String? day;

  Data(
      {this.destinationId,
      this.name,
      this.icon,
      this.latitude,
      this.longitude,
      this.startTime,
      this.endTime,
      this.day});

  Data.fromJson(Map<String, dynamic> json) {
    destinationId = json['destination_id'];
    name = json['name'];
    icon = json['icon'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    day = json['day'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['destination_id'] = destinationId;
    data['name'] = name;
    data['icon'] = icon;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['day'] = day;
    return data;
  }
}
