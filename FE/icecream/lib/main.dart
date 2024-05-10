import 'dart:io';
import 'dart:typed_data';
import 'package:android_id/android_id.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:icecream/auth/service/user_service.dart';
import 'package:icecream/setting/provider/destination_provider.dart';
import 'package:provider/provider.dart';
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

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

// 알림 채널 high_importance_channel
const AndroidNotificationChannel highImportanceChannel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  importance: Importance.high,
);

// FCM Background 핸들러
// 백그라운드에서 FCM 메시지를 처리하는 핸들러
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final bool isOverSpeed = message.data['isOverSpeed'] == 'true';

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
    largeIcon: const DrawableResourceAndroidBitmap('mipmap/ic_launcher'),
    contentTitle: message.data['title'] ?? '긴급 메시지',
    summaryText: message.data['body'] ?? '긴급 상황 발생!',
    htmlFormatContent: true,
    htmlFormatContentTitle: true,
  );

  AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      isOverSpeed ? 'high_importance_channel' : 'regular_channel',
      isOverSpeed ? 'High Importance Notifications' : 'Regular Notifications',
      channelDescription: isOverSpeed
          ? 'This channel is used for important notifications.'
          : 'This channel is used for regular notifications.',
      styleInformation: bigPictureStyleInformation,
      importance: isOverSpeed ? Importance.high : Importance.defaultImportance,
      priority: isOverSpeed ? Priority.high : Priority.defaultPriority,
      fullScreenIntent: isOverSpeed,
      icon: 'mipmap/ic_launcher',
      ticker: 'ticker');

  // 전체 화면 알림 세부 설정
  NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidDetails);
  await flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.data['title'] ?? 'Notification',
      message.data['body'] ?? 'You have a new message!',
      platformChannelSpecifics);
  if (message.data.isNotEmpty) {
    debugPrint("Data message title: ${message.data['title']}");
    debugPrint("Data message body: ${message.data['body']}");
  } else {
    debugPrint("No data available in message.");
  }
  await _handleNotification(message);
}

// FCM 메시지를 처리하고 알림 생성
Future<void> _handleNotification(RemoteMessage message) async {
  final String? content = message.data['content'];
  String? imageAssetPath;
  String? title;
  String? body;
  bool isOverspeed = false;
  Color? notificationColor;

  AndroidNotificationDetails androidDetails;
  NotificationDetails platformChannelSpecifics;

  // content에 따른 알림 설정
  switch (content) {
    case 'overspeed-1':
      imageAssetPath = 'asset/img/overspeed.png';
      title = message.data['title'] ?? 'Overspeed Stage 1';
      body = message.data['body'] ?? 'You are speeding!';
      isOverspeed = true; // overspeed 알림을 식별
      notificationColor = Colors.greenAccent; // overspeed-1 알림 색상
      break;
    case 'overspeed-2':
      imageAssetPath = 'asset/img/overspeed.png';
      title = message.data['title'] ?? 'Overspeed Stage 2';
      body = message.data['body'] ?? 'You are speeding excessively!';
      isOverspeed = true; // overspeed 알림을 식별
      notificationColor = Colors.amberAccent; // overspeed-2 알림 색상
      break;
    case 'overspeed-3':
      imageAssetPath = 'asset/img/overspeed.png';
      title = message.data['title'] ?? 'Overspeed Stage 3';
      body = message.data['body'] ?? 'Extreme overspeed detected!';
      isOverspeed = true; // overspeed 알림을 식별
      notificationColor = Colors.redAccent; // overspeed-3 알림 색상
      break;
    case 'created':
      title = message.data['title'] ?? '알림';
      body = message.data['body'] ?? '등록되었습니다!';
      break;
    case 'arrival':
      title = message.data['title'] ?? '알림';
      body = message.data['body'] ?? '도착했습니다!';
      break;
    case 'goal':
      title = message.data['title'] ?? '알림';
      body = message.data['body'] ?? '목표를 달성했습니다!';
      break;
    default:
      debugPrint('Unknown content type: $content');
      return;
  }

  // overspeed 알림일 때만 이미지 로드 및 BigPictureStyle 설정
  if (isOverspeed && imageAssetPath != null) {
    final byteData = await rootBundle.load(imageAssetPath);
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/${imageAssetPath.split('/').last}';
    final file = File(filePath);
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(filePath),
      largeIcon: DrawableResourceAndroidBitmap('mipmap/ic_launcher'),
      contentTitle: title,
      summaryText: body,
      htmlFormatContent: true,
      htmlFormatContentTitle: true,
      hideExpandedLargeIcon: true
    );

    // overspeed 알림일 때만 fullScreenIntent를 true로 설정
    androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      styleInformation: bigPictureStyleInformation,
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: true,
      icon: 'mipmap/ic_launcher',
      color: notificationColor,
      colorized: true,
    );
  } else {
    // overspeed 이외의 알림일 때 fullScreenIntent를 false로 설정
    androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: false,
      icon: 'mipmap/ic_launcher',
    );
  }

  platformChannelSpecifics = NotificationDetails(android: androidDetails);

  // 알림을 표시
  await flutterLocalNotificationsPlugin.show(
    message.hashCode,
    title,
    body,
    platformChannelSpecifics,
    payload: content,
  );
}

// sharedpreferences에 문자열을 저장하는 함수
Future<void> saveToDevicePrefs(String key, String value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

// sharedpreferences에서 문자열을 읽어오는 함수
Future<String?> readFromDevicePrefs(String key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

// 디바이스 ID를 가져오고 이를 서버로 전송하는 함수
Future<void> checkDeviceWithServerUsingDio() async {
  const androidIdPlugin = AndroidId();
  final String? deviceId = await androidIdPlugin.getId();
  // 디바이스 ID를 sharedPreferences에 저장
  await saveToDevicePrefs("deviceId", deviceId!);
  debugPrint("android ID: $deviceId");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await checkDeviceWithServerUsingDio();

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final fcmToken = await firebaseMessaging.getToken();
  await saveToDevicePrefs("fcmToken", fcmToken!);
  debugPrint('FCM Token: $fcmToken');

  // 알림 초기화 설정
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('mipmap/ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

  // 알림 초기화 및 대응 함수 설정
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: handleNotificationResponse,
  );

  // high_importance_channel 생성
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(highImportanceChannel);

  // 알림 권한 요청
  NotificationSettings settings = await firebaseMessaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    provisional: false,
  );
  debugPrint('User granted permission: ${settings.authorizationStatus}');

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
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
    bool isOverSpeed = message.data['isOverSpeed'] == 'true';

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
      largeIcon: const DrawableResourceAndroidBitmap('mipmap/ic_launcher'),
      contentTitle: message.data['title'] ?? '긴급 메시지',
      summaryText: message.data['body'] ?? '긴급 상황 발생!',
      htmlFormatContent: true,
      htmlFormatContentTitle: true,
    );

    AndroidNotificationDetails androidDetails;
    // 과속 차량이 있으면 = true, 이외의 알림은 = false
    if (isOverSpeed) {
      androidDetails = AndroidNotificationDetails(
        'high_importance_channel', // 채널 ID
        'High Importance Notifications', // 채널 이름
        channelDescription: 'This channel is used for important notifications.',
        styleInformation: bigPictureStyleInformation,
        importance: Importance.max,
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
      androidDetails = const AndroidNotificationDetails(
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

  // 포어그라운드 메시지 처리
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    await _handleNotification(message);
  });

  UserService userService = UserService();
  await userService.autoLogin();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => Destination())
  ], child: MyApp(),),);
}

// 알림 응답을 처리
void handleNotificationResponse(NotificationResponse response) async {
  if (response.payload != null) {
    debugPrint('Notification action received: ${response.payload}');
    switch (response.payload) {
      case 'overspeed-1':
      case 'overspeed-2':
      case 'overspeed-3':
        // Handle overspeed notification
        break;
      case 'created':
        // runApp(MyApp(initialRoute: '/c_home'));
        break;
      case 'arrival':
        // runApp(MyApp(initialRoute: '/noti'));
        break;
      case 'goal':
        // runApp(MyApp(initialRoute: '/goal'));
        break;
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
      _rabbitMQService.sendLocation(
          position.latitude, position.longitude, 9696, 1);
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
