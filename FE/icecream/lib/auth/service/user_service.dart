import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final Dio _dio = Dio();
  // fcm 토큰 가져오기
  Future<String> getFCMToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('fcmToken') ?? '';
  }

  // device ID 가져오기
  Future<String> getDeviceId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('deviceId') ?? '';
  }

  // 부모 회원가입
  Future<Response> registerUser(Map<String, dynamic> userData) async {
    try {
      final response = await _dio.post("http://k10e202.p.ssafy.io:8080/api/users",
          data: userData);
      return response;
    } catch (e) {
      throw Exception('Failed to register user: $e');
    }
  }

  // 자녀 등록
  Future<Response> registerChild({
    required String username,
    required String phoneNumber,
    required String deviceId,
    required String fcmToken,
  }) async {
    try {
      final response =
          await _dio.post("http://k10e202.p.ssafy.io:8080/api/users/child", data: {
        'username': username,
        'phone_number': phoneNumber,
        'device_id': deviceId,
        'fcm_token': fcmToken,
      });
      return response;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  // 부모 로그인
  Future<void> loginUser(
      String loginId, String password, String fcmToken) async {
    try {
      final response =
          await _dio.post("http://k10e202.p.ssafy.io:8080/api/auth/login", data: {
        'login_id': loginId,
        'password': password,
        'fcm_token': fcmToken,
      });
      if (response.statusCode == 200) {
        // 토큰 저장
        await _saveTokens(response.data['data']['access_token'],
            response.data['data']['refresh_token']);
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // 자동 로그인
  Future<void> autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString('device_id');
    String? refreshToken = prefs.getString('refresh_token');
    String? fcmToken = prefs.getString('fcm_token');

    if (deviceId != null && refreshToken != null && fcmToken != null) {
      try {
        final response = await _dio
            .post("http://k10e202.p.ssafy.io:8080/api/auth/device/login", data: {
          'device_id': deviceId,
          'refresh_token': refreshToken,
          'fcm_token': fcmToken,
        });
        if (response.statusCode == 200) {
          // 토큰 저장
          await _saveTokens(response.data['data']['access_token'],
              response.data['data']['refresh_token']);
        } else {
          throw Exception('Failed to auto login');
        }
      } catch (e) {
        throw Exception('Login failed: $e');
      }
    }
  }

  // 토큰 저장
  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);
    await prefs.setString('refreshToken', refreshToken);
  }

  // 로그인 ID 중복 확인
  Future<Map<String, dynamic>> checkLoginIdAvailability(String loginId) async {
    try {
      final response = await _dio.get(
          "http://k10e202.p.ssafy.io:8080/api/users/check",
          queryParameters: {'login_id': loginId});
      // status 코드에 따라 적절한 응답 처리
      return {
        'status': response.statusCode,
        'message': response.data['message'],
        'isAvailable': response.statusCode == 200
      };
    } catch (e) {
      return {'status': 500, 'message': '서버 에러가 발생했습니다.', 'isAvailable': false};
    }
  }
}
