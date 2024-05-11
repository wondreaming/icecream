import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:icecream/provider/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../com/const/dio_interceptor.dart';

class UserService {
  final Dio _dio = CustomDio().createDio(); // CustomDio 인스턴스를 사용하여 Dio 객체 생성
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // secure storage 값 읽기
  Future<String> _readFromSecureStorage(String key) async {
    return await _secureStorage.read(key: key) ?? '';
  }

  // secure storage 값 저장
  Future<void> _writeToSecureStorage(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  // 기기 식별자 가져오기
  Future<String> getDeviceId() async {
    return await _readFromSecureStorage('deviceId');
  }

  // FCM 토큰 가져오기
  Future<String> getFCMToken() async {
    return await _readFromSecureStorage('fcmToken');
  }

  // 토큰 저장
  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    await _writeToSecureStorage('accessToken', accessToken);
    await _writeToSecureStorage('refreshToken', refreshToken);
  }

  // 부모 회원가입
  Future<Response> registerUser(Map<String, dynamic> userData) async {
    try {
      final response = await _dio.post('/users',
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
      final response = await _dio.post('/users/child', data: userData);
      return response;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  // 부모 로그인
  Future<void> loginUser(String loginId, String password, String fcmToken,
      UserProvider userProvider) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {
          'login_id': loginId,
          'password': password,
          'fcm_token': fcmToken,
        },
        options: Options(headers: {'no-token': true}),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        // 토큰 저장
        await _saveTokens(
          response.data['data']['access_token'],
          response.data['data']['refresh_token'],
        );

        // 사용자 및 자녀 정보 Provider에 저장
        userProvider.setUserData(response.data['data']);
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // 자동 로그인
  Future<void> autoLogin(UserProvider userProvider) async {
    String deviceId = await getDeviceId();
    String refreshToken = await _readFromSecureStorage('refreshToken');
    String fcmToken = await _readFromSecureStorage('fcmToken');

    if (deviceId.isNotEmpty && refreshToken.isNotEmpty && fcmToken.isNotEmpty) {
      try {
        final response = await _dio.post(
          '/auth/device/login',
          data: {
            'device_id': deviceId,
            'refresh_token': refreshToken,
            'fcm_token': fcmToken,
          },
        );
        if (response.statusCode == 200) {
          // 토큰 저장
          await _saveTokens(
            response.data['data']['access_token'],
            response.data['data']['refresh_token'],
          );

          // 사용자 및 자녀 정보 Provider에 저장
          userProvider.setUserData(response.data['data']);
        } else {
          throw Exception('자동로그인에 실패했어요');
        }
      } catch (e) {
        throw Exception('자동로그인에 실패했어요: $e');
      }
    }
  }

  // 로그인 ID 중복 확인
  Future<Map<String, dynamic>> checkLoginIdAvailability(String loginId) async {
    try {
      final response = await _dio.get('/users/check',
          queryParameters: {'login_id': loginId},
          options: Options(headers: {'no-token': true}) // 토큰을 포함하지 않음
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
