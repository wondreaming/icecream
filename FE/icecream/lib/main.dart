import 'dart:io';
import 'dart:typed_data';
import 'package:android_id/android_id.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'firebase_options.dart';
import 'package:icecream/com/router/router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as image;

// gps
import 'package:geolocator/geolocator.dart'; // 임포트 추가
import 'package:icecream/gps/location_service.dart';
import 'package:icecream/gps/rabbitmq_service.dart';
import 'dart:async';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// fcm background 핸들러
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  bool isFullScreen = message.data['isFullScreen'] == 'true';
  String channelId =
      isFullScreen ? 'high_importance_channel' : 'regular_channel';

  AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      channelId,
      isFullScreen ? 'High Importance Notifications' : 'Regular Notifications',
      channelDescription:
          'This channel is used for important notifications if full screen.',
      importance: isFullScreen ? Importance.high : Importance.defaultImportance,
      priority: isFullScreen ? Priority.high : Priority.defaultPriority,
      fullScreenIntent: isFullScreen,
      icon: 'mipmap/ic_launcher',
      ticker: 'ticker');

  NotificationDetails notificationDetails =
      NotificationDetails(android: androidDetails);
  await flutterLocalNotificationsPlugin.show(message.hashCode,
      message.data['title'], message.data['body'], notificationDetails);
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
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  // 알림 초기화
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: handleNotificationResponse,
  );

  // Notification App Launch Details 가져오기
  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

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

    // 이미지 파일을 로컬 파일 시스템에 복사
    final byteData = await rootBundle.load('asset/img/overspeed.png');
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/overspeed.png';
    final file = File(filePath);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    // 알림에 사용할 이미지 설정
    final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(
      FilePathAndroidBitmap(filePath),
      largeIcon: DrawableResourceAndroidBitmap('mipmap/ic_launcher'),
      contentTitle: message.data['title'] ?? '긴급 메시지',
      summaryText: message.data['body'] ?? '긴급 상황 발생!',
      htmlFormatContent: true,
      htmlFormatContentTitle: true,
    );

    AndroidNotificationDetails androidDetails;
    // 과속 차량이 있으면 = true, 이외의 알림은 = false
    if (isFullScreen) {
      androidDetails = AndroidNotificationDetails(
        'high_importance_channel', // 채널 ID
        'High Importance Notifications', // 채널 이름
        channelDescription: 'This channel is used for important notifications.',
        styleInformation: bigPictureStyleInformation,
        importance: Importance.high,
        priority: Priority.high,
        fullScreenIntent: true, // 전체 화면 인텐트 활성화
        icon: 'mipmap/ic_launcher',
        ticker: 'ticker',
      );

      // 전체 화면 알림 세부 설정
      NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidDetails);

      // 알림 표시
      await flutterLocalNotificationsPlugin.show(
          message.hashCode,
          message.data['title'] ?? '긴급 메시지', // 타이틀
          message.data['body'] ?? '긴급 상황 발생!', // 본문
          platformChannelSpecifics,
          payload: 'confirm_action');
    } else {
      androidDetails = AndroidNotificationDetails(
          'regular_channel', 'Regular Notifications',
          channelDescription: 'This channel is used for regular notifications.',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: 'mipmap/ic_launcher');

      NotificationDetails notificationDetails =
          NotificationDetails(android: androidDetails);

      await flutterLocalNotificationsPlugin.show(message.hashCode,
          message.data['title'], message.data['body'], notificationDetails,
          payload: 'Notification Payload');
    }

    debugPrint("Received notification title: ${message.data['title']}");
    debugPrint("Received notification body: ${message.data['body']}");
  });

  runApp(const MyApp());
}

void handleNotificationResponse(NotificationResponse response) async {
  if (response.payload != null) {
    debugPrint('Notification action received: ${response.payload}');
    if (response.payload == 'confirm_action') {
      await flutterLocalNotificationsPlugin.cancel(0);
      debugPrint('Confirmed and dismissed notification.');
    }
  }
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
      _rabbitMQService.sendLocation(position.latitude, position.longitude, 1);
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
