import 'package:flutter/material.dart';
import 'package:icecream/com/widget/navbar.dart';

class PHome extends StatefulWidget {
  const PHome({super.key});

  @override
  State<PHome> createState() => _PHomeState();
}

class _PHomeState extends State<PHome> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Add your page content here
            const Center(
              child: Text('부모페이지입니다.'),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 55, // Adjust the height as needed
                child: CustomNav(
                  currentPage: _currentPage,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
