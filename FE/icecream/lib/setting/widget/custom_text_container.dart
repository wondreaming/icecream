import 'package:flutter/material.dart';
import 'package:icecream/com/const/color.dart';

class CustomTextContainer extends StatelessWidget {
  final IconData? frontIcon;
  final IconData? backIcon;
  final VoidCallback? onPressed;
  final String text;
  final bool is_frontIcon;
  const CustomTextContainer(
      {super.key,
      required this.text,
      this.frontIcon,
      this.backIcon,
      this.is_frontIcon = true,
      this.onPressed});

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
        ],
      ),
    );
  }
}
