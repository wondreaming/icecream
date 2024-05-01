import 'package:flutter/material.dart';
import 'package:icecream/com/const/color.dart';

class DefaultLayout extends StatelessWidget {
  final Widget child;
  final String title;
  final List<Widget>? action;
  const DefaultLayout(
      {super.key, required this.child, required this.title, this.action});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background_color,
      appBar: AppBar(
        title: Text(title),
        actions: action,
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: child,
      ),
    );
  }
}
