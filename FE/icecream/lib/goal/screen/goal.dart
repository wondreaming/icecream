import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:icecream/provider/user_provider.dart';
import 'package:icecream/com/widget/default_layout.dart';
import 'package:icecream/goal/model/goal_model.dart';
import 'package:icecream/goal/widget/create_reward_modal.dart';
import 'package:icecream/goal/widget/daily_goal.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:icecream/goal/widget/reward_modal.dart';
import 'package:icecream/goal/service/goal_service.dart';

class Goal extends StatefulWidget {
  const Goal({super.key});

  @override
  _GoalState createState() => _GoalState();
}

class _GoalState extends State<Goal> {
  String selectedChild = '';
  String selectedChildId = '';
  List<Child> childrenData = [];
  List<String> childrenItems = [];
  bool dataAvailable = false;
  List<dynamic> goalData = [];
  GoalService goalService = GoalService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadChildData();
    });
  }

  void loadChildData() {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    if (userProvider.children.isNotEmpty) {
      childrenData = userProvider.children;
      updateChildSelection(childrenData.first);
    }
  }

  void updateChildSelection(Child child) {
    setState(() {
      selectedChild = child.username;
      selectedChildId = child.userId.toString();
      childrenItems = childrenData.map((child) => child.username).toList();
      fetchGoals();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      padding: EdgeInsets.zero,
      title: '부모 리워드',
      child: Column(
        children: [
          const SizedBox(height: 25),
          buildChildDropdown(),
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

  Widget buildChildDropdown() {
    return Row(
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
                        child: Text(item, style: const TextStyle(fontSize: 14)),
                      ))
                  .toList(),
              onChanged: (value) {
                Child selected =
                    childrenData.firstWhere((child) => child.username == value);
                updateChildSelection(selected);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget buildGoalsList() {
    return ListView.builder(
      itemCount: goalData.length,
      itemBuilder: (context, index) {
        var goal = goalData[index];
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
              fetchGoals();
            });
      },
    );
  }

  Future<void> fetchGoals() async {
    try {
      var result = await goalService.fetchGoals(selectedChildId);
      setState(() {
        goalData = result['data'];
        dataAvailable = result['status'] == 200 && goalData.isNotEmpty;
      });
    } catch (e) {
      debugPrint('Error fetching goals: $e');
      setState(() => dataAvailable = false);
    }
  }
}
