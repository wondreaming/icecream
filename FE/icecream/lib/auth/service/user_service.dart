import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../com/const/dio_interceptor.dart';

class UserService {
  final Dio _dio = CustomDio().createDio();  // CustomDio 인스턴스를 사용하여 Dio 객체 생성

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

  // 토큰 저장
  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);
    await prefs.setString('refreshToken', refreshToken);
  }

  // 자녀 정보 저장
  Future<void> _saveChildData(List<dynamic> childrenData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String childrenJson = jsonEncode(childrenData);
    await prefs.setString('childrenData', childrenJson);
  }

  // 자녀 정보 불러오기
  Future<List<Map<String, dynamic>>> getChildData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? childrenJson = prefs.getString('childrenData');
    if (childrenJson != null) {
      List<dynamic> childrenList = jsonDecode(childrenJson);
      return childrenList.cast<Map<String, dynamic>>();
    }
    return [];
  }

  // 부모 회원가입
  Future<Response> registerUser(Map<String, dynamic> userData) async {
    try {
      final response = await _dio.post(
        '/users',
        data: userData,
        options: Options(headers: {'no-token': true}) // 토큰을 포함하지 않음
      );
      return response;
    } catch (e) {
      throw Exception('Failed to register user: $e');
    }
  }

  // 자녀 등록
  Future<Response> registerChild(Map<String, dynamic> userData) async {
    try {
      final response = await _dio.post(
        '/users/child',
        data: userData
      );
      return response;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  // 부모 로그인
  Future<void> loginUser(String loginId, String password, String fcmToken) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {
          'login_id': loginId,
          'password': password,
          'fcm_token': fcmToken,
        },
        options: Options(headers: {'no-token': true})  // 토큰을 포함하지 않음
      );
      if (response.statusCode == 200) {
        // 토큰 저장
        await _saveTokens(
          response.data['data']['access_token'],
          response.data['data']['refresh_token']
        );

        // 자녀의 전체 정보 저장
        if (response.data['data']['child'] != null && response.data['data']['child'].isNotEmpty) {
          await _saveChildData(response.data['data']['child']);
        }
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
        final response = await _dio.post(
          '/auth/device/login',
          data: {
            'device_id': deviceId,
            'refresh_token': refreshToken,
            'fcm_token': fcmToken,
          }
        );
        if (response.statusCode == 200) {
          // 토큰 저장
          await _saveTokens(
            response.data['data']['access_token'],
            response.data['data']['refresh_token']
          );
        } else {
          throw Exception('Failed to auto login');
        }
      } catch (e) {
        throw Exception('Login failed: $e');
      }
    }
  }


  // 로그인 ID 중복 확인
  Future<Map<String, dynamic>> checkLoginIdAvailability(String loginId) async {
    try {
      final response = await _dio.get(
        '/users/check',
        queryParameters: {'login_id': loginId},
        options: Options(headers: {'no-token': true})  // 토큰을 포함하지 않음
      );
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
