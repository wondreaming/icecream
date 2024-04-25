import 'package:flutter/material.dart';
import 'package:icecream/com/const/color.dart';
import 'package:icecream/setting/widget/custom_elevated_button.dart';
import 'package:icecream/setting/widget/custom_text_field.dart';

void customModal(BuildContext context) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return const _CustomModalContent(
            title: '비밀번호 변경', buttonName: '다음', hintText: '뭐지');
      },
      backgroundColor: AppColors.background_color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      isScrollControlled: false, // modal의 최대 높이가 전체 화면의 1/2
      barrierLabel:
          "이제 모달이 열려 있어서 화면이 더 어두워졌습니다. 이 메뉴를 닫을 때까지 앱의 나머지 부분을 터치할 수 없습니다." // 시각 장애인을 위한 안내 멘트
      );
}

class _CustomModalContent extends StatelessWidget {
  final String title;
  final String buttonName;
  final VoidCallback? onPressed;
  final String? hintText;
  const _CustomModalContent(
      {super.key,
      required this.title,
      required this.buttonName,
      this.onPressed,
      this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Text(title),
          CustomTextField(
            hintText: hintText,
          ),
          CustomElevatedButton(onPressed: (){}, child: buttonName),
        ],
      ),
    );
  }
}
