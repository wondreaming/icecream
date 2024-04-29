import 'package:android_id/android_id.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'firebase_options.dart';
import 'package:icecream/com/router/router.dart';
import 'package:shared_preferences/shared_preferences.dart';

// fcm background 핸들러
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (message.data.isNotEmpty) {
    debugPrint("Data message title: ${message.data['title']}");
    debugPrint("Data message body: ${message.data['body']}");
  } else {
    debugPrint("No data available in message.");
  }
}

// sharedpreferences에 저장
Future<void> saveToDevicePrefs(String key, String value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

// sharedpreferences에서 불러오기
Future<String?> readFromDevicePrefs(String key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

// 디바이스 id 가져오기
Future<void> checkDeviceWithServerUsingDio() async {
  const _androidIdPlugin = AndroidId();
  final String? deviceId = await _androidIdPlugin.getId();
  // 디바이스 id sharedPreferences에 저장
  await saveToDevicePrefs("deviceId", deviceId!);
  debugPrint("android ID: $deviceId");
  // 서버랑 통신해서 존재하는 유저인지 확인
  // var dio = Dio();
  // try {
  //   var response = await dio.post(
  //     'https://yourserver.com/api/auth/device/login',
  //     data: {'device_id': deviceId}
  //   );

  //   if (response.statusCode == 200) {
  //     debugPrint('Device is registered on the server');
  //   } else {
  //     debugPrint('Server responded with status code: ${response.statusCode}');
  //   }
  // } on DioError catch (e) {
  //   debugPrint('Dio error: ${e.response?.data['message'] ?? e.message}');
  // }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // 디바이스id 가져오는 함수 실행
  await checkDeviceWithServerUsingDio();

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final fcmToken = await firebaseMessaging.getToken();
  // fcmToken sharedPreferences에 저장
  await saveToDevicePrefs("fcmToken", fcmToken!);
  debugPrint('FCM Token: $fcmToken');

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  NotificationSettings settings = await firebaseMessaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    provisional: false,
  );
  debugPrint('User granted permission: ${settings.authorizationStatus}');

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Notification Channel 설정
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // 채널 id
    'High Importance Notifications', // 채널 이름
    description: 'This channel is used for important notifications.', // 채널 설명
    importance: Importance.high,
  );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // Foreground 알림 메시지 처리
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    // 풀 스크린 인텐트 여부를 결정하는 플래그
    bool isFullScreen = message.data['isFullScreen'] == 'true';

    AndroidNotificationDetails androidDetails;

    // 알림 세부정보
    if (isFullScreen) {
      androidDetails = const AndroidNotificationDetails(
          'high_importance_channel', 'High Importance Notifications',
          channelDescription:
              'This channel is used for important notifications.',
          importance: Importance.high,
          priority: Priority.high,
          fullScreenIntent: true,
          icon: 'mipmap/ic_launcher',
          ticker: 'ticker');
    } else {
      androidDetails = const AndroidNotificationDetails(
          'regular_channel', 'Regular Notifications',
          channelDescription: 'This channel is used for regular notifications.',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: 'mipmap/ic_launcher');
    }

    NotificationDetails notificationDetails = NotificationDetails(android: androidDetails);

    // 알림 표시
    await flutterLocalNotificationsPlugin.show(
        message.hashCode,
        message.notification?.title,
        message.notification?.body,
        notificationDetails,
        payload: 'Notification Payload');

    // 받은 알림 출력
    debugPrint("Received notification title: ${message.notification?.title}");
    debugPrint("Received notification: ${message.notification?.body}");
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // router 환경설정
      routerConfig: router,
      debugShowCheckedModeBanner: false, // debug 배너 삭제
    );
  }
}
