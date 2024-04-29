import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class Temp extends StatelessWidget {
  const Temp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          // 부모 페이지 이동 버튼
          ElevatedButton(onPressed: (){context.go('/parents');}, child: Text('부모 페이지'),),
          ElevatedButton(onPressed: (){context.go('/parents/setting');}, child: Text('부모 설정 페이지'),),
          ElevatedButton(onPressed: (){context.go('/c_qrcode');}, child: Text('QRcode 생성페이지'),),
        ],
      )
    );
  }
}
