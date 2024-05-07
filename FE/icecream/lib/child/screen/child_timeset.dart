import 'package:flutter/material.dart';
import 'package:icecream/child/models/timeset_model.dart';

class ChildTimeSet extends StatelessWidget {
  final List<Data> timeSetData = [
    Data(
      destinationId: 1,
      name: "학교",
      icon: "school",
      latitude: 0,
      longitude: 0,
      startTime: "08:10",
      endTime: "08:40",
      day: "1010101",
    ),
    Data(
      destinationId: 1,
      name: "학원",
      icon: "school",
      latitude: 0,
      longitude: 0,
      startTime: "08:10",
      endTime: "08:40",
      day: "0000011",
    ),
    Data(
      destinationId: 1,
      name: "집",
      icon: "school",
      latitude: 0,
      longitude: 0,
      startTime: "08:10",
      endTime: "08:40",
      day: "1111100",
    ),
  ];

  ChildTimeSet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 40),
          const Text(
            '위치 정보가 전송되는 시간입니다.',
            style: TextStyle(fontSize: 18),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 20),
              itemCount: timeSetData.length,
              itemBuilder: (context, index) {
                final data = timeSetData[index];
                return SizedBox(
                  height: 120,
                  child: Card(
                    margin: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          width: 60, // Reduced width
                          alignment: Alignment.center,
                          child: Icon(_getIconForName(data.icon),
                              size: 32), // Increased icon size
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      data.name ?? '장소 없음',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: _daysOfWeek(data.day),
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    '${data.startTime} ~ ${data.endTime}',
                                    style: const TextStyle(fontSize: 32),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForName(String? iconName) {
    // Adjust this method to handle different icons based on iconName.
    return Icons.school;
  }

  List<TextSpan> _daysOfWeek(String? days) {
    List<TextSpan> spans = [];
    if (days == null || days.length != 7) {
      spans.add(
        const TextSpan(text: '일정 없음', style: TextStyle(color: Colors.grey)),
      );
    } else {
      final dayNames = ['월', '화', '수', '목', '금', '토', '일'];
      for (int i = 0; i < 7; i++) {
        if (days[i] == '1') {
          spans.add(TextSpan(
            text: '${dayNames[i]} ',
            style: const TextStyle(color: Colors.blue),
          ));
        } else {
          spans.add(TextSpan(
            text: '${dayNames[i]} ',
            style: const TextStyle(color: Colors.grey),
          ));
        }
      }
    }
    return spans;
  }
}
