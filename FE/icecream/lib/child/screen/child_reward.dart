import 'package:flutter/material.dart';
import 'package:icecream/child/widget/history_modal.dart';
import 'package:icecream/child/widget/reward_modal.dart';
import 'package:icecream/goal/widget/daily_goal.dart';
import 'package:icecream/goal/model/goal_model.dart';

class ChildReward extends StatelessWidget {
  const ChildReward({super.key});

  void showHistoryModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const HistoryModal();
      },
      barrierDismissible: true,
    );
  }

  void showRewardModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const RewardModal();
      },
      barrierDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height * 0.55;
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
    int currentStreak = 4;

    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
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
          const SizedBox(
            height: 15,
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
              onPressed: () => showRewardModal(context),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Theme.of(context).primaryColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  '보상 보기',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: OutlinedButton(
              onPressed: () => showHistoryModal(context),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Theme.of(context).primaryColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  '기록 보기',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
