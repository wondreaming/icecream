import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../service/user_service.dart';
import 'package:icecream/provider/user_provider.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('로그인 ID와 비밀번호를 입력하세요')));
      return;
    }
    debugPrint('loginId: $loginId');
    debugPrint('password: $password');
    debugPrint('fcmToken: $_fcmToken');
    try {
      await _userService.loginUser(loginId, password, _fcmToken, userProvider);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('로그인 성공')));
    } catch (e) {
      debugPrint("$e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('로그인 실패: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('로그인')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _loginIdController,
              decoration: InputDecoration(labelText: '로그인 ID'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: '비밀번호'),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: Text('로그인')),
          ],
        ),
      ),
    );
  }
}