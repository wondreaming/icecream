import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:icecream/goal/model/goal_model.dart';

class DailyGoalWidget extends StatelessWidget {
  final DailyGoal dailyGoal;
  final double circleRadius = 45.0;
  final double lineHeight = 48.0; // 원 사이의 선 높이

  const DailyGoalWidget({super.key, required this.dailyGoal});

  @override
  Widget build(BuildContext context) {
    Map<String, bool?> fullResult = extendDateRange(dailyGoal.result);
    List<String> dates = fullResult.keys.toList();
    dates.sort();

    // 오늘 날짜의 인덱스를 구합니다.
    String todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
    int indexOfToday = dates.indexOf(todayStr);

    // 화면에 표시될 날짜의 범위를 1개월로 설정합니다.
    DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
    DateTime endDate = DateTime.now().add(const Duration(days: 1)); // 오늘까지 포함

    return ListView.builder(
      itemCount: endDate.difference(startDate).inDays,
      itemBuilder: (context, index) {
        DateTime date = startDate.add(Duration(days: index));
        String dateStr = DateFormat('yyyy-MM-dd').format(date);
        bool? isSuccess = fullResult[dateStr];
        bool isToday = dateStr == todayStr;

        return Stack(
          alignment: Alignment.topCenter,
          children: [
            CustomPaint(
              size: Size(circleRadius * 2, circleRadius * 2 + lineHeight),
              painter: CircleLinePainter(
                isToday: isToday,
                isSuccess: isSuccess ?? false,
                isUndefined: isSuccess == null,
                circleRadius: circleRadius,
                lineHeight: lineHeight,
              ),
            ),
            Positioned(
              top: lineHeight / 2,
              child: CircleAvatar(
                radius: circleRadius,
                backgroundColor: isSuccess == null
                    ? Colors.white
                    : (isSuccess ? Colors.green : Colors.red),
                child: Text(
                  DateFormat('MM월 dd일').format(date),
                  style: TextStyle(
                    color: isSuccess == null ? Colors.grey : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (index <
                endDate.difference(startDate).inDays -
                    1) // 마지막 원을 제외하고 선을 그립니다.
              Positioned(
                top: circleRadius * 2 + lineHeight,
                child: Container(
                  height: lineHeight,
                  width: 2.0,
                  color: Colors.grey,
                ),
              ),
          ],
        );
      },
    );
  }

  Map<String, bool?> extendDateRange(Map<String, bool> originalResults) {
    DateTime minDate =
        DateFormat('yyyy-MM-dd').parse(originalResults.keys.reduce(min));
    DateTime maxDate =
        DateFormat('yyyy-MM-dd').parse(originalResults.keys.reduce(max));
    Map<String, bool?> extendedResults = {};

    // minDate부터 maxDate까지의 날짜를 포함하는 맵을 생성합니다.
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

class CircleLinePainter extends CustomPainter {
  bool isToday;
  bool isSuccess;
  bool isUndefined;
  double circleRadius;
  double lineHeight;

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

    // 연결선을 그립니다.
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, lineHeight / 2),
      paint,
    );
    canvas.drawLine(
      Offset(size.width / 2, circleRadius * 2),
      Offset(size.width / 2, size.height),
      paint,
    );

    // 원의 테두리를 그립니다.
    if (isUndefined) {
      final outlinePaint = Paint()
        ..color = isToday ? Colors.black : Colors.grey
        ..strokeWidth = 2
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
