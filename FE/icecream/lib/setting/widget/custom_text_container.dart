import 'package:flutter/material.dart';
import 'package:icecream/com/const/color.dart';
import 'package:icecream/setting/widget/custom_text_field_v2.dart';

class CustomTextContainer extends StatelessWidget {
  final IconData? frontIcon;
  final IconData? backIcon;
  final VoidCallback? onPressed;
  final String text;
  final bool is_frontIcon;
  final bool is_detail;
  final String? hintText;
  final bool is_explain;
  final String? explainText;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  const CustomTextContainer(
      {super.key,
      required this.text,
      this.frontIcon,
      this.backIcon,
      this.is_frontIcon = true,
      this.onPressed,
      this.is_detail = false,
      this.hintText,
      this.is_explain = false,
      this.explainText,
      this.onTap,
      this.onChanged,
      this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.profile_black.withOpacity(0.5),
          ),
        ),
      ),
      margin: EdgeInsets.only(top: 5.0),
      child: Row(
        children: [
          if (is_frontIcon)
            Flexible(
              child: Icon(
                frontIcon,
                size: 50,
              ),
              flex: 1,
            ),
          Flexible(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                text,
                style: TextStyle(
                  fontFamily: 'GmarketSans',
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            flex: 6,
          ),
          if (!is_frontIcon)
            Flexible(
              child: IconButton(
                icon: Icon(
                  backIcon,
                  color: AppColors.custom_black,
                ),
                onPressed: onPressed,
              ),
              flex: 1,
              fit: FlexFit.tight,
            ),
          if (is_detail)
            Flexible(
              child: CustomTextFieldVersion2(
                controller: controller,
                onChanged: onChanged,
                hintText: hintText,
              ),
              flex: 15,
              fit: FlexFit.tight,
            ),
          if (is_explain)
            Flexible(
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: onTap,
                  child: Text(
                    explainText!,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'GmarketSans',
                      color: AppColors.input_text_color,
                    ),
                  ),
                ),
              ),
              flex: 15,
              fit: FlexFit.tight,
            ),
        ],
      ),
    );
  }
}
