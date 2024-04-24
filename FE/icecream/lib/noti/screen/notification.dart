import 'package:flutter/material.dart';
import 'package:icecream/com/widget/default_layout.dart';

class Noti extends StatelessWidget {
  const Noti({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Center(
        child: Text('알림 페이지'),
      ),
    );
  }
}
