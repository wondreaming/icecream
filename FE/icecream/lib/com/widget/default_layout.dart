import 'package:flutter/material.dart';
import 'package:icecream/com/const/color.dart';

class DefaultLayout extends StatelessWidget {
  final Widget child;
  final String title;
  final List<Widget>? action;
  final EdgeInsets padding; // 패딩값 추가
  final bool isMap;
  final Widget? floatingActionButton;
  final bool? automaticallyImplyLeading;
  const DefaultLayout({
    super.key,
    required this.child,
    required this.title,
    this.action,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0), // 기본값 설정
    this.isMap = false,
    this.floatingActionButton,
    this.automaticallyImplyLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // 키보드 올라왔을 때, 영역 보존
      backgroundColor: AppColors.background_color,
      appBar: AppBar(
        automaticallyImplyLeading: automaticallyImplyLeading!,
        scrolledUnderElevation: 0,
        title: Text(title, style: TextStyle(fontSize : 32, fontWeight:FontWeight.w500, fontFamily:'GmarketSans',),),
        actions: action,
        centerTitle: false,  // 제목을 왼쪽으로 정렬
        toolbarHeight: 80.0, // 앱바의 높이를 조정
        titleSpacing: 20.0,  // 제목의 시작 부분에 공간
      ),
      body: Padding(
        // 패딩값 사용
        padding: isMap
            ? EdgeInsets.symmetric(horizontal: 0.0)
            : EdgeInsets.symmetric(horizontal: 16.0),
        child: child,
      ),
    );
  }
}
