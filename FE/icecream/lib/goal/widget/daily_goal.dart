import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:icecream/goal/model/goal_model.dart';

class DailyGoalPage extends StatelessWidget {
  final DailyGoal dailyGoal;

  const DailyGoalPage({super.key, required this.dailyGoal});

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
            child: DailyGoalWidget(dailyGoal: dailyGoal),
          ),
        ],
      ),
    );
  }
}

class DailyGoalWidget extends StatefulWidget {
  final DailyGoal dailyGoal;

  const DailyGoalWidget({super.key, required this.dailyGoal});

  @override
  _DailyGoalWidgetState createState() => _DailyGoalWidgetState();
}

class _DailyGoalWidgetState extends State<DailyGoalWidget> {
  @override
  Widget build(BuildContext context) {
    Map<String, bool?> fullResult = extendDateRange(widget.dailyGoal.result);
    List<String> dates = fullResult.keys.toList();
    dates.sort();

    String todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
    DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
    DateTime endDate = DateTime.now().add(const Duration(days: 1));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: endDate.difference(startDate).inDays,
            itemBuilder: (context, index) {
              DateTime date = startDate.add(Duration(days: index));
              String dateStr = DateFormat('yyyy-MM-dd').format(date);
              bool? isSuccess = fullResult[dateStr];
              bool isToday = dateStr == todayStr;

              return DailyDateCircle(
                date: date,
                isSuccess: isSuccess,
                isToday: isToday,
              );
            },
          ),
        ),
      ],
    );
  }

  Map<String, bool?> extendDateRange(Map<String, bool> originalResults) {
    DateTime minDate =
        DateFormat('yyyy-MM-dd').parse(originalResults.keys.reduce(min));
    DateTime maxDate =
        DateFormat('yyyy-MM-dd').parse(originalResults.keys.reduce(max));
    Map<String, bool?> extendedResults = {};

    for (DateTime date = minDate;
        date.isBefore(maxDate.add(const Duration(days: 1)));
        date = date.add(const Duration(days: 1))) {
      String key = DateFormat('yyyy-MM-dd').format(date);
      extendedResults[key] = originalResults[key];
    }

    return extendedResults;
  }

  String min(String a, String b) => a.compareTo(b) < 0 ? a : b;
  String max(String a, String b) => a.compareTo(b) > 0 ? a : b;
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
    bool successStatus = isSuccess ?? false; // null인 경우 false를 기본값으로 사용합니다.

    return Center(
      child: CustomPaint(
        painter: CircleLinePainter(
          isToday: isToday,
          isSuccess: successStatus,
          isUndefined: isSuccess == null,
          circleRadius: 45.0,
          lineHeight: 48.0,
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
      ..color = Colors.grey
      ..strokeWidth = 2;

    canvas.drawLine(Offset(size.width / 2, 0),
        Offset(size.width / 2, lineHeight / 2), paint);
    canvas.drawLine(Offset(size.width / 2, circleRadius * 2),
        Offset(size.width / 2, size.height), paint);

    if (isUndefined) {
      final outlinePaint = Paint()
        ..color = isToday ? Colors.black : Colors.grey
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
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
        oldDelegate.lineHeight != lineHeight;
  }
}
