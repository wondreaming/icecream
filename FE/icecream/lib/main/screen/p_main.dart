import 'package:flutter/material.dart';
import 'package:icecream/com/widget/default_layout.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class PMain extends StatefulWidget {
  const PMain({super.key});

  @override
  _PMainState createState() => _PMainState();
}

class _PMainState extends State<PMain> {
  late Future<void> _initKakaoMapFuture;

  @override
  void initState() {
    super.initState();
    _initKakaoMapFuture = initKakaoMap();
  }

  Future<void> initKakaoMap() async {
    await dotenv.load(); // 환경 변수 로드
    final mapApiKey = dotenv.env['KAKAO_API_KEY'];
    AuthRepository.initialize(appKey: '$mapApiKey'); // API 키 설정
    setState(() {}); // 상태 업데이트
  }

  @override
  Widget build(BuildContext context) {
    print("KakaoMap Widget is being built.");
    return DefaultLayout(
      title: '보호자 메인',
      child: Scaffold(
        body: FutureBuilder(
          future: _initKakaoMapFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return const KakaoMap();
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
