import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icecream/com/widget/default_layout.dart';
import 'package:icecream/setting/widget/custom_text_container.dart';
import 'package:icecream/setting/widget/profile.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '설정',
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20.0,
        ),
        child: Column(
          children: [
            Profile(number: '010-1234-5678', name: '김싸피', onPressed: () {
              context.goNamed('my_page');
            },),
            SizedBox(
              height: 20.0,
            ),
            GestureDetector(
              onTap: () {
                context.goNamed('children');
              },
              child: CustomTextContainer(
                backIcon: Icons.arrow_forward_ios_rounded,
                text: '자녀관리',
                isFrontIcon: false,
                onPressed: () {
                  context.goNamed('children');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
