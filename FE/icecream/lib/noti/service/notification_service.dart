import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:icecream/noti/models/notification_model.dart';

class NotificationService {
  final Dio _dio = Dio();
  final String _baseUrl = "http://k10e202.p.ssafy.io:8080";
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<String> _getAccessToken() async {
    return await _secureStorage.read(key: 'accessToken') ?? '';
  }

  Future<NotificationModel> fetchNotifications() async {
    String accessToken = await _getAccessToken();

    if (accessToken.isEmpty) {
      throw Exception("Access token not found.");
    }

    try {
      final response = await _dio.get(
        '$_baseUrl/api/notification',
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
