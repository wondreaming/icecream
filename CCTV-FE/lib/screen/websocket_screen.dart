import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:icecreamcctv/common/default_layout.dart';
import 'package:icecreamcctv/main.dart';
import 'package:path_provider/path_provider.dart';
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
  XFile? videoFile;
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
  void sendCCTVImage(String imageText) {
    Map<String, String> CCTVImage = {
      'CCTVImage': imageText,
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
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  // video를 frame으로 쪼개기
  void extractFrames(String videoPath, String outputPath) {
    final command = "-i $videoPath -vf fps=30 $outputPath/frame_%04d.png";
    FFmpegKit.execute(command).then((session) async {
      final returnCode = await session.getReturnCode();
      if (ReturnCode.isSuccess(returnCode)) {
        print("Frames extracted successfully");
      } else {
        print("Error in extracting frames");
      }
    });
  }

  // 프레임 이미지는 blob로 변환
  Future<Uint8List> getFrameBytes(String framePath) async {
    File frameFile = File(framePath);
    return await frameFile.readAsBytes();
  }

  void processVideoAndSendFrames(String videoPath) async {
    print('동영상을 프레임으로 쪼개서, 텍스트로 전송');
    // Define output path for frames
    final outputPath = (await getTemporaryDirectory()).path + "/frames";
    await Directory(outputPath).create(recursive: true);

    // Extract frames using FFmpegKit
    extractFrames(videoPath, outputPath);

    // Send each frame
    var dir = Directory(outputPath);
    await for (var entity in dir.list()) {
      if (entity is File) {
        Uint8List imageData = await getFrameBytes(entity.path);
        sendCCTVImage(base64Encode(imageData));  // Encode to base64 if needed or send directly
        print("Frame sent: ${entity.path}");
      }
    }
  }


  @override
  void dispose() {
    controller.dispose(); // 카메라 종료
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  // 생명 주기 관리
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (controller != null && controller.value.isInitialized) {
      if (state == AppLifecycleState.paused) {
        controller.dispose();
      } else if (state == AppLifecycleState.resumed) {
        initCamera();
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
                      print('동영상 촬영 끝');
                      videoFile = await controller.stopVideoRecording();
                      print(videoFile!.path);

                      processVideoAndSendFrames(videoFile!.path);

                      setState(() {
                        is_recording = false;
                      });
                    } else {
                      print('동영상 촬영 시작');
                      await controller.startVideoRecording();
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
