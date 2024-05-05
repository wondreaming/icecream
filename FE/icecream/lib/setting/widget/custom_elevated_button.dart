import 'package:flutter/material.dart';
import 'package:icecream/com/const/color.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String child;
  final Color backgroundColor;
  final Color foregroundColor;
  final double width;
  final bool isSearch;
  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.backgroundColor = AppColors.custom_yellow,
    this.foregroundColor = AppColors.text_color,
    this.width = double.infinity,
    this.isSearch = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // 사이즈 설정
      width: width,
      height: 40,
      child: ElevatedButton(
        onPressed: onPressed,
        child: isSearch
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_searching),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(child)
                ],
              )
            : Text(child),
        style: ElevatedButton.styleFrom(
          side: isSearch
              ? BorderSide(
                  width: 1.0,
                  color: AppColors.input_text_color.withOpacity(0.5))
              : null,
          // 테두리
          shape: isSearch
              ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                )
              : RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
          // 버튼 색상
          backgroundColor: backgroundColor,
          // 글자 색상
          foregroundColor: foregroundColor,
          // 글꼴
          textStyle: isSearch
              ? TextStyle(
                  fontFamily: 'GmarketSans',
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                )
              : TextStyle(
                  fontFamily: 'GmarketSans',
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
          elevation: 0.0,
        ),
      ),
    );
  }
}
