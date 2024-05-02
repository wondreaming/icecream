import 'package:android_id/android_id.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'firebase_options.dart';
import 'package:icecream/com/router/router.dart';
import 'package:shared_preferences/shared_preferences.dart';

// gps
import 'package:geolocator/geolocator.dart'; // 임포트 추가
import 'package:icecream/gps/location_service.dart';
import 'package:icecream/gps/rabbitmq_service.dart';
import 'dart:async';

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
  const androidIdPlugin = AndroidId();
  final String? deviceId = await androidIdPlugin.getId();
  // 디바이스 id sharedPreferences에 저장
  await saveToDevicePrefs("deviceId", deviceId!);
  debugPrint("android ID: $deviceId");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
        message.hashCode,
        message.notification?.title,
        message.notification?.body,
        notificationDetails,
        payload: 'Notification Payload');

    debugPrint("Received notification title: ${message.notification?.title}");
    debugPrint("Received notification: ${message.notification?.body}");
  });

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final LocationService _locationService = LocationService();
  final RabbitMQService _rabbitMQService = RabbitMQService();
  late StreamSubscription<Position> _locationSubscription;

  @override
  void initState() {
    super.initState();
    initServices();
  }

  Future<void> initServices() async {
    await _locationService.initLocationService();
    await _rabbitMQService.initRabbitMQ();
    _locationSubscription =
        _locationService.getLocationStream().listen((position) {
      _rabbitMQService.sendLocation(position.latitude, position.longitude, 5);
      // _rabbitMQService.sendLocation(3, 3, 20);
    });
  }

  @override
  void dispose() {
    _locationSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
