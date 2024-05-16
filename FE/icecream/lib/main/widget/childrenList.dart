import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:icecream/provider/user_provider.dart';
import 'package:go_router/go_router.dart';

class ChildList extends StatelessWidget {
  const ChildList({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final children = userProvider.children;

    print("자녀수: ${children.length}");

    return Container(
      height: 100,
      color: Colors.amber[100],
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: children.length + 1,
        itemBuilder: (context, index) {
          if (index == children.length) {
            return Container(
              width: 50,
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, size: 24, color: Colors.black),
                    onPressed: () {
                      // GoRouter를 사용하여 QRScanPage로 이동합니다.
                      context.pushNamed('qrscan_page');
                    },
                  ),
                ],
              ),
            );
          } else {
            var child = children[index];
            // 자녀 프로필 이미지가 null인 경우 기본 이미지 사용
            ImageProvider childImage = child.profileImage != null && child.profileImage!.isNotEmpty
                ? AssetImage(child.profileImage!)
                : const AssetImage('asset/img/picture.JPEG'); // 기본 이미지 경로를 확인하세요.

            return SizedBox(
              width: 80,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 7),
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: childImage,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    child.username,
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
