import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:icecream/provider/user_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:icecream/main/widget/expansion_tile_card.dart';

class ChildList extends StatelessWidget {
  final Function(int childId, String childName, String? profileImage) onChildTap;

  const ChildList({super.key, required this.onChildTap});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final children = userProvider.children;
    final GlobalKey<ExpansionTileCardState> expansionTileKey = GlobalKey<ExpansionTileCardState>();

    print("자녀수: ${children.length}");

    return ExpansionTileCard(
      key: expansionTileKey,
      baseColor: Colors.amber[100],  // 카드의 기본 색상
      expandedColor: Colors.white,  // 카드 확장 시 색상
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16), // 제목 부분의 양 옆에 여백 추가
        child: Text("자녀 목록", style: TextStyle(fontSize: 16, fontFamily: 'GmarketSans')),
      ),

      contentPadding: EdgeInsets.zero,  // 패딩 제거
      trailing: Padding(
        padding: const EdgeInsets.only(right: 16.0), // 메뉴를 여는 아이콘 오른쪽에 여백 추가
        child: Icon(Icons.expand_more),
      ),
      children: <Widget>[
        Container(
          height: 100,
          decoration: BoxDecoration(

            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16), // 내부 패딩 추가 (양 옆 여백)
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
                          context.pushNamed('qrscan_page');
                        },
                      ),
                    ],
                  ),
                );
              } else {
                var child = children[index];
                ImageProvider childImage = child.profileImage != null && child.profileImage!.isNotEmpty
                    ? AssetImage(child.profileImage!)
                    : const AssetImage('asset/img/picture.JPEG');

                return InkWell(
                  onTap: () {
                    expansionTileKey.currentState?.collapse();  // 패널 닫기
                    onChildTap(child.userId, child.username, child.profileImage);
                  },
                  child: SizedBox(
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
                          style: const TextStyle(fontSize: 12, fontFamily: 'GmarketSans'),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
