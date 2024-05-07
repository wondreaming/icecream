import 'package:flutter/material.dart';
import 'package:icecream/com/const/color.dart';

class DefaultLayout extends StatelessWidget {
  final Widget child;
  final String title;
  final List<Widget>? action;
  final EdgeInsets padding; // 패딩값 추가
  final bool isMap;
  final Widget? floatingActionButton;

  const DefaultLayout({
    super.key,
    required this.child,
    required this.title,
    this.action,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0), // 기본값 설정
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
      body: Padding( // 패딩값 사용
        padding: isMap
            ? EdgeInsets.symmetric(horizontal: 0.0)
            : EdgeInsets.symmetric(horizontal: 16.0),
        child: child,
      ),
    );
  }
}
