import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icecream/com/widget/default_layout.dart';
import 'package:icecream/setting/widget/add_container.dart';
import 'package:icecream/setting/widget/custom_elevated_button.dart';
import 'package:icecream/setting/widget/custom_modal.dart';
import 'package:icecream/setting/widget/custom_popupbutton.dart';
import 'package:icecream/setting/widget/custom_show_dialog.dart';
import 'package:icecream/setting/widget/custom_text_field.dart';
import 'package:icecream/setting/widget/detail_profile.dart';

class ChildScreen extends StatelessWidget {
  const ChildScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '자녀 관리',
      action: [
        CustomPopupButton(
          first: '이름 변경',
          secound: '전화번호 변경',
          third: '연결 해제',
          firstOnTap: () {
            showCustomModal(
              context,
              '이름 변경',
              Column(
                children: [
                  SizedBox(height: 16.0),
                  CustomTextField(
                    hintText: '변경할 이름을 입력해주세요',
                  ),
                  SizedBox(height: 16.0),
                  CustomElevatedButton(onPressed: () {}, child: '저장'),
                ],
              ),
              160.0,
            );
          },
          secoundOnTap: () {
            // QR 찍는 페이지로 이동
            context.push('/c_qrcode');
          },
          thirdOnTap: () {
            showCustomDialog(context, '연결 해제 하시겠습니까?');
          },
        ),
      ],
      child: SingleChildScrollView(
        child: Column(
          children: [
            DetailProfile(
              is_parents: false,
              id: '김자식',
              number: '010-1234-5678',
            ),
            Container(
              margin: EdgeInsets.only(bottom: 8.0, top: 16.0),
              width: double.infinity,
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: [
                  Flexible(
                    child: Icon(
                      Icons.place,
                      size: 50,
                    ),
                    flex: 1,
                  ),
                  Flexible(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(
                        '안심 보행',
                        style: TextStyle(
                          fontFamily: 'GmarketSans',
                          fontSize: 26.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AddContainer(
                mention: '안심 보행지를 추가해주세요',
                onPressed: () {
                  context.goNamed('location');
                })
          ],
        ),
      ),
    );
  }
}
