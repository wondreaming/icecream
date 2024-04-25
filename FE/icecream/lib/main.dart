import 'package:flutter/material.dart';
import 'package:icecream/com/router/router.dart';

void main() async {
  // 앱 시작 시 환경 변수 로드
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // router 환경설정
      routerConfig: router,
    );
  }
}
