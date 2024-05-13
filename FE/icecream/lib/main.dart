import 'dart:io';
import 'dart:typed_data';
import 'package:android_id/android_id.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:icecream/auth/service/user_service.dart';
import 'package:icecream/home/screen/c_home.dart';
import 'package:icecream/home/screen/p_home.dart';
import 'package:icecream/setting/provider/destination_provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:icecream/com/router/router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:icecream/provider/user_provider.dart';
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

// 알림 채널 high_importance_channel
const AndroidNotificationChannel highImportanceChannel =
    AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  importance: Importance.high,
);

// FCM Background 핸들러
// 백그라운드에서 FCM 메시지를 처리하는 핸들러
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(FilePathAndroidBitmap(filePath),
            largeIcon:
                const DrawableResourceAndroidBitmap('mipmap/ic_launcher'),
            contentTitle: title,
            summaryText: body,
            htmlFormatContent: true,
            htmlFormatContentTitle: true,
            hideExpandedLargeIcon: true);

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
    androidDetails = const AndroidNotificationDetails(
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

// 디바이스 ID를 가져오고 이를 서버로 전송하는 함수
Future<void> checkDeviceWithServerUsingDio() async {
  const androidIdPlugin = AndroidId();
  final String? deviceId = await androidIdPlugin.getId();
  await FlutterSecureStorage().write(key: "deviceId", value: deviceId!);
  debugPrint("android ID: $deviceId");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await checkDeviceWithServerUsingDio();

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final fcmToken = await firebaseMessaging.getToken();
  await FlutterSecureStorage().write(key: "fcmToken", value: fcmToken!);
  debugPrint('FCM Token: $fcmToken');

  // 알림 초기화 설정
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  // 알림 초기화 및 대응 함수 설정
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: handleNotificationResponse,
  );

  // high_importance_channel 생성
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(highImportanceChannel);

  // 알림 권한 요청
  NotificationSettings settings = await firebaseMessaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    provisional: false,
  );
  debugPrint('User granted permission: ${settings.authorizationStatus}');

  // 포어그라운드 메시지 처리
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    await _handleNotification(message);
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Destination()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: MyApp(),
    ),
  );
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
  final UserService _userService = UserService();
  final LocationService _locationService = LocationService();
  final RabbitMQService _rabbitMQService = RabbitMQService();
  late StreamSubscription<Position> _locationSubscription;
  late Future<void> _autoLoginFuture;

  @override
  void initState() {
    super.initState();
    _autoLoginFuture = _autoLogin();
    initServices();
  }

  Future<void> initServices() async {
    await _locationService.initLocationService();
    await _rabbitMQService.initRabbitMQ();
    _locationSubscription =
        _locationService.getLocationStream().listen((position) {
      _rabbitMQService.sendLocation(
          position.latitude, position.longitude, 5, 1);
      // _rabbitMQService.sendLocation(3, 3, 20);
    });
  }

  @override
  void dispose() {
    _locationSubscription.cancel();
    super.dispose();
  }

  // 자동 로그인
  Future<void> _autoLogin() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      await _userService.autoLogin(userProvider);
    } catch (e) {
      debugPrint('Auto-login failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _autoLoginFuture,
      builder: (context, snapshot) {
        return MaterialApp.router(
          routerConfig: router,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
