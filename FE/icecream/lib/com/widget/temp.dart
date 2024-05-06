import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class Temp extends StatefulWidget {
  const Temp({super.key});

  @override
  _TempState createState() => _TempState();
}

class _TempState extends State<Temp> {
  @override
  void initState() {
    super.initState();
    _loadAndShowToken();
  }

  Future<void> _loadAndShowToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('fcmToken');
    if (token != null) {
      _showTokenDialog(token);
    }
  }

  void _showTokenDialog(String token) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('FCM Token'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Token: $token'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Copy'),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: token));
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Token copied to clipboard"),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ElevatedButton(
            onPressed: () {
              context.go('/parents');
            },
            child: const Text('부모 페이지'),
          ),
          ElevatedButton(
            onPressed: () {
              context.go('/child');
            },
            child: const Text('자식 페이지'),
          ),
          ElevatedButton(
            onPressed: () {
              context.go('/parents/setting');
            },
            child: const Text('부모 설정 페이지'),
          ),
          ElevatedButton(
            onPressed: () {
              context.go('/c_qrcode');
            },
            child: const Text('QRcode 생성페이지'),
          ),
          ElevatedButton(
            onPressed: () {
              context.go('/qrscan_page');
            },
            child: const Text('QRcode 스캔페이지'),
          ),
        ],
      ),
    );
  }
}
