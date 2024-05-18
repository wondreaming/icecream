import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DailyGoalService {
  final Dio dio;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  DailyGoalService(this.dio);

  Future<Map<DateTime, int>> fetchGoalStatus(int userId) async {
    try {
      String token = await _secureStorage.read(key: 'accessToken') ?? '';
      final response = await dio.get(
        'https://k10e202.p.ssafy.io/api/goal/status?user_id=$userId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        Map<DateTime, int> goalStatus = {};
        response.data['data'].forEach((key, value) {
          goalStatus[DateTime.parse(key)] = value as int;
        });
        return goalStatus;
      } else {
        throw Exception('데일리골서비스 실패');
      }
    } catch (e) {
      throw Exception('dailygoal실패: $e');
    }
  }
}
