import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:icecream/noti/models/notification_model.dart';

class NotificationService {
  final Dio _dio = Dio();
  final String _baseUrl = "http://k10e202.p.ssafy.io:8080";

  Future<NotificationModel> fetchNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      throw Exception("Access token not found.");
    }

    try {
      final response = await _dio.get(
        '$_baseUrl/api/notification', // 유저 ID는 3으로 임시 설정
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
        }),
      );
      return NotificationModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load notifications: $e');
    }
  }
}
