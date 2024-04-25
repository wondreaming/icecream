import 'package:flutter/material.dart';
import 'package:icecream/com/widget/default_layout.dart';

class Goal extends StatelessWidget {
  const Goal({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '부모 리워드',
      child: Center(
        child: Text('부모 리워드 페이지'),
      ),
    );
  }
}
