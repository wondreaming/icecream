import 'package:flutter/material.dart';
import 'package:icecream/com/const/color.dart';

class DefaultLayout extends StatelessWidget {
  final Widget child;
  final String title;
  final List<Widget>? action;
  final bool isMap;
  final Widget? floatingActionButton;
  const DefaultLayout({
    super.key,
    required this.child,
    required this.title,
    this.action,
    this.isMap = false,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // 키보드 올라왔을 때, 영역 보존
      backgroundColor: AppColors.background_color,
      appBar: AppBar(
        title: Text(title),
        actions: action,
      ),
      body: Padding(
        padding: isMap
            ? EdgeInsets.symmetric(horizontal: 0.0)
            : EdgeInsets.symmetric(horizontal: 16.0),
        child: child,
      ),
    );
  }
}
