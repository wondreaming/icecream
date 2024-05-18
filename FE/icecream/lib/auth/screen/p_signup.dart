import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:icecream/com/widget/default_layout.dart';
import '../service/user_service.dart';
import 'package:icecream/setting/widget/custom_text_field.dart';
import 'package:icecream/setting/widget/custom_elevated_button.dart';

import 'p_login_page.dart';

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
  final TextEditingController _passwordCheckController = TextEditingController();

  String _deviceId = '';
  bool _isLoading = false;
  final UserService _userService = UserService();
  final FocusNode _loginIdFocusNode = FocusNode();
  String? _usernameError;
  String? _phoneNumberError;
  String? _loginIdError;
  String? _passwordError;
  String? _passwordCheckError;

  Color? _loginIdBorderColor;

  bool _passwordVisible = false; // 비밀번호 가리기/보이기 상태 변수 추가
  bool _passwordCheckVisible = false;

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
      _checkLoginIdAvailability();
    }
  }

  Future<void> _checkLoginIdAvailability() async {
    String loginId = _loginIdController.text;
    if (loginId.isEmpty) {
      setState(() {
        _loginIdError = '로그인 ID를 입력하세요';
        _loginIdBorderColor = Colors.red;
      });
      return;
    }

    try {
      var result = await _userService.checkLoginIdAvailability(loginId);
      if (result['isAvailable']) {
        setState(() {
          _loginIdError = null;
          _loginIdBorderColor = Colors.green;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
      } else {
        setState(() {
          _loginIdError = result['message'];
          _loginIdBorderColor = Colors.red;
        });
      }
    } catch (e) {
      setState(() {
        _loginIdError = '아이디 중복 검사에 실패했습니다';
        _loginIdBorderColor = Colors.red;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('아이디 중복 검사에 실패했습니다: $e')),
      );
    }
  }

  Future<void> registerUser() async {
    bool isValid = _validateFormFields();
    if (!isValid || _isLoading) {
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
      // 회원가입 성공 시 로그인 페이지로 이동
      GoRouter.of(context).pushReplacementNamed('p_login');
    } catch (e) {
      debugPrint("$e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('회원가입 실패: $e')),
      );
    }
  }

  bool _validateFormFields() {
    bool isValid = true;

    String? usernameError = _validateUsername(_usernameController.text);
    String? phoneNumberError = _validatePhoneNumber(_phoneNumberController.text);
    String? loginIdError = _validateLoginId(_loginIdController.text);
    String? passwordError = _validatePassword(_passwordController.text);
    String? passwordCheckError = _validatePasswordCheck(_passwordCheckController.text);

    setState(() {
      _usernameError = usernameError;
      _phoneNumberError = phoneNumberError;
      _loginIdError = loginIdError;
      _passwordError = passwordError;
      _passwordCheckError = passwordCheckError;
    });

    if (usernameError != null ||
        phoneNumberError != null ||
        loginIdError != null ||
        passwordError != null ||
        passwordCheckError != null) {
      isValid = false;
    }

    return isValid;
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return '이름을 입력하세요';
    }
    final regex = RegExp(r'^[a-zA-Z가-힣]+$');
    if (!regex.hasMatch(value)) {
      return '이름은 한글 또는 영어만 가능합니다';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return '전화번호를 입력하세요';
    }
    final regex = RegExp(r'^010-\d{4}-\d{4}$');
    if (!regex.hasMatch(value)) {
      return '전화번호 형식이 올바르지 않습니다. (010-0000-0000)';
    }
    return null;
  }

  String? _validateLoginId(String? value) {
    if (value == null || value.isEmpty) {
      return '로그인 ID를 입력하세요';
    }
    final regex = RegExp(r'^[a-zA-Z0-9]{6,20}$');
    if (!regex.hasMatch(value)) {
      return '로그인 ID는 영문과 숫자를 포함한 6~20자리여야 합니다';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '비밀번호를 입력하세요';
    }
    final regex = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d!@#$%^&*]{8,20}$');
    if (!regex.hasMatch(value)) {
      return '비밀번호는 영문과 숫자를 포함한 8~20자리여야 합니다';
    }
    return null;
  }

  String? _validatePasswordCheck(String? value) {
    if (value != _passwordController.text) {
      return '비밀번호가 일치하지 않습니다';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      isSetting: true,
      title: '회원가입',
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              CustomTextField(                
                controller: _usernameController,
                hintText: '이름',
                errorText: _usernameError,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              ),
              SizedBox(height: 10),
              CustomTextField(
                controller: _phoneNumberController,
                hintText: '전화번호',
                errorText: _phoneNumberError,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                inputFormatters: [PhoneNumberFormatter()], // 전화번호 포맷터 추가
              ),
              SizedBox(height: 10),
              CustomTextField(
                controller: _loginIdController,
                hintText: '로그인 ID',
                focusNode: _loginIdFocusNode,
                errorText: _loginIdError,
                borderColor: _loginIdBorderColor,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              ),
              SizedBox(height: 10),
              CustomTextField(
                controller: _passwordController,
                obscureText: !_passwordVisible, // 비밀번호 가리기/보이기 상태 연결
                hintText: '비밀번호',
                errorText: _passwordError,
                maxLines: 1,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
              SizedBox(height: 10),
              CustomTextField(
                controller: _passwordCheckController,
                obscureText: !_passwordVisible,
                hintText: '비밀번호 확인',
                errorText: _passwordCheckError,
                maxLines: 1,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              ),
              SizedBox(height: 20),
              CustomElevatedButton(
                onPressed: registerUser,
                child: '회원가입',
                width: double.infinity,
                height: 70,
              ),
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