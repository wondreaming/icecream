import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:icecream/child/models/timeset_model.dart';

class TimeSetService {
  final Dio _dio = Dio(); // 필요한 인터셉터와 기본 URL을 설정하여 Dio 인스턴스 구성
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<List<Data>> fetchTimeSets(String userId) async {
    try {
      String token = await _secureStorage.read(key: 'accessToken') ?? '';
      final response = await _dio.get(
        'http://k10e202.p.ssafy.io:8080/api/goal?user_id=$userId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        List<Data> timeSets = (response.data['data'] as List)
            .map((item) => Data.fromJson(item))
            .toList();
        return timeSets;
      } else {
        throw Exception('시간 설정 데이터를 불러오는 데 실패했습니다');
      }
    } catch (e) {
      throw Exception('데이터를 가져오는 데 실패했습니다: $e');
    }
  }
}
