import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icecream/com/widget/default_layout.dart';
import 'package:icecream/setting/widget/custom_elevated_button.dart';
import 'package:icecream/setting/widget/custom_modal.dart';
import 'package:icecream/setting/widget/custom_popupbutton.dart';
import 'package:icecream/setting/widget/custom_show_dialog.dart';
import 'package:icecream/setting/widget/custom_text_field.dart';
import 'package:icecream/setting/widget/detail_profile.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '마이 페이지',
      action: [
        CustomPopupButton(
          first: '비밀번호 변경',
          secound: '로그아웃',
          third: '회원 탈퇴',
          firstOnTap: () {
            showCustomModal(
              context,
              '비밀번호 변경',
              Column(
                children: [
                  SizedBox(height: 16.0),
                  CustomTextField(
                    hintText: '현재 비밀번호를 입력해주세요',
                  ),
                  SizedBox(height: 16.0),
                  CustomElevatedButton(onPressed: () {
                    context.pop();
                    changePasswordModal(context);
                  }, child: '다음'),
                ],
              ),
              160.0,
            );
          },
          secoundOnTap: () {
            showCustomDialog(context, '로그아웃하시겠습니까?');
          },
          thirdOnTap: () {
            showCustomDialog(context, '회원 탈퇴하시겠습니까?');
          },
        ),
      ],
      child: DetailProfile(
        name: '김싸피',
        id: 'ssafy',
        number: '010-1234-5678',
      ),
    );
  }
}

// 비밀번호 변경 모달
void changePasswordModal(BuildContext context){
  showCustomModal(
    context,
    '비밀번호 변경',
    Column(
      children: [
        SizedBox(height: 16.0),
        CustomTextField(
          hintText: '변경할 비밀번호를 입력해주세요',
        ),
        SizedBox(height: 16.0),
        CustomTextField(
          hintText: '변경할 비밀번호를 다시 입력해주세요',
        ),
        SizedBox(height: 16.0),
        CustomElevatedButton(onPressed: () {context.pop();}, child: '저장'),
      ],
    ),
    220.0,
  );
}
