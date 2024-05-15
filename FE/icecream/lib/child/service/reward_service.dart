import 'package:dio/dio.dart';

class RewardService {
  final Dio _dio;

  RewardService(this._dio);

  Future<Map<String, dynamic>> fetchGoal(String userId) async {
    try {
      final response = await _dio.get('/goal?user_id=$userId');
      if (response.statusCode == 200) {
        return response.data['data'][0];
      } else {
        throw Exception('Failed to load goal');
      }
    } catch (e) {
      print('Error fetching goal: $e');
      rethrow;
    }
  }
}
