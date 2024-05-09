import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:icecream/com/const/color.dart';
import 'package:icecream/com/const/dio_interceptor.dart';
import 'package:icecream/com/widget/default_layout.dart';
import 'package:icecream/setting/model/add_destination_model.dart';
import 'package:icecream/setting/model/response_destination_model.dart';
import 'package:icecream/setting/provider/destination_provider.dart';
import 'package:icecream/setting/repository/destination_repository.dart';
import 'package:icecream/setting/service/buildDays.dart';
import 'package:icecream/setting/widget/custom_day_picker.dart';
import 'package:icecream/setting/widget/custom_elevated_button.dart';
import 'package:icecream/setting/widget/custom_modal.dart';
import 'package:icecream/setting/widget/custom_show_picker.dart';
import 'package:icecream/setting/widget/custom_text_container.dart';
import 'package:icecream/setting/widget/location_Icons.dart';
import 'package:provider/provider.dart';

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
  late bool isDoneAddress = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = name;
  }

  // 주소 입력 받을 폼
  late String address;
  late double latitude;
  late double longitude;

  // 안심 보행 아이콘 선택
  late int icon; // 서버에 넘겨줄 값
  late int isSelected = 0; // 초기 값

  void toggleIcon(int index) {
    setState(() {
      isSelected = index;
    });
    icon = isSelected;
  }

  // 요일 선택
  late bool isDoneDays = false;
  late List<bool> _dataFromChild;
  late List<String> dayList = List<String>.filled(7, '0');
  late List<bool> dayListFromP = List.filled(7, false);
  late String day = '0000000'; // 서버에게 줄 값
  late String explainDay = '매일';
  final List<String> dayNames = ['월', '화', '수', '목', '금', '토', '일'];
  late List<String> selectedDayNames = [];

  void updateData(List<bool> newData) {
    setState(() {
      _dataFromChild = newData;
    });
  }

  void switchStringFromList() {
    selectedDayNames = [];
    for (int i = 0; i < _dataFromChild.length; i++) {
      if (_dataFromChild[i]) {
        dayListFromP[i] = _dataFromChild[i];
        dayList[i] = '1';
        selectedDayNames.add(dayNames[i]);
      }
    }
    day = dayList.join('');
    setState(() {
      isDoneDays = true;
      if (_dataFromChild.every((element) => element)) {
        explainDay = '매일';
      } else {
        explainDay = selectedDayNames.join(' ');
      }
    });
  }

  // 시간 설정
  late String start_time; // 서버에 넘겨줄 시간 값
  late String end_time;
  Time _startTime = Time(hour: 7, minute: 00);
  Time _endTime = Time(hour: 14, minute: 00);
  late bool isDoneAtStartTime = false; // 시작 시간이 입력되었는 지 확인
  late bool isDoneAtEndTime = false; // 종료 시간이 입력되었는 지 확인
  late String timeError = '';

  // 시작 시간이 종료 시간이 넘지 않는지 검증
  void checkStartTimeAndEndTime(Time _startTime, Time _endTime, String word) {
    // Time 객체를 DateTime 객체로 변환
    DateTime startDateTime =
        DateTime(2024, 5, 7, _startTime.hour, _startTime.minute);
    DateTime endDateTime = DateTime(2024, 5, 7, _endTime.hour, _endTime.minute);

    if (startDateTime.isAfter(endDateTime) ||
        startDateTime.isAtSameMomentAs(endDateTime)) {
      setState(() {
        timeError = '종료 시간이 시작 시간보다 앞섭니다';
      });
      // 모든 프레임이 그려지고 난 뒤에 그려지는 작업
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          if (word == 'end') {
            Navigator.of(context).push(
                CustomShowPicker(value: _endTime, onChange: onEndTimeChanged));
          } else {
            Navigator.of(context).push(CustomShowPicker(
                value: _startTime, onChange: onStartTimeChanged));
          }
        },
      );
    } else {
      setState(() {
        timeError = '';
      });
    }
  }

  // 문자로 출력
  String formatTimeOfDay(TimeOfDay tod) {
    final hour = tod.hour.toString().padLeft(2, '0');
    final minute = tod.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }

  // 시작 시간 변경
  void onStartTimeChanged(Time newTime) {
    setState(() {
      _startTime = newTime;
      isDoneAtStartTime = true;
    });
    checkStartTimeAndEndTime(_startTime, _endTime, 'start');
    String formatStartTime= formatTimeOfDay(_startTime);
    print(formatStartTime);
    start_time = formatStartTime;
  }

  // 종료 시간 변경
  void onEndTimeChanged(Time newTime) {
    setState(() {
      _endTime = newTime;
      isDoneAtEndTime = true;
    });
    checkStartTimeAndEndTime(_startTime, _endTime, 'end');
    String formatEndTime= formatTimeOfDay(_endTime);
    print(formatEndTime);
    end_time = formatEndTime;
  }

  // 안심 보행 목적지 등록
  void addDestination() async {
    final dio = CustomDio().createDio();
    final destinationRepository = DestinationRespository(dio);

    AddDestinationModel newDestination = AddDestinationModel(
        user_id: widget.user_id,
        name: name,
        icon: isSelected,
        latitude: latitude,
        longitude: longitude,
        start_time: start_time,
        end_time: end_time,
        day: day);
    try {
      print(newDestination.user_id);
      print(newDestination.name);
      print(newDestination.icon);
      print(newDestination.latitude);
      print(newDestination.longitude);
      print(newDestination.start_time);
      print(newDestination.end_time);
      print(newDestination.day);
      ResponseDestination response = await destinationRepository.addDestination(
          destination: newDestination);
      print("추가 성공: ${response.toJson()}");
    } catch (e) {
      print(e);
    }
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
            Consumer<Destination>(
              builder: (context, destination, child) {
                if (destination.address != '주소를 입력해주세요') {
                  isDoneAddress = true;
                  address = destination.address;
                  latitude = destination!.latitude;
                  longitude = destination!.longitude;
                  print('$address $latitude $longitude');
                }
                return CustomTextContainer(
                  text: '장소',
                  isFrontIcon: false,
                  isExplain: true,
                  isDone: isDoneAddress,
                  explainText: destination.address,
                  onTap: () async {
                    context.goNamed('search');
                  },
                );
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
              isDone: isDoneDays,
              explainText: explainDay,
              onTap: () {
                showCustomModal(
                  context,
                  '요일 설정',
                  Column(
                    children: [
                      SizedBox(height: 16.0),
                      CustomDayPicker(
                          onDataChanged: updateData, data: dayListFromP),
                      SizedBox(height: 16.0),
                      CustomElevatedButton(
                          onPressed: () {
                            switchStringFromList();
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
              isDone: isDoneAtStartTime,
              onTap: () {
                Navigator.of(context).push(
                  CustomShowPicker(
                      value: _startTime, onChange: onStartTimeChanged),
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
              isDone: isDoneAtEndTime,
              onTap: () {
                Navigator.of(context).push(
                  CustomShowPicker(value: _endTime, onChange: onEndTimeChanged),
                );
              },
            ),
            SizedBox(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  '${timeError}',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'GmarketSans',
                    color: AppColors.input_text_color,
                  ),
                ),
              ),
            ),
            Spacer(),
            CustomElevatedButton(
              onPressed: () {
                addDestination();
                context.pop();
              },
              child: '저장',
            ),
          ],
        ),
      ),
    );
  }
}
