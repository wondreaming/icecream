import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icecream/com/widget/default_layout.dart';
import 'package:icecream/setting/widget/add_container.dart';
import 'package:icecream/setting/widget/profile.dart';

class ChildScreen extends StatelessWidget {
  const ChildScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '자녀 관리',
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20.0,
        ),
        child: Column(
          children: [
            Profile(
              number: '010-1234-5678',
              name: '김자식',
              onPressed: () {
                context.goNamed('child');
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            AddContainer(
              mention: '자녀를 추가해주세요',
              onPressed: () {
                context.push('/qrscan_page');
              }, //QR로 이동하는 go_router 작성
            ),
          ],
        ),
      ),
    );
  }
}
