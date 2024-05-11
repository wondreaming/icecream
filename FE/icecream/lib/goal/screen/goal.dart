import 'package:flutter/material.dart';
import 'package:icecream/com/widget/default_layout.dart';
import 'package:icecream/goal/model/goal_model.dart';
import 'package:icecream/goal/widget/create_reward_modal.dart';
import 'package:icecream/goal/widget/daily_goal.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:icecream/goal/widget/reward_modal.dart';
import 'package:icecream/auth/service/user_service.dart'; // UserService를 사용하기 위해 import
import 'package:icecream/goal/service/goal_service.dart'; // GoalService를 사용하기 위해 import

class Goal extends StatefulWidget {
  const Goal({super.key});

  @override
  _GoalState createState() => _GoalState();
}

class _GoalState extends State<Goal> {
  String selectedChild = '';
  String selectedChildId = ''; // Store the selected child's ID
  List<Map<String, dynamic>> childrenData = []; // Store children data with ID
  List<String> childrenItems = [];
  bool dataAvailable = false;
  List<dynamic> goalData = [];
  GoalService goalService = GoalService();

  @override
  void initState() {
    super.initState();
    loadChildData(); // 위젯 초기화 시 자녀 데이터 로드
  }

  // 자녀 데이터 로드
  Future<void> loadChildData() async {
    UserService userService = UserService(); // UserService 인스턴스 생성
    try {
      childrenData = await userService.getChildData(); // 자녀 데이터 가져오기
      if (childrenData.isNotEmpty) {
        setState(() {
          childrenItems =
              childrenData.map((child) => child['username'] as String).toList();
          selectedChild = childrenItems.first;
          selectedChildId =
              childrenData.first['user_id'].toString(); // 초기 ID 설정
          fetchGoals();
          debugPrint('선택된 child ID: $selectedChildId'); // 초기 선택된 ID 출력
        });
      } else {
        debugPrint('Loaded children data: $childrenData');
      }
    } catch (e) {
      debugPrint('Error loading children data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      padding: EdgeInsets.zero,
      title: '부모 리워드',
      child: Column(
        children: [
          const SizedBox(height: 25),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: DropdownButtonFormField2(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    isExpanded: true,
                    hint: const Text('자녀', style: TextStyle(fontSize: 14)),
                    value: selectedChild,
                    items: childrenItems
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(item,
                                  style: const TextStyle(fontSize: 14)),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedChild = value as String;
                        selectedChildId = childrenData
                            .firstWhere(
                                (child) => child['username'] == value)['id']
                            .toString();
                        fetchGoals();
                        debugPrint('선택된 child ID: $selectedChildId');
                      });
                    },
                    buttonStyleData: const ButtonStyleData(
                        padding: EdgeInsets.only(right: 8)),
                    iconStyleData: const IconStyleData(
                      icon: Icon(Icons.arrow_drop_down,
                          color: Colors.black45, size: 30),
                    ),
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                        padding: EdgeInsets.symmetric(horizontal: 16)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Expanded(
            child: dataAvailable && goalData.isNotEmpty
                ? buildGoalsList()
                : buildEmptyGoals(),
          ),
        ],
      ),
    );
  }

  Widget buildGoalsList() {
    return ListView.builder(
      itemCount: goalData.length,
      itemBuilder: (context, index) {
        var goal = goalData[index];
        // goal['result']가 null이 아닐 때만 map 함수를 호출
        Map<String, bool> results = goal['result'] != null
            ? (goal['result'] as Map).map<String, bool>(
                (key, value) => MapEntry(key as String, value as bool))
            : {};

        DailyGoal dailyGoal = DailyGoal(
          period: goal['period'] as int,
          record: goal['record'] as int,
          content: goal['content'] as String,
          result: results,
        );
        return DailyGoalPage(dailyGoal: dailyGoal);
      },
    );
  }

  Widget buildEmptyGoals() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "목표가 설정되지 않았습니다.",
            style: TextStyle(fontSize: 20),
          ),
          const Text("자녀의 안전 보행을 위해", style: TextStyle(fontSize: 20)),
          const Text("보행 목표를 설정해주세요!", style: TextStyle(fontSize: 20)),
          const SizedBox(
            height: 10,
          ),
          IconButton(
            icon: const Icon(
              Icons.add_circle_outline_sharp,
            ),
            iconSize: 35,
            onPressed: () {
              // 플러스 버튼 클릭 시 새 목표 추가 로직
              _openRewardModal();
            },
          ),
          const SizedBox(
            height: 100,
          )
        ],
      ),
    );
  }

  void _openRewardModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddRewardModal(
            userId: selectedChildId,
            onSaved: () {
              fetchGoals(); // 목표 데이터 다시 불러오기
            });
      },
    );
  }

  Future<void> fetchGoals() async {
    try {
      var result = await goalService.fetchGoals(selectedChildId);
      if (result['status'] == 200 && result['data'].isNotEmpty) {
        setState(() {
          goalData = result['data'];
          dataAvailable = true;
        });
      } else {
        setState(() {
          dataAvailable = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching goals: $e');
      setState(() {
        dataAvailable = false;
      });
    }
  }
}
