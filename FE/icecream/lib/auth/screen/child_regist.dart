import 'package:flutter/material.dart';
import '../service/user_service.dart';

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
  final TextEditingController _phoneController;
  final UserService _userService = UserService();

  _ChildRegisterPageState() : _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _phoneController.text = widget.phoneNum;
  }

  Future<void> _registerChild() async {
    final String name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('이름을 입력하세요')));
      return;
    }

    try {
      final response = await _userService.registerChild(
        username: name,
        phoneNumber: widget.phoneNum,
        deviceId: widget.deviceId,
        fcmToken: widget.fcmToken,
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('등록 성공: ${response.data}')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('등록 실패: $e')));
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
              decoration: InputDecoration(labelText: '자녀의 이름', border: OutlineInputBorder()),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              enabled: false,
              decoration: InputDecoration(labelText: '전화번호', border: OutlineInputBorder()),
            ),
            SizedBox(height: 16),
            ElevatedButton(onPressed: _registerChild, child: Text('등록하기')),
          ],
        ),
      ),
    );
  }
}