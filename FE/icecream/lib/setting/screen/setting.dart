import 'package:flutter/material.dart';
import 'package:icecream/com/const/color.dart';
import 'package:icecream/com/widget/default_layout.dart';
import 'package:icecream/setting/widget/custom_elevated_button.dart';
import 'package:icecream/setting/widget/custom_icon.dart';
import 'package:icecream/setting/widget/custom_modal.dart';
import 'package:icecream/setting/widget/custom_text_field.dart';

import 'package:icecream/setting/widget/profile.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        title: '설정',
        child: Column(
          children: [
            Profile(),
            CustomTextField(
              hintText: '아림',
            ),
            CustomElevatedButton(
                onPressed: () {
                  customModal(context);
                },
                child: '저장'),
            CustomIcon(color: AppColors.custom_green, icon: Icons.home_filled)
          ],
        ));
  }
}
