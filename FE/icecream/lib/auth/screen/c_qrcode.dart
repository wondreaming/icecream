import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:encrypt/encrypt.dart' as en;
import 'dart:convert';
import 'dart:math';

class QRCodePage extends StatefulWidget {
  const QRCodePage({Key? key}) : super(key: key);
  @override
  _QRCodePageState createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  String deviceId = '';
  String fcmToken = '';
  String _qrData = '';

  @override
  void initState() {
    super.initState();
    _generateQrData();
  }

  Future<void> _generateQrData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String deviceId = prefs.getString('deviceId') ?? 'No device ID';
    String fcmToken = prefs.getString('fcmToken') ?? 'No FCM token';
    String phoneNum = '01012345678';

    Map<String, String> data = {
      'Device ID': deviceId,
      'FCM Token': fcmToken,
      'phoneNum': phoneNum
    };

    // JSON 문자열로 변환
    String jsonString = json.encode(data);
    String encryptedData = _encryptData(jsonString);

    setState(() {
      _qrData = encryptedData;
      //     '1iongeg/y7LW3w7hP1nN6zIJvtcMcIi6+W+aR0IZP+4xsBX5IZRRb64CrlvALZA94w8TKB3cX6onFONNW7GQIn5aIESr0pbnDpT+5RVVm6OfTdVz2bZr3fZQY0mu5K/Pa26EulcRNhP+Md40cjrmiNPo0iFlJLW2JkPHTHogwlSgNqvXLTjDCv/+OHe+93wYGIPJjFQk48TCdCCvb+NQJwha/iEfm5U8Q1zdWLpnDiz30Kouk5rjI3yfuEsPZrEk6wV22SGT0OKCOZXas7OnMmC0OjgpwAGv//8STlkULU8/dK10KtaXoc7qEoFOI6lI';
      debugPrint(_qrData);
    });
  }

  String _encryptData(String data) {
    final key = en.Key.fromUtf8('1996100219961002');
    final iv = en.IV.fromLength(16);
    final encrypter = en.Encrypter(en.AES(key, mode: en.AESMode.cbc));

    final encrypted = encrypter.encrypt(data, iv: iv);
    final decrypted = encrypter.decrypt64(encrypted.base64, iv: iv);
    debugPrint("복호화된 정보: $decrypted");
    return encrypted.base64;
  }

  List<Color> getRandomColors() {
    Random random = Random();
    return [
      Color.fromARGB(
          255, random.nextInt(256), random.nextInt(256), random.nextInt(256)),
      Color.fromARGB(
          255, random.nextInt(256), random.nextInt(256), random.nextInt(256)),
      Color.fromARGB(
          255, random.nextInt(256), random.nextInt(256), random.nextInt(256)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<Color> gradientColors = getRandomColors();
    return Scaffold(
      appBar: AppBar(
        title: const Text('QRCode Page'),
      ),
      body: Center(
        child: SizedBox(
          width: 300,
          height: 300,
          child: PrettyQrView.data(
            data: _qrData,
            errorCorrectLevel: QrErrorCorrectLevel.H,
            decoration: PrettyQrDecoration(
              shape: PrettyQrRoundedSymbol(
                color: PrettyQrBrush.gradient(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: gradientColors,
                  ),
                ),
              ),
              image: const PrettyQrDecorationImage(
                image: AssetImage('asset/img/icelogo.png'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
