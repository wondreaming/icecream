import 'package:dio/dio.dart';
import 'package:icecream/com/const/dio_interceptor.dart';

class GoalService {
  final Dio _dio;

  GoalService() : _dio = CustomDio().createDio(); // CustomDio 인스턴스를 사용하여 Dio 생성

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
