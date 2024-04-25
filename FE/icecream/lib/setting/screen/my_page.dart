import 'package:flutter/material.dart';
import 'package:icecream/com/widget/default_layout.dart';
import 'package:icecream/setting/widget/detail_profile.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '마이 페이지',
      child: DetailProfile(
        name: '김싸피',
        id: 'ssafy',
        number: '010-1234-5678',
      ),
    );
  }
}
