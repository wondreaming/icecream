import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icecream/com/widget/default_layout.dart';
import 'package:icecream/provider/user_provider.dart';
import 'package:icecream/setting/widget/custom_text_container.dart';
import 'package:icecream/setting/widget/profile.dart';
import 'package:provider/provider.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    // user 정보 가져오기
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return DefaultLayout(
      title: '설정',
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20.0,
        ),
        child: Column(
          children: [
            Profile(
              imgUrl: userProvider.profileImage,
              number: userProvider.phoneNumber,
              name: userProvider.username,
              onPressed: () {
                context.goNamed('my_page');
              },
            ),
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
