import 'package:flutter/material.dart';
import '../service/user_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _loginIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordCheckController =
      TextEditingController();
  // final TextEditingController _deviceIdController = TextEditingController();
  String _deviceId = '';
  bool _isLoading = false;
  final UserService _userService = UserService();
  final FocusNode _loginIdFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadDeviceId();
    _loginIdFocusNode.addListener(_onLoginIdFocusChange);
  }

  Future<void> _loadDeviceId() async {
    setState(() => _isLoading = true);
    _deviceId = await _userService.getDeviceId();
    setState(() => _isLoading = false);
  }

  void _onLoginIdFocusChange() {
    if (!_loginIdFocusNode.hasFocus) {
      // 포커스가 사라졌을 때 실행할 로직
      _checkLoginIdAvailability();
    }
  }

  void _checkLoginIdAvailability() async {
    if (!_loginIdFocusNode.hasFocus) {
      String loginId = _loginIdController.text;
      if (loginId.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('로그인 ID를 입력하세요')));
        return;
      }
      var result = await _userService.checkLoginIdAvailability(loginId);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result['message'])));
    }
  }

  Future<void> registerUser() async {
    if (!_formKey.currentState!.validate() || _isLoading) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('입력 정보를 확인하세요.')));
      return;
    }

    final data = {
      "username": _usernameController.text,
      "phone_number": _phoneNumberController.text,
      "login_id": _loginIdController.text,
      "password": _passwordController.text,
      "password_check": _passwordCheckController.text,
      "device_id": _deviceId
    };
    debugPrint("Registering with data: $data");
    try {
      final response = await _userService.registerUser(data);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('회원가입 성공: ${response.data}')),
      );
    } catch (e) {
      debugPrint("$e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('회원가입 실패: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('회원가입')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: '이름'),
                  validator: (value) => value!.isEmpty ? '이름을 입력하세요' : null),
              TextFormField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(labelText: '전화번호'),
                  validator: (value) => value!.isEmpty ? '전화번호를 입력하세요' : null),
              TextFormField(
                  controller: _loginIdController,
                  decoration: InputDecoration(labelText: '로그인 ID'),
                  validator: (value) =>
                      value!.isEmpty ? '로그인 ID를 입력하세요' : null),
              TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: '비밀번호'),
                  validator: (value) => value!.isEmpty ? '비밀번호를 입력하세요' : null),
              TextFormField(
                  controller: _passwordCheckController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: '비밀번호 확인'),
                  validator: (value) => value != _passwordController.text
                      ? '비밀번호가 일치하지 않습니다'
                      : null),
              SizedBox(height: 20),
              ElevatedButton(onPressed: registerUser, child: Text('회원가입')),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _loginIdFocusNode.removeListener(_onLoginIdFocusChange);
    _loginIdFocusNode.dispose();
    super.dispose();
  }
}
