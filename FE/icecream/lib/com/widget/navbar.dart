import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';

class CustomNav extends StatefulWidget {
  const CustomNav(
      {super.key, required this.currentPage, required this.onPageChanged});

  final int currentPage;
  final ValueChanged<int> onPageChanged;

  @override
  _CustomNavState createState() => _CustomNavState();
}

class _CustomNavState extends State<CustomNav>
    with SingleTickerProviderStateMixin {
  final List<Color> colors = [
    Colors.yellow,
    Colors.red,
    Colors.blue,
    Colors.pink,
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      widget.onPageChanged(_tabController.index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomBar(
      clip: Clip.none,
      fit: StackFit.expand,
      borderRadius: BorderRadius.circular(500),
      duration: const Duration(milliseconds: 500),
      curve: Curves.decelerate,
      showIcon: true,
      width: MediaQuery.of(context).size.width * 0.8,
      barColor: Colors.black,
      start: 2,
      end: 0,
      offset: 10,
      barAlignment: Alignment.bottomCenter,
      iconHeight: 30,
      iconWidth: 30,
      reverse: false,
      barDecoration: BoxDecoration(
        color: colors[widget.currentPage],
        borderRadius: BorderRadius.circular(500),
      ),
      iconDecoration: BoxDecoration(
        color: colors[widget.currentPage],
        borderRadius: BorderRadius.circular(500),
      ),
      hideOnScroll: true,
      scrollOpposite: false,
      onBottomBarHidden: () {},
      onBottomBarShown: () {},
      body: (context, controller) => const Text('부모페이지입니다.'),
      child: TabBar(
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        indicatorPadding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
        controller: _tabController,
        indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              color: colors[widget.currentPage],
              width: 4,
            ),
            insets: const EdgeInsets.fromLTRB(16, 0, 16, 8)),
        tabs: [
          _buildTab(Icons.home, 0),
          _buildTab(Icons.search, 1),
          _buildTab(Icons.favorite, 2),
          _buildTab(Icons.settings, 3),
        ],
      ),
    );
  }

  Widget _buildTab(IconData icon, int index) {
    return SizedBox(
      height: 55,
      width: 40,
      child: Center(
        child: Icon(
          icon,
          color: widget.currentPage == index ? colors[index] : Colors.white,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
