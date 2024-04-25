import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:icecream/com/const/color.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){context.goNamed('my_page');},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.container_background_color,
        ),
        height: 130,
        width: double.infinity,
        padding: EdgeInsets.only(left: 20.0, right: 10.0),
        child: Row(
          children: [
            Flexible(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset(
                  'asset/img/picture.JPEG',
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
                ),
              ),
              flex: 1,
            ),
            Flexible(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '김싸피님',
                          style: TextStyle(
                            fontFamily: 'GmarketSans',
                            fontSize: 22.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          '010-1234-5678',
                          style: TextStyle(
                            fontFamily: 'GmarketSans',
                            fontSize: 18.0,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward_ios_rounded),
                      onPressed: () {context.goNamed('my_page');},
                    ),
                  ],
                ),
              ),
              flex: 3,
            ),
          ],
        ),
      ),
    );
  }
}
