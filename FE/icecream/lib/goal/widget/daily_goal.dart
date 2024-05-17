import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:icecream/goal/service/p_daily_goal_service.dart';
import 'package:dio/dio.dart';
import 'package:icecream/com/const/dio_interceptor.dart';

class DailyGoalPage extends StatelessWidget {
  final int selectedChildId;

  const DailyGoalPage({super.key, required this.selectedChildId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('asset/img/crosswalk.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Positioned.fill(
            child: PDailyGoalWidget(selectedChildId: selectedChildId),
          ),
        ],
      ),
    );
  }
}

class PDailyGoalWidget extends StatefulWidget {
  final int selectedChildId;

  const PDailyGoalWidget({Key? key, required this.selectedChildId}) : super(key: key);

  @override
  _PDailyGoalWidgetState createState() => _PDailyGoalWidgetState();
}

class _PDailyGoalWidgetState extends State<PDailyGoalWidget> {
  DateTime _currentMonth = DateTime.now();
  final ScrollController _scrollController = ScrollController();
  final List<DateTime> _visibleDates = [];
  late DateTime _today;

  @override
  void initState() {
    super.initState();
    _today = DateTime.now().toLocal(); // 한국 시간대로 변환
    _currentMonth = DateTime(_today.year, _today.month);
    _populateDates(_currentMonth);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 300), _scrollToTodayDate); // 지연 호출
    });
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    // 이 함수가 필요하지 않다면 삭제할 수 있습니다.
  }

  @override
  void didUpdateWidget(PDailyGoalWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedChildId != oldWidget.selectedChildId) {
      _today = DateTime.now().toLocal();  // 한국 시간대로 다시 설정
      _currentMonth = DateTime(_today.year, _today.month); // 현재 달을 업데이트
      _visibleDates.clear(); // 기존에 표시된 날짜들을 클리어
      _populateDates(_currentMonth); // 날짜들을 다시 생성
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration(milliseconds: 300), _scrollToTodayDate); // 지연된 호출로 오늘 날짜로 스크롤
      });
    }
  }


  void _scrollToTodayDate() {
    if (!mounted) return; // 상태가 마운트된 상태에서만 동작

    DateTime todayDate = DateTime(_today.year, _today.month, _today.day);
    int index = _visibleDates.indexWhere((date) => date.isAtSameMomentAs(todayDate));
    if (index != -1) {
      double position = index * 106.7;
      double screenHeight = MediaQuery.of(context).size.height;
      double maxHeight = screenHeight * 0.1;
      position -= maxHeight / 2; // Center the date more accurately
      _scrollController.animateTo(position > 0 ? position : 0, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }

  void _populateDates(DateTime month, {bool append = true}) {
    List<DateTime> newDates = [];
    DateTime startDate = DateTime(month.year, month.month, 1);
    DateTime endDate = DateTime(month.year, month.month + 1, 0);
    for (DateTime date = startDate;
    date.isBefore(endDate.add(const Duration(days: 1)));
    date = date.add(const Duration(days: 1))) {
      newDates.add(date);
    }

    setState(() {
      if (append) {
        _visibleDates.addAll(newDates);
      } else {
        _visibleDates.insertAll(0, newDates);
        _currentMonth = month; // Update the current month
      }
      _today = DateTime.now().toLocal(); // 한국 시간대로 변환
    });
  }

  Map<String, int?> extendDateRange(Map<DateTime, int> originalResults) {
    Map<String, int?> extendedResults = {};
    for (DateTime date in _visibleDates) {
      String key = DateFormat('yyyy-MM-dd').format(date);
      extendedResults[key] = originalResults[date];
    }
    return extendedResults;
  }

  @override
  Widget build(BuildContext context) {
    final CustomDio customDio = CustomDio();
    final DailyGoalService _DailyGoalService = DailyGoalService(customDio.createDio());

    return FutureBuilder<Map<DateTime, int>>(
      future: _DailyGoalService.fetchGoalStatus(widget.selectedChildId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || !snapshot.hasData) {
          // 상태코드가 200이 아닐 경우에도 데이터를 출력하도록 수정
          final goalData = snapshot.data ?? {};
          Map<String, int?> fullResult = extendDateRange(goalData);

          double maxHeight = MediaQuery.of(context).size.height * 0.55;

          return Container(
            height: maxHeight,
            child: Stack(
              children: [
                ListView.builder(
                  padding: EdgeInsets.only(bottom: 25.0),
                  controller: _scrollController,
                  itemCount: _visibleDates.length,
                  itemBuilder: (context, index) {
                    DateTime date = _visibleDates[index];
                    String dateStr = DateFormat('yyyy-MM-dd').format(date);
                    int? status = fullResult[dateStr];

                    return DailyDateCircle(
                      date: date,
                      status: status,
                      isToday: date.isAtSameMomentAs(DateTime.now().toLocal()),
                    );
                  },
                ),
                Positioned(
                  left: 10,
                  top: maxHeight / 2 - 24,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      _changeMonth(isNext: false);
                    },
                  ),
                ),
                Positioned(
                  right: 10,
                  top: maxHeight / 2 - 24,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () {
                      _changeMonth(isNext: true);
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          final goalData = snapshot.data!;
          Map<String, int?> fullResult = extendDateRange(goalData);

          double maxHeight = MediaQuery.of(context).size.height * 0.55;

          return Container(
            height: maxHeight,
            child: Stack(
              children: [
                ListView.builder(
                  padding: EdgeInsets.only(bottom: 25.0),
                  controller: _scrollController,
                  itemCount: _visibleDates.length,
                  itemBuilder: (context, index) {
                    DateTime date = _visibleDates[index];
                    String dateStr = DateFormat('yyyy-MM-dd').format(date);
                    int? status = fullResult[dateStr];

                    return DailyDateCircle(
                      date: date,
                      status: status,
                      isToday: date.isAtSameMomentAs(DateTime.now().toLocal()),
                    );
                  },
                ),
                Positioned(
                  left: 10,
                  top: maxHeight / 2 - 24,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      _changeMonth(isNext: false);
                    },
                  ),
                ),
                Positioned(
                  right: 10,
                  top: maxHeight / 2 - 24,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () {
                      _changeMonth(isNext: true);
                    },
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  void _changeMonth({required bool isNext}) {
    setState(() {
      if (isNext) {
        _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
      } else {
        _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
      }
      _visibleDates.clear();
      _populateDates(_currentMonth);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class DailyDateCircle extends StatelessWidget {
  final DateTime date;
  final int? status;
  final bool isToday;

  const DailyDateCircle({
    Key? key,
    required this.date,
    this.status,
    required this.isToday,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    BoxDecoration boxDecoration;

    switch (status) {
      case 1:
        backgroundColor = Colors.green;
        textColor = Colors.white;
        boxDecoration = BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        );
        break;
      case 0:
        backgroundColor = Colors.white;
        textColor = Colors.grey;
        boxDecoration = BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.green, width: 4.0), // 진하고 굵은 테두리
        );
        break;
      case -1:
        backgroundColor = Colors.red;
        textColor = Colors.white;
        boxDecoration = BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        );
        break;
      default:
        backgroundColor = Colors.white;
        textColor = Colors.grey;
        boxDecoration = BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        );
        break;
    }

    return Center(
      child: CustomPaint(
        painter: CircleLinePainter(
          isToday: isToday,
          isSuccess: status == 1,
          isUndefined: status == null,
          circleRadius: 45.0,
          lineHeight: 48.0, // 모든 요소 밑에 선 추가
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: Container(
            decoration: boxDecoration,
            child: CircleAvatar(
              radius: 45.0,
              backgroundColor: Colors.transparent,
              child: Text(
                DateFormat('MM월 dd일').format(date),
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CircleLinePainter extends CustomPainter {
  final bool isToday;
  final bool isSuccess;
  final bool isUndefined;
  final double circleRadius;
  final double lineHeight;

  CircleLinePainter({
    required this.isToday,
    required this.isSuccess,
    this.isUndefined = false,
    required this.circleRadius,
    required this.lineHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 2.0;

    // 위쪽 수직선
    paint.color = Colors.grey;
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, lineHeight / 2),
      paint,
    );

    // 아래쪽 수직선
    paint.color = Colors.grey;
    canvas.drawLine(
      Offset(size.width / 2, size.height - lineHeight / 2),
      Offset(size.width / 2, size.height * 2),
      paint,
    );

    if (isUndefined) {
      final outlinePaint = Paint()
        ..color = isToday ? Colors.black : Colors.grey
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;

      canvas.drawCircle(
        Offset(size.width / 2, lineHeight / 2 + circleRadius),
        circleRadius,
        outlinePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CircleLinePainter oldDelegate) {
    return oldDelegate.isToday != isToday ||
        oldDelegate.isSuccess != isSuccess ||
        oldDelegate.isUndefined != isUndefined ||
        oldDelegate.circleRadius != circleRadius ||
        oldDelegate.lineHeight != lineHeight;
  }
}
