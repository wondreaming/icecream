import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icecream/com/const/color.dart';
import 'package:icecream/setting/widget/custom_elevated_button.dart';

void showCustomDialog(BuildContext context, String content) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: AppColors.background_color,
        content: Text(
          content,
          style: TextStyle(
            fontFamily: 'GmarketSans',
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          Row(
            children: [
              Flexible(
                child: CustomElevatedButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: '예',
                ),
                flex: 1,
              ),
              SizedBox(
                width: 10.0,
              ),
              Flexible(
                child: CustomElevatedButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: '아니요',
                ),
                flex: 1,
              ),
            ],
          ),
        ],
      );
    },
  );
}
