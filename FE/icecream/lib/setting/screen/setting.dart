import 'package:flutter/material.dart';
import 'package:icecream/setting/widget/default_layout.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Center(
        child: Text('세팅'),
      ),
    );
  }
}
