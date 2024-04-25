import 'package:flutter/material.dart';
import 'package:icecream/com/const/color.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String child;
  final Color backgroundColor;
  final Color foregroundColor;
  final double width;
  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.backgroundColor = AppColors.custom_yellow,
    this.foregroundColor = AppColors.text_color,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // 사이즈 설정
      width: width,
      height: 40,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(child),
        style: ElevatedButton.styleFrom(
          // 테두리
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          // 버튼 색상
          backgroundColor: backgroundColor,
          // 글자 색상
          foregroundColor: foregroundColor,
          // 글꼴
          textStyle: TextStyle(
              fontFamily: 'GmarketSans',
              fontSize: 20,
              fontWeight: FontWeight.w400,),
        ),
      ),
    );
  }
}
