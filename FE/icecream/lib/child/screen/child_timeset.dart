import 'package:flutter/material.dart';
import 'package:icecream/child/models/timeset_model.dart';

class ChildTimeSet extends StatelessWidget {
  final List<Data> timeSetData = [
    // 임의의 시간 설정 데이터
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
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(5, 30, 5, 20),
        itemCount: timeSetData.length,
        itemBuilder: (context, index) {
          final data = timeSetData[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Icon(_getIconForName(data.icon)),
              title: Text(
                data.name ?? '장소 없음',
                style: const TextStyle(fontSize: 14),
              ),
              subtitle: Text(
                '${data.startTime} ~ ${data.endTime}',
                style: const TextStyle(fontSize: 20),
              ),
              trailing: _daysOfWeek(data.day),
            ),
          );
        },
      ),
    );
  }

  IconData _getIconForName(String? iconName) {
    // iconName에 따라 다른 아이콘을 반환하도록 확장할 수 있습니다.
    return Icons.school;
  }

  Widget _daysOfWeek(String? days) {
    // TextSpan 리스트를 초기화합니다.
    List<TextSpan> spans = [];

    if (days == null || days.length != 7) {
      spans.add(
          const TextSpan(text: '일정 없음', style: TextStyle(color: Colors.grey)));
    } else {
      final dayNames = ['월', '화', '수', '목', '금', '토', '일'];
      for (int i = 0; i < 7; i++) {
        if (days[i] == '1') {
          spans.add(TextSpan(
              text: '${dayNames[i]} ',
              style: const TextStyle(color: Colors.blue)));
        } else {
          spans.add(TextSpan(
              text: '${dayNames[i]} ',
              style: const TextStyle(color: Colors.grey)));
        }
      }
    }
    // RichText 위젯을 반환합니다.
    return RichText(
      text: TextSpan(
        children: spans,
        style: const TextStyle(fontSize: 16, color: Colors.black), // 기본 스타일
      ),
    );
  }
}
