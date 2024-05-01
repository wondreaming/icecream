import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:icecreamcctv/common/default_layout.dart';
import 'package:icecreamcctv/main.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class WebsocketScreen extends StatefulWidget {
  const WebsocketScreen({super.key});

  @override
  State<WebsocketScreen> createState() => _WebsocketScreenState();
}

class _WebsocketScreenState extends State<WebsocketScreen> with WidgetsBindingObserver {
  // 웹 소캣 연결
  late IO.Socket socket;

  // 카메라 controller
  late CameraController controller;
  bool isTaking = false; // 촬영 유무
  Timer? timer; // 동영상 찍는 시간

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    // 로드 할때, 소켓, 카메라 실행
    initSocket();
    initCamera();
  }

  // socket 최초 렌더링 때, 함수
  void initSocket() {
    String url = dotenv.get('url'); // socket 연결하는 url
    socket = IO.io(
      url,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    // 서버에 수동 소캣 연결
    socket.connect();

    // 서버에 성공적 연결되면 트리거되는 이벤트 핸들러
    socket.onConnect((_) {
      print('웹소캣과 연결되었습니다');
    });

    // error 받는 리스너
    socket.on('error', (data) {
      print('Error ${data}');
    });

    // disconnect
    socket.onDisconnect((data) => print('웹소캣 연결이 종료되었습니다.'));
  }

  // cctv 이미지 방출
  void sendCCTVImage(String payload) {
    Map<String, dynamic> CCTVImage = {
      'CCTVImage': payload,
      'width' : 0,
      'height' : 0,
    };
    socket.emit('sendCCTVImage', CCTVImage);
  }

  // 카메라 최초 렌더링 때, 함수
  void initCamera() {
    // 뒷면 카메라 실행, 화질 medium 설정
    controller = CameraController(cameras[0], ResolutionPreset.medium); //
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      print(e);
    });
  }

  // 시작하면, websocket으로 이미지 계속 보냄
  void startTakingPictures() async {
    if (timer == null || !timer!.isActive) {
      _takePicturePeriodically();
    }
  }

  void _takePicturePeriodically() async {
    try {
      final image = await controller.takePicture();
      String bytes = await getFrameBytes(image.path);
      sendCCTVImage(bytes);
      // 다음 이미지 캡처를 스케줄링
      timer = Timer(Duration(milliseconds: (1000 / 30).round()), _takePicturePeriodically);
    } catch (e) {
      print('Error taking picture: $e');
      stopTakingPictures(); // Stop taking pictures if an error occurs
    }
  }

  // 프레임 이미지는 blob로 변환
  Future<String> getFrameBytes(String framePath) async {
    File frameFile = File(framePath);
    Uint8List bytes = await frameFile.readAsBytes();
    final String base64String = base64.encode(bytes);
    return base64String;
  }

  void stopTakingPictures() {
    timer?.cancel();
    setState(() {
      timer = null;
    });
  }

  @override
  void dispose() {
    controller.dispose(); // 카메라 종료
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // 카메라 생명 주기 관리
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (controller != null && controller.value.isInitialized) {
      if (state == AppLifecycleState.paused) {
        controller.stopImageStream();
      } else if (state == AppLifecycleState.resumed) {
        if (!controller.value.isStreamingImages) {
          startTakingPictures();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '웹소캣 연결됨',
      child: (!controller.value.isInitialized)
          ? Container()
          : SingleChildScrollView(
            child: Column(
                children: [
                  CameraPreview(controller),
                  IconButton(
                    onPressed: () async {
                      if (isTaking) {
                        print('동영상 전송 끝');
                        stopTakingPictures();
                        setState(() {
                          isTaking = false;
                        });
                      } else {
                        print('동영상 전송 시작');
                        startTakingPictures();
                        setState(() => isTaking = true);
                      }
                    },
                    icon: Icon(
                      isTaking ? Icons.stop : Icons.play_arrow,
                      size: 50,
                    ),
                  ),
                ],
              ),
          ),
    );
  }
}
