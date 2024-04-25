import 'package:flutter/material.dart';
import 'package:icecream/setting/widget/custom_text_container.dart';
import 'package:icecream/setting/widget/profile_image.dart';

class DetailProfile extends StatelessWidget {
  final String name;
  final String id;
  final String number;
  const DetailProfile(
      {super.key, required this.name, required this.id, required this.number});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileImage(
          width: 200,
          height: 200,
          detail: true,
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(
          name,
          style: TextStyle(
            fontFamily: 'GmarketSans',
            fontSize: 28.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        CustomTextContainer(frontIcon: Icons.person, text: id),
        CustomTextContainer(frontIcon: Icons.phone_android, text: number),
      ],
    );
  }
}
