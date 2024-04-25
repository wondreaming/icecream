import 'package:flutter/material.dart';
import 'package:icecream/com/widget/default_layout.dart';


class ChildrenScreen extends StatelessWidget {
  const ChildrenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '자녀 관리',
      child: Center(
        child: Text('자녀 관리 페이지'),
      ),
    );
  }
}
