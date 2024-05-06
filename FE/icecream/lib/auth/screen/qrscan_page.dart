import 'package:flutter/material.dart';
import 'package:icecream/auth/screen/child_regist.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:encrypt/encrypt.dart' as en;
import 'dart:convert';

class QRScanPage extends StatefulWidget {
  const QRScanPage({Key? key}) : super(key: key);

  @override
  _QRScanPageState createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String _decryptedData = '';

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera(); // 스캔 후 카메라 일시정지
      setState(() {
        _decryptedData = _decryptData(scanData.code);
        if (_validateData(_decryptedData)) {
          _navigateToChildRegisterPage();
        } else {
          _showErrorMessage();
        }
      });
    });
  }

  bool _validateData(String jsonData) {
    try {
      final data = json.decode(jsonData);
      if (data is Map<String, dynamic>) {
        return data.containsKey('Device ID') && data.containsKey('FCM Token') && data.containsKey('phoneNum');
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  void _navigateToChildRegisterPage() {
    controller?.pauseCamera();
    final data = json.decode(_decryptedData);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChildRegisterPage(
          deviceId: data['Device ID'],
          fcmToken: data['FCM Token'],
          phoneNum: data['phoneNum'],
        ),
      ),
    ).then((_) => controller?.resumeCamera());
  }

  void _showErrorMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('잘못된 QR 코드입니다. 올바른 QR 코드를 스캔하세요.'))
    );
  }

  String _decryptData(String? encryptedData) {
  if (encryptedData == null) return "No data found";

  final key = en.Key.fromUtf8('1996100219961002');
  final parts = encryptedData.split('::');  // IV를 포함하여 전송된 데이터 분리
  if (parts.length != 2) return "Invalid data";

  final iv = en.IV.fromBase64(parts[1]);  // IV 추출
  final encrypter = en.Encrypter(en.AES(key, mode: en.AESMode.cbc));

  try {
    final decrypted = encrypter.decrypt64(parts[0], iv: iv);  // 복호화 시 같은 IV 사용
    debugPrint("Decrypted Info: $decrypted");
    return decrypted;
  } catch (e) {
    debugPrint("Decryption Error: $e");
    return "복호화 실패: $e";
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scan Page'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: MediaQuery.of(context).size.width * 0.8,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                'Decrypted Data: $_decryptedData',
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
