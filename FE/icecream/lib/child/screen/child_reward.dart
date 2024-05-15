import 'package:flutter/material.dart';
import 'package:icecream/child/widget/history_modal.dart';
import 'package:icecream/child/widget/reward_modal.dart';
import 'package:icecream/child/widget/child_daily_goal.dart';
import 'package:icecream/goal/model/goal_model.dart';
import 'package:icecream/child/service/goal_service.dart';
import 'package:icecream/provider/user_provider.dart';
import 'package:provider/provider.dart';

class ChildReward extends StatelessWidget {
  ChildReward({super.key});

  final GoalService _goalService = GoalService(); // 수정된 부분: 매개변수 없이 인스턴스 생성

  void showHistoryModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const HistoryModal();
      },
      barrierDismissible: true,
    );
  }

  void showRewardModal(BuildContext context) async {
    try {
      final userId = Provider.of<UserProvider>(context, listen: false).userId; // userId를 가져옵니다.
      final goalData = await _goalService.fetchGoal(userId.toString()); // 서버에서 목표 데이터를 받아옵니다.
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return RewardModal(goalData: goalData);
        },
        barrierDismissible: true,
      );
    } catch (e) {
      print('Error in showing reward modal: $e');
    }
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

    return FutureBuilder<Map<String, dynamic>>(
      future: _goalService.fetchGoal(
          Provider.of<UserProvider>(context, listen: false).userId.toString()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('No data'));
        } else {
          final goalData = snapshot.data!;
          final currentStreak = goalData['record'];

          return Center(
            child: Column(
              children: [
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: RichText(
                    text: TextSpan(
                      text: '현재 ',
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                          text: '$currentStreak일째',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: ' 안전 보행 중입니다.'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const Divider(thickness: 1, height: 1, color: Colors.grey),
                SizedBox(
                    height: maxHeight,
                    child: ChildDailyGoal(dailyGoal: dailyGoal)),
                const Divider(thickness: 1, height: 1, color: Colors.grey),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: OutlinedButton(
                    onPressed: () => showRewardModal(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Theme.of(context).primaryColor),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text('보상 보기',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor)),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
