import 'package:flutter/material.dart';
import 'package:icecream/setting/widget/default_layout.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '마이 페이지',
      child: Center(
      child: Text('마이페이지'),
    ),);
  }
}
