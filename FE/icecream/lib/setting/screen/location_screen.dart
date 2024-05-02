import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:icecream/com/const/color.dart';
import 'package:icecream/com/widget/default_layout.dart';
import 'package:icecream/setting/widget/custom_elevated_button.dart';
import 'package:icecream/setting/widget/custom_modal.dart';
import 'package:icecream/setting/widget/custom_text_container.dart';
import 'package:icecream/setting/widget/day_container.dart';
import 'package:icecream/setting/widget/location_Icons.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  // 안심 보행 아이콘 선택
  final List<Widget> locationIcons = [
    LocationIcons.home,
    LocationIcons.star,
    LocationIcons.school,
    LocationIcons.flag,
    LocationIcons.favorite,
    LocationIcons.science,
    LocationIcons.music,
    LocationIcons.math,
  ];

  // 요일 선택
  late List<int> isClicked = List.filled(7, 0); // [0, 0, 0, 0, 0, 0, 0]
  final List<String> days = ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];
  // 요일 선택 토글
  void toggleDay(int index) {
    setState(() {
      isClicked[index] = isClicked[index] == 0 ? 1 : 0;
    });
  }

  // 시간 설정
  Time _startTime = Time(hour: 7, minute: 00);
  Time _endTime = Time(hour: 14, minute: 00);
  // 시작 시간 변경
  void onStartTimeChanged(Time newTime) {
    setState(() {
      _startTime = newTime;
      print(_startTime);
    });
  }

  // 종료 시간 변경
  void onEndTimeChanged(Time newTime) {
    setState(() {
      _endTime = newTime;
      print(_startTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    // 장소 이름
    late String locationName = '10자 이내로 장소를 입력해주세요';
    TextEditingController locationNameController = TextEditingController();

    return DefaultLayout(
      title: '안심 보행 설정',
      child: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(
          vertical: 20.0,
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              margin: EdgeInsets.only(bottom: 20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.container_background_color,
              ),
              height: 130,
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...locationIcons.map((locationIcon) => Container(
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        child: locationIcon))
                  ],
                ),
              ),
            ),
            CustomTextContainer(
              text: '장소 이름',
              is_frontIcon: false,
              is_detail: true,
              hintText: locationName,
              controller: locationNameController,
              onChanged: (locationNameController) {
                locationName = locationNameController;
                print(locationName);
              },
            ),
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
                        children: [
                          ...days
                              .map(
                                (day) => GestureDetector(
                                  onTap: () => toggleDay(
                                    days.indexOf(day),
                                  ),
                                  child: DayContainer(
                                    day: day,
                                    isClicked: isClicked[day.indexOf(day)],
                                  ),
                                ),
                              )
                              .toList(),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      SizedBox(height: 16.0),
                      CustomElevatedButton(
                          onPressed: () {
                            context.pop();
                          },
                          child: '저장'),
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
              explainText: _startTime.format(context),
              onTap: () {
                Navigator.of(context).push(showPicker(
                    value: _startTime,
                    sunrise: TimeOfDay(hour: 6, minute: 0), // optional
                    sunset: TimeOfDay(hour: 18, minute: 0), // optional
                    duskSpanInMinutes: 120,
                    onChange: onStartTimeChanged));
              },
            ),
            CustomTextContainer(
              text: '종료 시각',
              is_frontIcon: false,
              is_explain: true,
              explainText: _endTime.format(context),
              onTap: () {
                Navigator.of(context).push(showPicker(
                    value: _endTime,
                    sunrise: TimeOfDay(hour: 6, minute: 0), // optional
                    sunset: TimeOfDay(hour: 18, minute: 0), // optional
                    duskSpanInMinutes: 120,
                    onChange: onEndTimeChanged));
              },
            ),
            Spacer(),
            CustomElevatedButton(
              onPressed: () {},
              child: '저장',
            ),
          ],
        ),
      ),
    );
  }
}
