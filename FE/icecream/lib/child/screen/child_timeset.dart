import 'package:flutter/material.dart';
import 'package:icecream/child/models/timeset_model.dart';
import 'package:icecream/child/service/timeset_service.dart';
import 'package:icecream/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:icecream/child/widget/child_location_icon.dart';

class ChildTimeSet extends StatefulWidget {
  const ChildTimeSet({super.key});

  @override
  _ChildTimeSetState createState() => _ChildTimeSetState();
}

class _ChildTimeSetState extends State<ChildTimeSet> {
  final TimeSetService _timeSetService = TimeSetService();
  late Future<List<TimeSet>> _timeSetData;
  late UserProvider _userProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _timeSetData =
        _timeSetService.fetchTimeSets(_userProvider.userId.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 40),
          Expanded(
            child: FutureBuilder<List<TimeSet>>(
              future: _timeSetData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        const Text(
                          '위치 정보가 전송되는 시간입니다.',
                          style: TextStyle(fontSize: 18),
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(5, 5, 5, 20),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final data = snapshot.data![index];
                              // 아이콘의 인덱스가 리스트 범위 내에 있는지 확인
                              Widget iconWidget = data.icon >= 0 &&
                                      data.icon < locationIcons.length
                                  ? locationIcons[data.icon - 1]
                                  : const Icon(Icons.error); // 범위 밖이면 기본 아이콘 사용

                              return SizedBox(
                                height: 120,
                                child: Card(
                                  margin: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 60,
                                        alignment: Alignment.center,
                                        child: iconWidget,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    data.name,
                                                    style: const TextStyle(
                                                        fontSize: 14),
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    children:
                                                        _daysOfWeek(data.day),
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                const SizedBox(width: 20),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                const SizedBox(width: 10),
                                                Text(
                                                  '${data.startTime} ~ ${data.endTime}',
                                                  style: const TextStyle(
                                                      fontSize: 32),
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
                    );
                  } else if (snapshot.hasError) {
                    print('Error: ${snapshot.error}');
                    return Text('에러: ${snapshot.error}');
                  }
                }
                return const CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }

  List<TextSpan> _daysOfWeek(String days) {
    List<TextSpan> spans = [];
    final dayNames = ['월', '화', '수', '목', '금', '토', '일'];

    // TextStyle에 fontFamily를 'monospace'로 설정하여 모든 글자의 너비를 같게 함
    const textStyleRegular =
        TextStyle(color: Colors.grey, fontFamily: 'RobotoMono');
    const textStyleActive =
        TextStyle(color: Colors.blue, fontFamily: 'RobotoMono');

    for (int i = 0; i < 7; i++) {
      spans.add(TextSpan(
        text: dayNames[i] + (i < 6 ? "  " : ""), // 마지막 요일 후에는 공간 추가하지 않음
        style: days[i] == '1' ? textStyleActive : textStyleRegular,
      ));
    }
    return spans;
  }
}
