import 'package:flutter/material.dart';
import 'package:icecream/com/widget/default_layout.dart';
import 'package:icecream/setting/widget/custom_popupbutton.dart';
import 'package:icecream/setting/widget/detail_profile.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '마이 페이지',
      action: [
        CustomPopupButton(
          first: '비밀번호 변경',
          secound: '로그아웃',
          third: '회원 탈퇴',
          firstOnTap: () {
            Future.delayed(
              const Duration(seconds: 0),
              () => showDialog(
                context: context,
                builder: (context) => const AlertDialog(
                  title: Text('test dialog'),
                ),
              ),
            );
          },
          secoundOnTap: () {},
          thirdOnTap: () {},
        ),
      ],
      child: DetailProfile(
        name: '김싸피',
        id: 'ssafy',
        number: '010-1234-5678',
      ),
    );
  }
}
