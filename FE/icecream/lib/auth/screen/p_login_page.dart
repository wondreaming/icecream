import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icecream/com/widget/default_layout.dart';
import 'package:provider/provider.dart';
import '../service/user_service.dart';
import 'package:icecream/provider/user_provider.dart';
import 'package:icecream/setting/widget/custom_text_field.dart';
import 'package:icecream/setting/widget/custom_elevated_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _loginIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UserService _userService = UserService();
  String _fcmToken = '';

  @override
  void initState() {
    super.initState();
    _loadFCMToken();
  }

  Future<void> _loadFCMToken() async {
    _fcmToken = await _userService.getFCMToken();
  }

  Future<void> _login() async {
    final String loginId = _loginIdController.text.trim();
    final String password = _passwordController.text.trim();
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (loginId.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('로그인 ID와 비밀번호를 입력하세요')));
      return;
    }
    debugPrint('loginId: $loginId');
    debugPrint('password: $password');
    debugPrint('fcmToken: $_fcmToken');
    try {
      await _userService.loginUser(loginId, password, _fcmToken, userProvider);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('로그인 성공')));
      context.goNamed('parents'); // 부모 유저 로그인 성공시 PHome으로 이동
    } catch (e) {
      debugPrint("$e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('로그인 실패: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      isSetting: true,
      title: '로그인',
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            CustomTextField(
              controller: _loginIdController,
              hintText: '로그인 ID',
              contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: _passwordController,
              hintText: '비밀번호',
              obscureText: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            ),
            const SizedBox(height: 20),
            CustomElevatedButton(
              onPressed: _login,
              child: '로그인',
              height: 55,
            ),
          ],
        ),
      ),
    );
  }
}