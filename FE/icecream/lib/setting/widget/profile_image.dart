import 'package:flutter/material.dart';
import 'package:icecream/com/const/color.dart';

class ProfileImage extends StatelessWidget {
  final double width;
  final double height;
  final String? imgUrl;
  final bool detail;
  const ProfileImage(
      {super.key,
      required this.width,
      required this.height,
      this.imgUrl,
      this.detail = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: imgUrl != null && imgUrl!.isNotEmpty
              ? Image.asset(
                  imgUrl!,
                  fit: BoxFit.cover,
                  width: width,
                  height: height,
                )
              : Icon(
                  Icons.account_circle_rounded,
                  color: AppColors.profile_black.withOpacity(0.5),
                  size: (width + 5),
                ),
        ),
        if (detail)
        Positioned(
          bottom: 15,
          right: 15,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: AppColors.profile_black.withOpacity(0.5),
            ),
            child: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {},
            ),
          ),
        ),
      ],
    );
  }
}
