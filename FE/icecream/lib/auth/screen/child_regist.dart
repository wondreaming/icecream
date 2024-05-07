import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class ChildRegisterPage extends StatefulWidget {
  final String deviceId;
  final String fcmToken;
  final String phoneNum;

  const ChildRegisterPage({
    Key? key,
    required this.deviceId,
    required this.fcmToken,
    required this.phoneNum,
  }) : super(key: key);

  @override
  _ChildRegisterPageState createState() => _ChildRegisterPageState();
}

class _ChildRegisterPageState extends State<ChildRegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  // 전화번호를 위한 TextEditingController 생성
  final TextEditingController _phoneController;
  final Dio _dio = Dio();

  // Constructor에서 전달받은 전화번호를 초기값으로 설정
  _ChildRegisterPageState() : _phoneController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    // 초기화 후에 전달받은 전화번호로 텍스트 필드 설정
    _phoneController.text = widget.phoneNum;
  }

  Future<void> registerChild() async {
    final String name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이름을 입력하세요')),
      );
      return;
    }
    // 데이터를 콘솔에 출력
    debugPrint('등록 데이터:');
    debugPrint('이름: $name');
    debugPrint('전화번호: ${widget.phoneNum}');
    debugPrint('FCM 토큰: ${widget.fcmToken}');
    debugPrint('디바이스 ID: ${widget.deviceId}');

    // try {
    //   final response = await _dio.post(
    //     'https://yourapi.com/register',  // 실제 서버 API 엔드포인트로 변경
    //     data: {
    //       'username': name,
    //       'phone_number': widget.phoneNum,
    //       'device_id': widget.deviceId,
    //       'fcm_token': widget.fcmToken,
    //     }
    //   );
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('등록 성공: ${response.data}')),
    //   );
    // } catch (e) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('등록 실패: $e')),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('자녀 등록'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: '자녀의 이름',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              enabled: false,
              controller: _phoneController,  // 전화번호를 위한 컨트롤러 사용
              decoration: InputDecoration(
                labelText: '전화번호',
                border: OutlineInputBorder(),
                hintText: widget.phoneNum,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: registerChild,
              child: Text('등록하기'),
            ),
          ],
        ),
      ),
    );
  }
}
