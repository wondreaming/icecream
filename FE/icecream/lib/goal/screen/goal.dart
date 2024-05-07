import 'package:flutter/material.dart';
import 'package:icecream/com/widget/default_layout.dart';
import 'package:icecream/goal/model/goal_model.dart';
import 'package:icecream/goal/widget/daily_goal.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:icecream/goal/widget/reward_modal.dart';

class Goal extends StatefulWidget {
  const Goal({super.key});

  @override
  _GoalState createState() => _GoalState();
}

class _GoalState extends State<Goal> {
  String selectedChild = '자녀1'; // 기본 선택된 자녀
  final List<String> childrenItems = [
    '자녀1',
    '자녀2',
    '자녀3',
  ]; // 자녀 목록

  @override
  Widget build(BuildContext context) {
    final dailyGoal = DailyGoal(
      period: 7,
      record: 5,
      content: '예시 내용',
      result: {
        '2024-04-01': true,
        '2024-04-02': false,
        '2024-04-03': true,
        '2024-04-04': true,
        '2024-04-05': false,
        '2024-04-06': true,
        '2024-04-07': true,
        '2024-04-08': false,
        '2024-04-09': true,
        '2024-04-10': true,
        '2024-04-11': false,
        '2024-04-12': true,
      },
    );
    double maxHeight = MediaQuery.of(context).size.height * 0.55;
    int currentStreak = 4; // 안전 보행 중인 일수

    return DefaultLayout(
      padding: EdgeInsets.zero,
      title: '부모 리워드',
      child: Column(
        children: [
          const SizedBox(
            height: 25,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: DropdownButtonFormField2(
                    decoration: InputDecoration(
                      // Add more decoration...
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    isExpanded: true,
                    hint: const Text(
                      '자녀 선택',
                      style: TextStyle(fontSize: 14),
                    ),
                    value: selectedChild, // 기본 선택된 자녀
                    items: childrenItems
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedChild = value as String;
                      });
                    },
                    buttonStyleData: const ButtonStyleData(
                      padding: EdgeInsets.only(right: 8),
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black45,
                      ),
                      iconSize: 30,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 25,
          ),

          // 안전 보행 중인 일수 표시
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: RichText(
              text: TextSpan(
                text: '현재 ',
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: '$currentStreak일째',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(text: ' 안전 보행 중입니다.'),
                ],
              ),
            ),
          ),
          const Divider(
            thickness: 1,
            height: 1,
            color: Colors.grey,
            indent: 0,
            endIndent: 0,
          ),
          SizedBox(
            height: maxHeight,
            child: DailyGoalPage(dailyGoal: dailyGoal),
          ),
          const Divider(
            thickness: 1,
            height: 1,
            color: Colors.grey,
            indent: 0,
            endIndent: 0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: OutlinedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const RewardModal();
                  },
                );
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Theme.of(context).primaryColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text('보상 설정',
                    style: TextStyle(color: Theme.of(context).primaryColor)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
