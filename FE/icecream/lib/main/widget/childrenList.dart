import 'package:flutter/material.dart';

class ChildList extends StatelessWidget {
  ChildList({super.key});

  final List<Map<String, String>> children = [
    {'name': '김싸피', 'image': 'asset/img/picture.JPEG'},
    {'name': '이싸피', 'image': 'asset/img/picture.JPEG'},
    {'name': '이싸피', 'image': 'asset/img/picture.JPEG'},
    {'name': '이싸피', 'image': 'asset/img/picture.JPEG'},
    {'name': '이싸피', 'image': 'asset/img/picture.JPEG'},
    {'name': '이싸피', 'image': 'asset/img/picture.JPEG'},
    {'name': '이싸피', 'image': 'asset/img/picture.JPEG'},
    {'name': '최싸피', 'image': 'asset/img/picture.JPEG'},
    // Add more children if needed
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100, // Adjusted height to prevent overflow
      color: Colors.yellow, // Background color for the entire list
      padding: const EdgeInsets.symmetric(vertical: 10), // Padding adjusted
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: children.length + 1, // Account for the additional IconButton
        itemBuilder: (context, index) {
          if (index == children.length) {
            return Container(
              width: 50, // Adjust width as necessary for the button
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
                    icon: const Icon(
                      Icons.add,
                      size: 24, // Reduced icon size for better fit
                      color: Colors.black,
                    ),
                    onPressed: () {
                      // Action for adding a new child
                    },
                  ),
                ],
              ),
            );
          } else {
            var child = children[index];
            return SizedBox(
              width: 80,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 7,
                  ),
                  CircleAvatar(
                    radius: 25, // Radius reduced to fit within the new height
                    backgroundImage: AssetImage(child['image']!),
                  ),
                  const SizedBox(height: 5), // Spacing reduced
                  Text(
                    child['name']!,
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
