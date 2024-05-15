import 'package:flutter/material.dart';

class RewardModal extends StatelessWidget {
  final Map<String, dynamic> goalData;
  const RewardModal({super.key, required this.goalData});

  @override
  Widget build(BuildContext context) {
    final period = goalData['period'].toString();
    final content = goalData['content'];

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        child: Column(
          children: [
            const SizedBox(height: 30),
            Text(
              '$period일 달성시',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(content),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('닫기', style: TextStyle(color: Colors.blue)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
