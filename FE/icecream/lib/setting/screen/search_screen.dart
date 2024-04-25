import 'package:flutter/material.dart';
import 'package:icecream/com/widget/default_layout.dart';


class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '주소 검색',
      child: Center(
      child: Text('장소 찾는 페이지'),
    ),);
  }
}
