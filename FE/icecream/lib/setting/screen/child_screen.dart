import 'package:flutter/material.dart';
import 'package:icecream/com/widget/default_layout.dart';


class ChildScreen extends StatelessWidget {
  const ChildScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '자녀 관리',
      child: Center(
      child: Text('자녀 1명의 페이지'),
    ),);
  }
}
