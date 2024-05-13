import 'package:flutter/material.dart';
import 'package:icecream/child/models/timeset_model.dart';
import 'package:icecream/child/service/timeset_service.dart';
import 'package:icecream/provider/user_provider.dart';
import 'package:provider/provider.dart';

class ChildTimeSet extends StatefulWidget {
  const ChildTimeSet({super.key});

  @override
  _ChildTimeSetState createState() => _ChildTimeSetState();
}

class _ChildTimeSetState extends State<ChildTimeSet> {
  final TimeSetService _timeSetService = TimeSetService();
  late Future<List<Data>> _timeSetData;
  late UserProvider _userProvider;

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _timeSetData = _timeSetService.fetchTimeSets(_userProvider.loginId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 40),
          Expanded(
            child: FutureBuilder<List<Data>>(
              future: _timeSetData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
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
                              return SizedBox(
                                height: 120,
                                child: Card(
                                  margin: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 60,
                                        alignment: Alignment.center,
                                        child:
                                            const Icon(Icons.school, size: 32),
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
                                                    data.name ?? '이름 없음',
                                                    style: const TextStyle(
                                                        fontSize: 14),
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    children: _daysOfWeek(
                                                        data.day ?? '0000000'),
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                const SizedBox(width: 20)
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                const SizedBox(width: 10),
                                                Text(
                                                  '${data.startTime ?? '시작 시간 없음'} ~ ${data.endTime ?? '종료 시간 없음'}',
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
                  } else {
                    return const Center(
                      child: Text(
                        '저장된 목적지가 없습니다.',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    );
                  }
                } else if (snapshot.hasError) {
                  return Text('에러: ${snapshot.error}');
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
    for (int i = 0; i < 7; i++) {
      spans.add(TextSpan(
        text: '${dayNames[i]}${days[i] == '1' ? '' : ' '}',
        style: TextStyle(color: days[i] == '1' ? Colors.blue : Colors.grey),
      ));
    }
    return spans;
  }
}
