import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:icecream/com/widget/default_layout.dart';

class Noti extends StatelessWidget {
  const Noti({super.key});

  @override
  Widget build(BuildContext context) {
    // 임시 데이터
    List<Map<String, dynamic>> tempData = [
      {"date": "2024-04-29 10:29:24", "content": "오늘 내용"},
      {"date": "2024-04-28 10:29:24", "content": "알림 내용"},
      {"date": "2024-04-28 14:29:24", "content": "어제 내용"},
      {"date": "2024-04-25 10:29:24", "content": "알림 내용"},
      {"date": "2024-04-25 08:29:24", "content": "알림 내용"},
      {"date": "2024-04-25 23:29:24", "content": "알림 내용"},
      {"date": "2024-04-24 23:29:24", "content": "알림 내용"},
      {"date": "2024-04-24 23:29:24", "content": "알림 내용"},
      {"date": "2024-04-23 23:29:24", "content": "알림 내용"},
      {"date": "2024-04-23 23:29:24", "content": "알림 내용"},
      {"date": "2024-04-23 23:29:24", "content": "알림 내용"},
      // 데이터 리스트 계속...
    ];

    // 날짜별로 알림 그룹화
    Map<String, List<Map<String, dynamic>>> groupedData = {};
    for (var element in tempData) {
      DateTime dateTime = DateTime.parse(element['date']);
      String formattedDate = _formatDateString(dateTime);
      groupedData.putIfAbsent(formattedDate, () => []).add(element);
    }

    return DefaultLayout(
      title: '알림',
      child: Column(
        children: [
          Expanded(
            // ListView를 Expanded로 감싸기
            child: ListView(
              shrinkWrap: true, // 컨텐츠의 크기에 맞춰서 ListView의 크기를 조절
              children: groupedData.entries.map<Widget>((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 35,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14.0, 0, 14, 0),
                      child: Text(
                        entry.key,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    ...entry.value.map((data) {
                      DateTime date = DateTime.parse(data['date']);
                      String time = DateFormat('a hh시 mm분')
                          .format(date); // '오전 8시 35분' 형식
                      return Column(
                        children: [
                          ListTile(
                            title: Text(
                              time,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  data['content'],
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: DottedLine(dashColor: Colors.grey),
                          ),
                        ],
                      );
                    }),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(
            height: 90,
          )
        ],
      ),
    );
  }

  String _formatDateString(DateTime dateTime) {
    DateTime now = DateTime.now();
    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return '오늘';
    } else if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day - 1) {
      return '어제';
    } else {
      return DateFormat('MM월 dd일').format(dateTime);
    }
  }
}
