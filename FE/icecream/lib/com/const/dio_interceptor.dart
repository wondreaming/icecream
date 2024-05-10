import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

class CustomDio {
  // baseurl 설정
  static const String baseUrl = "http://k10e202.p.ssafy.io:8080/api";
  Dio createDio() {
    final Dio dio = Dio(BaseOptions(baseUrl: baseUrl));
    dio.options.validateStatus = (status) => true;  // 모든 상태 코드를 유효한 것으로 처리
    
    // 인터셉터 추가
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        print('Sending request to ${options.uri.toString()}');
        // SharedPreferences에서 토큰 불러오기
        final prefs = await SharedPreferences.getInstance();
        final String? accessToken = prefs.getString('accessToken');

        // 'no-token' 헤더가 true일 경우 토큰을 추가하지 않습니다.
        if (options.headers['no-token'] != true) {
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
        }
        // 'no-token' 헤더가 있는 경우 제거하여 실제 요청에는 포함되지 않도록 합니다.
        options.headers.remove('no-token');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // 응답 로깅
        log('Response: ${response.data}', name: 'CustomDio');
        return handler.next(response);
      },
      onError: (DioError e, handler) async {
        if (e.response?.statusCode == 401) {
          // 401은 토큰 만료를 의미
          final Dio dioNew = Dio(BaseOptions(baseUrl: baseUrl));
          final prefs = await SharedPreferences.getInstance();
          final String? refreshToken = prefs.getString('refreshToken');

          if (refreshToken != null) {
            try {
              final response = await dioNew.post(
                '/auth/reissue',
                data: {'refreshToken': refreshToken},
              );

              if (response.statusCode == 200) {
                final String newAccessToken = response.data['accessToken'];
                await prefs.setString('accessToken', newAccessToken);

                final RequestOptions requestOptions = e.requestOptions;
                requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

                return dio.fetch(requestOptions).then(
                      (r) => handler.resolve(r),
                      onError: (e) => handler.next(e),
                    );
              }
            } catch (reissueError) {
              log('Token reissue error: $reissueError', name: 'CustomDio');
              return handler.next(e);
            }
          }
        }
        // 다른 HTTP 에러 처리
        log('Error: ${e.response?.data}', name: 'CustomDio');
        return handler.next(e);
      },
    ));

    return dio;
  }
}
