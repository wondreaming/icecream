import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:icecream/com/const/color.dart';
import 'package:icecream/com/widget/default_layout.dart';
import 'package:icecream/setting/widget/custom_elevated_button.dart';
import 'package:icecream/setting/widget/custom_modal.dart';
import 'package:icecream/setting/widget/custom_text_container.dart';
import 'package:icecream/setting/widget/day_container.dart';
import 'package:icecream/setting/widget/location_Icons.dart';
import 'package:intl/intl.dart';

class DestinationScreen extends StatefulWidget {
  final int user_id;
  final String? currentAddress;
  const DestinationScreen(
      {super.key, required this.user_id, this.currentAddress});

  @override
  State<DestinationScreen> createState() => _DestinationScreenState();
}

class _DestinationScreenState extends State<DestinationScreen> {
  // 장소 이름
  late String name = '';

  // 장소 이름 입력
  TextEditingController nameController = TextEditingController();

  // 장소 주소 입력
  late String address = '주소를 입력해주세요';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = name;
  }

  // 안심 보행 아이콘 선택
  late int isSelected = 0; // 초기 값

  void toggleIcon(int index) {
    setState(() {
      isSelected = index;
    });
  }

  // 요일 선택
  late List<bool> isClicked = List.filled(7, false); // 요일 선택 전
  final List<String> days = ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];
  // 요일 선택 토글
  void toggleDay(int index) {
    setState(() {
      isClicked[index] = !isClicked[index];
      refresh();
    });
  }

  // 하위 위젯에서 상위 위젯를 위한 콜백 함수
  void refresh() {
    setState(() {
      
    });
  }
  
  // 시간 설정
  Time _startTime = Time(hour: 7, minute: 00);
  Time _endTime = Time(hour: 14, minute: 00);

  // 시간 한국어로 변역
  String formatTime(String time) {
    // Parse the input time string, removing any spaces and ensuring upper case for AM/PM parsing
    DateTime parsedTime =
        DateFormat('hh:mma').parse(time.toUpperCase().replaceAll(' ', ''));

    // Format the DateTime object to the desired format with space before AM/PM
    return DateFormat('hh:mm a').format(parsedTime);
  }

  // 시작 시간 변경
  void onStartTimeChanged(Time newTime) {
    setState(() {
      _startTime = newTime;
      print(_startTime);
      print(_startTime.runtimeType);
    });
  }

  // 종료 시간 변경
  void onEndTimeChanged(Time newTime) {
    setState(() {
      _endTime = newTime;
      print(_endTime);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '안심 보행 설정',
      child: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.only(
          bottom: 20.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 아이콘 설정
            CustomTextContainer(
              text: '아이콘',
              isFrontIcon: false,
              isUnTitle: false,
            ),
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
                    ...locationIcons.map(
                      (locationIcon) => GestureDetector(
                        onTap: () {
                          toggleIcon(locationIcons.indexOf(locationIcon));
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          child: locationIcon,
                          decoration:
                              // 아이콘이 선택됨
                              (isSelected ==
                                      locationIcons.indexOf(locationIcon))
                                  ? BoxDecoration(
                                      border: Border.all(
                                          color: AppColors.custom_black,
                                          width: 4.0),
                                      borderRadius: BorderRadius.circular(24.0))
                                  : null,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

            // 장소 이름 입력
            Column(
              children: [
                CustomTextContainer(
                  text: '장소 이름',
                  isFrontIcon: false,
                  isDetail: true,
                  hintText: '10자 이내로 장소를 입력해주세요',
                  controller: nameController,
                  onChanged: (String value) {
                    setState(() {
                      name = value;
                    });
                  },
                ),
                SizedBox(
                  height: 14.0,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      '${nameController.text.length}/10',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'GmarketSans',
                        color: AppColors.input_text_color,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            CustomTextContainer(
              text: '장소',
              isFrontIcon: false,
              isExplain: true,
              explainText: address,
              onTap: () async {
                context.goNamed('search');
              },
            ),
            SizedBox(
              height: 14.0,
            ),
            // 요일 입력
            CustomTextContainer(
              text: '요일',
              isFrontIcon: false,
              isExplain: true,
              explainText: '매일',
              onTap: () {
                showCustomModal(
                  context,
                  '요일 설정',
                  Column(
                    children: [
                      GestureDetector(
                          onTap: () {
                            // ...isClicked.map((isClicked) => isClicked = 1);
                          },
                          child: SizedBox(height: 16.0)),
                      Row(
                        children: [
                          DayContainer(day: '매일'),
                          ...days
                              .take(3)
                              .map(
                                (day) => GestureDetector(
                                  onTap: () => toggleDay(
                                    days.indexOf(day),
                                  ),
                                  child: DayContainer(
                                    key: ValueKey(
                                        '${day}_${isClicked[days.indexOf(day)]}'),
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
                      Row(
                        children: [
                          ...days
                              .skip(3)
                              .take(4)
                              .map(
                                (day) => GestureDetector(
                                  onTap: () {
                                    toggleDay(
                                      days.indexOf(day),
                                    );
                                    print('index 알아보기 ${days.indexOf(day)}');
                                    print(isClicked);
                                    print(
                                        '부모가 주는 ${isClicked[day.indexOf(day)]}');
                                  },
                                  child: DayContainer(
                                    key: ValueKey(
                                        '${day}_${isClicked[days.indexOf(day)]}'),
                                    day: day,
                                    isClicked: isClicked[day.indexOf(day)],
                                  ),
                                ),
                              )
                              .toList(),
                        ],
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
            SizedBox(
              height: 14.0,
            ),
            CustomTextContainer(
              text: '시작 시간',
              isFrontIcon: false,
              isExplain: true,
              explainText: _startTime.format(context),
              onTap: () {
                Navigator.of(context).push(
                  showPicker(
                      amLabel: '오전',
                      pmLabel: '오후',
                      backgroundColor: AppColors.background_color,
                      accentColor: AppColors.text_color,
                      unselectedColor: AppColors.custom_black,
                      cancelStyle: TextStyle(
                        color: AppColors.text_color,
                        fontFamily: 'GmarketSans',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                      ),
                      okStyle: TextStyle(
                        color: AppColors.text_color,
                        fontFamily: 'GmarketSans',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                      ),
                      cancelText: '취소',
                      okText: '저장',
                      value: _startTime,
                      sunrise: TimeOfDay(hour: 6, minute: 0), // optional
                      sunset: TimeOfDay(hour: 18, minute: 0), // optional
                      duskSpanInMinutes: 120,
                      onChange: onStartTimeChanged),
                );
              },
            ),
            SizedBox(
              height: 14.0,
            ),
            CustomTextContainer(
              text: '종료 시각',
              isFrontIcon: false,
              isExplain: true,
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
