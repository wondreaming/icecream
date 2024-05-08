import 'package:flutter/material.dart';
import '../service/user_service.dart';

class ChildRegisterPage extends StatefulWidget {
  final String deviceId;
  final String fcmToken;

  const ChildRegisterPage({
    Key? key,
    required this.deviceId,
    required this.fcmToken,
  }) : super(key: key);

  @override
  _ChildRegisterPageState createState() => _ChildRegisterPageState();
}

class _ChildRegisterPageState extends State<ChildRegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _registerChild() async {
    final String name = _nameController.text.trim();
    final String phonenum = _phoneController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('이름을 입력하세요')));
      return;
    }

    if (phonenum.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('전화번호를 입력하세요')));
      return;
    }

    final data = {
      'username': name,
      'phone_number': phonenum,
      'device_id': widget.deviceId,
      'fcm_token': widget.fcmToken,
    };
    debugPrint("Registering with data: $data");

    try {
      final response = await _userService.registerChild(data);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('등록 성공: ${response.data}')));
    } catch (e) {
      debugPrint("$e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('등록 실패: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('자녀 등록')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                  labelText: '자녀의 이름', border: OutlineInputBorder()),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                  labelText: '전화번호', border: OutlineInputBorder()),
            ),
            SizedBox(height: 16),
            ElevatedButton(onPressed: _registerChild, child: Text('등록하기')),
          ],
        ),
      ),
    );
  }
}
