import 'package:flutter/material.dart';
import 'package:icecream/child/screen/child_reward.dart';
import 'package:icecream/child/screen/child_timeset.dart';

class CHome extends StatefulWidget {
  const CHome({super.key});

  @override
  _CHomeState createState() => _CHomeState();
}

class _CHomeState extends State<CHome> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('아이스크림_자녀'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: TabBar(
                controller: _tabController,
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: Colors.green,
                ),
                indicatorColor:
                    const Color.fromARGB(0, 255, 255, 255), // 언더라인을 투명하게 설정
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                overlayColor: MaterialStateProperty.all(
                    Colors.transparent), // 탭 탭할 때 잉크 물결 효과 제거
                tabs: const [
                  Tab(text: '교통 안전 지키기'),
                  Tab(text: '저장된 시간 보기'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  const ChildReward(),
                  ChildTimeSet(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
