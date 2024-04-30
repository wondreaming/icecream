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
  String url = dotenv.get('url');

  // 카메라 controller
  late CameraController controller;
  bool is_recording = false; // 동영상 촬영 유무

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
  void sendCCTVImage(int width, int height, Uint8List payload) {
    Map<String, dynamic> CCTVImage = {
      'CCTVImage': payload,
      'width' : width,
      'height' : height,
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
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print(e.code);
            break;
          default:
            print(e.code);
            break;
        }
      }
    });
  }
  // 카메라에서 YUV 데이터 처리
  void startImageStream () {
    controller.startImageStream((CameraImage image) {
      sendImageOverWebSocket(image);
    });
  }

  // 웹소캣 처리해서 보내기
  void sendImageOverWebSocket(CameraImage image) {
    final int width = image.width;
    final int height = image.height;

    final Uint8List y = image.planes[0].bytes;
    final Uint8List u = image.planes[1].bytes;
    final Uint8List v = image.planes[2].bytes;

    final Uint8List payload = Uint8List.fromList([...y, ...u, ...v]);
    sendCCTVImage(width, height, payload);
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
        if (controller.value.isStreamingImages) {
          controller.stopImageStream(); // 스트리밍 중지
        }
        controller.dispose(); // 카메라 해제
      } else if (state == AppLifecycleState.resumed) {
        initCamera(); // 카메라 재초기화
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '웹소캣 연결됨',
      child: (!controller.value.isInitialized)
          ? Container()
          : Column(
              children: [
                CameraPreview(controller),
                IconButton(
                  onPressed: () async {
                    if (is_recording) {
                      print('동영상 전송 끝');
                      if (controller.value.isStreamingImages) {
                        await controller.stopImageStream();
                      }
                      setState(() {
                        is_recording = false;
                      });
                    } else {
                      print('동영상 전송 시작');
                      // 카메라가 초기화 되었는 지 확인
                      if (!controller.value.isInitialized) {
                        await controller.initialize();
                      }
                      startImageStream();
                      setState(() => is_recording = true);
                    }
                  },
                  icon: Icon(
                    is_recording ? Icons.stop : Icons.play_arrow,
                    size: 50,
                  ),
                ),
              ],
            ),
    );
  }
}
