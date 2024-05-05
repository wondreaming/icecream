import 'package:flutter/material.dart';
import 'package:icecream/com/const/color.dart';

class DayContainer extends StatefulWidget {
  final String day;
  final bool isClicked;
  const DayContainer({super.key, required this.day, this.isClicked = false});

  @override
  State<DayContainer> createState() => _DayContainerState();
}

class _DayContainerState extends State<DayContainer> {

  @override
  Widget build(BuildContext context) {
    print('자식 냠냠 ${widget.isClicked}');
    return Container(
          child: Center(
            child: Text(
              widget.day,
              style: TextStyle(
                fontFamily: 'GmarketSans',
                fontSize: 20.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          height: 40.0,
          width: MediaQuery.of(context).size.width * 1 / 5,
          margin: EdgeInsets.symmetric(horizontal: 2.0),
          decoration: BoxDecoration(
            color: widget.isClicked ? AppColors.custom_yellow.withOpacity(0.5) : AppColors.background_color,
            border: Border.all(color: AppColors.profile_black.withOpacity(0.5),),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
    );
  }
}
