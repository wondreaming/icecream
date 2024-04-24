import 'package:flutter/material.dart';
import 'package:icecream/com/widget/default_layout.dart';

class PMain extends StatelessWidget {
  const PMain({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Center(
        child: Text('보호자 메인 페이지'),
      ),
    );
  }
}
