import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:icecream/com/widget/default_layout.dart';
import 'package:icecream/noti/service/notification_service.dart';
import 'package:icecream/noti/models/notification_model.dart';

class Noti extends StatefulWidget {
  const Noti({super.key});

  @override
  _NotiState createState() => _NotiState();
}

class _NotiState extends State<Noti> {
  NotificationModel? _notificationModel;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      NotificationService service = NotificationService();
      NotificationModel model = await service.fetchNotifications();
      setState(() {
        _notificationModel = model;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error fetching data: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '알림',
      child: _isLoading
          ? const CircularProgressIndicator()
          : _buildNotificationList(),
    );
  }

  Widget _buildNotificationList() {
    if (_notificationModel == null || _notificationModel!.data!.isEmpty) {
      return const Text('알람이 없습니다.');
    }

    Map<String, List<NotificationData>> groupedData =
        _groupDataByDate(_notificationModel!.data!);

    return Column(
      children: [
        Expanded(
          child: ListView(
            children: groupedData.entries.map((entry) {
              return _buildDateSection(entry.key, entry.value);
            }).toList(),
          ),
        ),
        const SizedBox(height: 90),
      ],
    );
  }

  Map<String, List<NotificationData>> _groupDataByDate(
      List<NotificationData> data) {
    Map<String, List<NotificationData>> grouped = {};
    for (var element in data) {
      DateTime dateTime = DateTime.parse(element.datetime!);
      String formattedDate = _formatDateString(dateTime);
      grouped.putIfAbsent(formattedDate, () => []).add(element);
    }
    return grouped;
  }

  Widget _buildDateSection(String date, List<NotificationData> notifications) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 14.0),
          child: Text(
            date,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
        ...notifications.map((data) {
          DateTime date = DateTime.parse(data.datetime!);
          String time = DateFormat('a hh시 mm분').format(date);
          return Column(
            children: [
              ListTile(
                title: Text(
                  time,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                subtitle: Text(
                  data.content!,
                  style: const TextStyle(fontSize: 18),
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