import 'package:flutter/material.dart';
import 'package:icecream/com/widget/default_layout.dart';


class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '안심 보행 설정',
      child: Center(
      child: Text('안심보행 설정 페이지'),
    ),);
  }
}
