import 'package:flutter/material.dart';
import 'package:icecream/com/const/color.dart';
import 'package:icecream/com/widget/default_layout.dart';
import 'package:icecream/setting/widget/custom_elevated_button.dart';
import 'package:icecream/setting/widget/custom_text_container.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '안심 보행 설정',
      child: Container(
        padding: const EdgeInsets.only(
          top: 20.0,
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.container_background_color,
              ),
              height: 130,
              width: double.infinity,
            ),
            CustomTextContainer(text: '장소이름', is_frontIcon: false,),
            CustomTextContainer(text: '장소', is_frontIcon: false,),
            CustomTextContainer(text: '요일', is_frontIcon: false,),
            CustomTextContainer(text: '시작 시간', is_frontIcon: false,),
            CustomTextContainer(text: '종료 시각', is_frontIcon: false,),
            // CustomElevatedButton(onPressed: (){}, child: '저장',),
          ],
        ),
      ),
    );
  }
}
