import 'package:flutter/material.dart';
import 'package:icecream/com/const/color.dart';

class CustomPopupButton extends StatelessWidget {
  final String first;
  final String secound;
  final String third;
  final VoidCallback firstOnTap;
  final VoidCallback secoundOnTap;
  final VoidCallback thirdOnTap;
  const CustomPopupButton(
      {super.key,
      required this.first,
      required this.secound,
      required this.third, required this.firstOnTap, required this.secoundOnTap, required this.thirdOnTap});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: AppColors.background_color,
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            onTap: firstOnTap,
            child: Text(
              first,
              style: TextStyle(
                fontFamily: 'GmarketSans',
                fontSize: 16.0,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          PopupMenuItem(
            onTap: secoundOnTap,
            child: Text(
              secound,
              style: TextStyle(
                fontFamily: 'GmarketSans',
                fontSize: 16.0,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          PopupMenuItem(
            onTap: thirdOnTap,
            child: Text(
              third,
              style: TextStyle(
                fontFamily: 'GmarketSans',
                fontSize: 16.0,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ];
      },
    );
  }
}
