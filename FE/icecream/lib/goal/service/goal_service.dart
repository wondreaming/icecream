import 'package:dio/dio.dart';
import 'package:icecream/com/const/dio_interceptor.dart';

class GoalService {
  final Dio _dio = CustomDio().createDio();

  // 자녀 ID를 사용하여 목표 데이터 가져오기
  Future<Map<String, dynamic>> fetchGoals(String userId) async {
    try {
      final response =
          await _dio.get('/goal', queryParameters: {'user_id': userId});
      if (response.statusCode == 200) {
        return {
          'status': response.statusCode,
          'message': '목표를 불러왔습니다.',
          'data': response.data['data']
        };
      } else {
        return {
          'status': response.statusCode,
          'message': response.data['message'] ?? '데이터 로드 실패',
          'data': []
        };
      }
    } catch (e) {
      print('Failed to fetch goals: $e');
      return {'status': 500, 'message': '서버 오류가 발생했습니다.', 'data': []};
    }
  }

  Future<Response> addGoal(Map<String, dynamic> goalData) async {
    try {
      Response response = await _dio.post('/goal', data: goalData);
      return response;
    } catch (e) {
      print('Failed to add goal: $e');
      throw Exception('Failed to add goal');
    }
  }
}