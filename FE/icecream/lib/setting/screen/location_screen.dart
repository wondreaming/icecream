import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:icecream/com/const/color.dart';
import 'package:icecream/com/widget/default_layout.dart';
import 'package:icecream/setting/widget/custom_elevated_button.dart';
import 'package:icecream/setting/widget/custom_modal.dart';
import 'package:icecream/setting/widget/custom_show_dialog.dart';
import 'package:icecream/setting/widget/custom_text_container.dart';
import 'package:icecream/setting/widget/day_container.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '안심 보행 설정',
      child: SingleChildScrollView(
        keyboardDismissBehavior:
            ScrollViewKeyboardDismissBehavior.onDrag, // 드래그시, 화면에 있는 키보드 사라짐
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
              CustomTextContainer(
                  text: '장소이름',
                  is_frontIcon: false,
                  is_detail: true,
                  hintText: '10자 이내로 장소를 입력해주세요'),
              CustomTextContainer(
                text: '장소',
                is_frontIcon: false,
                is_explain: true,
                explainText: '주소를 입력해주세요',
                onTap: () {
                  context.goNamed('search');
                },
              ),
              CustomTextContainer(
                text: '요일',
                is_frontIcon: false,
                is_explain: true,
                explainText: '매일',
                onTap: () {
                  showCustomModal(
                    context,
                    '요일 설정',
                    Column(
                      children: [
                        SizedBox(height: 16.0),
                        Row(
                          children: [DayContainer(day: '매일'),DayContainer(day: '월요일'), DayContainer(day: '화요일'), DayContainer(day: '수요일')],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: [DayContainer(day: '목요일'),DayContainer(day: '금요일'), DayContainer(day: '토요일'), DayContainer(day: '일요일')],
                        ),
                        SizedBox(height: 16.0),
                        CustomElevatedButton(onPressed: () {}, child: '저장'),
                      ],
                    ),
                    200.0,
                  );
                },
              ),
              CustomTextContainer(
                text: '시작 시간',
                is_frontIcon: false,
                is_explain: true,
                explainText: '00:00',
              ),
              CustomTextContainer(
                text: '종료 시각',
                is_frontIcon: false,
                is_explain: true,
                explainText: '23:59',
              ),
              // CustomElevatedButton(onPressed: (){}, child: '저장',),
            ],
          ),
        ),
      ),
    );
  }
}
