import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:icecream/goal/model/goal_model.dart';

class ChildDailyGoal extends StatelessWidget {
  final DailyGoal dailyGoal;

  const ChildDailyGoal({super.key, required this.dailyGoal});

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
            child: ChildDailyGoalWidget(dailyGoal: dailyGoal),
          ),
        ],
      ),
    );
  }
}

class ChildDailyGoalWidget extends StatefulWidget {
  final DailyGoal dailyGoal;

  const ChildDailyGoalWidget({super.key, required this.dailyGoal});

  @override
  _ChildDailyGoalWidgetState createState() => _ChildDailyGoalWidgetState();
}

class _ChildDailyGoalWidgetState extends State<ChildDailyGoalWidget> {
  DateTime _currentMonth = DateTime.now();
  final ScrollController _scrollController = ScrollController();
  final List<DateTime> _visibleDates = [];
  late DateTime _today;

  @override
  void initState() {
    super.initState();
    _today = DateTime.now();
    _currentMonth = DateTime(_today.year, _today.month);
    _populateDates(_currentMonth);
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToCurrentDate());
  }

  void _scrollListener() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels == 0) {
        DateTime newMonth =
            DateTime(_currentMonth.year, _currentMonth.month - 1);
        _populateDates(newMonth, append: false);
        // Adjust scroll to the end of the newly loaded previous month after setState
        Future.delayed(Duration.zero, () {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        });
      } else if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        DateTime newMonth =
            DateTime(_currentMonth.year, _currentMonth.month + 1);
        _populateDates(newMonth, append: true);
      }
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
    });
  }

  void _scrollToCurrentDate() {
    int index = _visibleDates.indexOf(_today);
    if (index != -1) {
      double position = index * 60.0; // assuming each item height as 60.0
      position -= MediaQuery.of(context).size.height / 2; // Center the date
      _scrollController.jumpTo(position > 0 ? position : 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, bool?> fullResult = extendDateRange(widget.dailyGoal.result);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                _changeMonth(isNext: false);
              },
            ),
            Text(
              DateFormat('MMMM yyyy').format(_currentMonth),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () {
                _changeMonth(isNext: true);
              },
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: _visibleDates.length,
            itemBuilder: (context, index) {
              DateTime date = _visibleDates[index];
              String dateStr = DateFormat('yyyy-MM-dd').format(date);
              bool? isSuccess = fullResult[dateStr];

              return DailyDateCircle(
                date: date,
                isSuccess: isSuccess,
                isToday: date.isAtSameMomentAs(DateTime.now()),
              );
            },
          ),
        ),
      ],
    );
  }

  void _changeMonth({required bool isNext}) {
    DateTime newMonth = isNext
        ? DateTime(_currentMonth.year, _currentMonth.month + 1)
        : DateTime(_currentMonth.year, _currentMonth.month - 1);
    _populateDates(newMonth);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Map<String, bool?> extendDateRange(Map<String, bool> originalResults) {
    Map<String, bool?> extendedResults = {};
    for (DateTime date in _visibleDates) {
      String key = DateFormat('yyyy-MM-dd').format(date);
      extendedResults[key] = originalResults[key];
    }
    return extendedResults;
  }
}

class DailyDateCircle extends StatelessWidget {
  final DateTime date;
  final bool? isSuccess;
  final bool isToday;

  const DailyDateCircle({
    super.key,
    required this.date,
    this.isSuccess,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    bool successStatus = isSuccess ?? false;

    return Center(
      child: CustomPaint(
        painter: CircleLinePainter(
          isToday: isToday,
          isSuccess: successStatus,
          isUndefined: isSuccess == null,
          circleRadius: 45.0,
          lineHeight: 48.0,
          drawBottomLine: true,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: CircleAvatar(
            radius: 45.0,
            backgroundColor: isSuccess == null
                ? Colors.white
                : (successStatus ? Colors.green : Colors.red),
            child: Text(
              DateFormat('MM월 dd일').format(date),
              style: TextStyle(
                color: isSuccess == null ? Colors.grey : Colors.white,
                fontWeight: FontWeight.bold,
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
  final bool drawBottomLine;

  CircleLinePainter({
    required this.isToday,
    required this.isSuccess,
    this.isUndefined = false,
    required this.circleRadius,
    required this.lineHeight,
    this.drawBottomLine = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 이전 구문에서 올바르지 않았던 부분들을 수정했습니다.
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2.0; // strokeWidth를 올바르게 설정

    canvas.drawLine(Offset(size.width / 2, 0),
        Offset(size.width / 2, lineHeight / 2), paint);

    if (drawBottomLine) {
      canvas.drawLine(Offset(size.width / 2, circleRadius * 2 + lineHeight / 2),
          Offset(size.width / 2, size.height), paint);
    }

    if (isUndefined) {
      final outlinePaint = Paint()
        ..color = isToday ? Colors.black : Colors.grey
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke; // style을 올바르게 설정

      canvas.drawCircle(Offset(size.width / 2, lineHeight / 2 + circleRadius),
          circleRadius, outlinePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CircleLinePainter oldDelegate) {
    return oldDelegate.isToday != isToday ||
        oldDelegate.isSuccess != isSuccess ||
        oldDelegate.isUndefined != isUndefined ||
        oldDelegate.circleRadius != circleRadius ||
        oldDelegate.lineHeight != lineHeight ||
        oldDelegate.drawBottomLine != drawBottomLine;
  }
}
