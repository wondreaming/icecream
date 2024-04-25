import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icecream/com/widget/default_layout.dart';
import 'package:icecream/setting/widget/add_container.dart';
import 'package:icecream/setting/widget/custom_popupbutton.dart';
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
          firstOnTap: (){Future.delayed(
            const Duration(seconds: 0),
                () => showDialog(
              context: context,
              builder: (context) => const AlertDialog(
                title: Text('test dialog'),
              ),
            ),
          );},
          secoundOnTap: (){},
          thirdOnTap: (){},
        ),
      ],
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
    );
  }
}
