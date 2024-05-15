import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../service/user_service.dart';
import 'package:icecream/setting/widget/custom_text_field.dart';
import 'package:icecream/setting/widget/custom_elevated_button.dart';

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

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String formattedText = _getFormattedPhoneNumber(newValue.text);
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }

  String _getFormattedPhoneNumber(String value) {
    value = _cleanPhoneNumber(value);

    if (value.length <= 3) {
      // 010 입력 중
      return value;
    } else if (value.length <= 7) {
      // 010-xxxx 포맷
      return '${value.substring(0, 3)}-${value.substring(3)}';
    } else if (value.length <= 11) {
      // 010-xxxx-xxxx 포맷
      return '${value.substring(0, 3)}-${value.substring(3, 7)}-${value.substring(7)}';
    } else {
      // 길이가 11자를 넘지 않도록 제한
      return '${value.substring(0, 3)}-${value.substring(3, 7)}-${value.substring(7, 11)}';
    }
  }

  String _cleanPhoneNumber(String value) {
    return value.replaceAll(RegExp(r'[^0-9]'), '');
  }
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
          .showSnackBar(const SnackBar(content: Text('이름을 입력하세요')));
      return;
    }

    if (phonenum.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('전화번호를 입력하세요')));
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
      appBar: AppBar(title: const Text('자녀 등록')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(
              controller: _nameController,
              hintText: '자녀의 이름',
              contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _phoneController,
              hintText: '전화번호',
              contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              inputFormatters: [PhoneNumberFormatter()], // 전화번호 포맷터 추가
            ),
            const SizedBox(height: 16),
            CustomElevatedButton(
              onPressed: _registerChild,
              child: '등록하기',
            ),
          ],
        ),
      ),
    );
  }
}