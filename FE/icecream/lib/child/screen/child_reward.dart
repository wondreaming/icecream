import 'package:flutter/material.dart';
import 'package:icecream/child/widget/history_modal.dart';
import 'package:icecream/child/widget/reward_modal.dart';

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
    return Center(
      child: Column(
        children: [
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
