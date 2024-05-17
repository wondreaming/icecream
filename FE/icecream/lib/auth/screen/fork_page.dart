import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:icecream/auth/service/user_service.dart';
import 'package:icecream/com/widget/default_layout.dart';
import 'package:icecream/provider/user_provider.dart';
import 'package:icecream/setting/widget/custom_elevated_button.dart';
import 'package:provider/provider.dart';

class ForkPage extends StatefulWidget {
  const ForkPage({super.key});

  @override
  State<ForkPage> createState() => _ForkPageState();
}

class _ForkPageState extends State<ForkPage> {
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
  }

  // 자동 로그인
  Future<void> _autoLogin() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      await _userService.autoLogin(userProvider);
    } catch (e) {
      debugPrint('Auto-login failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '',
      child: Center(
        child: Column(
          children: [
            CustomElevatedButton(
                onPressed: () {
                  context.goNamed('signup');
                },
                child: '부모'),
            SizedBox(
              height: 10.0,
            ),
            CustomElevatedButton(
                onPressed: () {
                  context.goNamed('c_qrcode');
                },
                child: '자녀'),
            SizedBox(
              height: 10.0,
            ),
            Text('로그인할꺼야?'),
            SizedBox(
              height: 10.0,
            ),
            CustomElevatedButton(
                onPressed: () {
                  context.goNamed('p_login');
                },
                child: '로그인 버튼'),
            SizedBox(
              height: 10.0,
            ),
            CustomElevatedButton(
                onPressed: () {
                  context.goNamed('overspeed1');
                },
                child: 'overspeed1'),
            SizedBox(
              height: 10.0,
            ),
            CustomElevatedButton(
                onPressed: () {
                  context.goNamed('overspeed2');
                },
                child: 'overspeed2'),
            SizedBox(
              height: 10.0,
            ),
            CustomElevatedButton(
                onPressed: () {
                  context.goNamed('overspeed3');
                },
                child: 'overspeed3'),
          ],
        ),
      ),
    );
  }
}
//     );
//   }
// }
