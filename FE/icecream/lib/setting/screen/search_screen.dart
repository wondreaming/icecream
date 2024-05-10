import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:icecream/com/const/color.dart';
import 'package:icecream/com/widget/default_layout.dart';
import 'package:icecream/setting/provider/destination_provider.dart';
import 'package:icecream/setting/widget/custom_elevated_button.dart';
import 'package:icecream/setting/widget/custom_text_container_v2.dart';
import 'package:kpostal/kpostal.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // provider할 정보
  late String address;
  late double latitude;
  late double longitude;

  // 주소 값 받을 text
  late String searchAddress;
  TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '주소 검색',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '안심 보행 목적지 주소를\n검색해주세요',
            style: TextStyle(
              fontFamily: 'GmarketSans',
              fontSize: 24.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          GestureDetector(
            onTap: () {
              print('실행됨');
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return KpostalView(
                  callback: (Kpostal result) {
                    setState(() {
                      this.address = result.address;
                      this.latitude = result.latitude!.toDouble();
                      this.longitude = result.longitude!.toDouble();
                    });
                    Provider.of<Destination>(context, listen: false)
                        .changeTheValue(result.address, result.latitude!,
                            result.longitude!);
                  },
                );
              }));
            },
            child: CustomTextContainerV2(),
          ),
          SizedBox(
            height: 8.0,
          ),
          CustomElevatedButton(
            onPressed: () {
              context.goNamed('map');
            },
            child: '현재 위치로 찾기',
            backgroundColor: AppColors.background_color,
            isSearch: true,
          ),
          SizedBox(
            height: 24.0,
          ),
          Container(
            height: 90.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  '이렇게 검색해 보세요',
                  style: TextStyle(
                    fontFamily: 'GmarketSans',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '·',
                      style: TextStyle(
                        fontFamily: 'GmarketSans',
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      ' 도로명 + 건물번호 (녹산산업중로 333)',
                      style: TextStyle(
                        fontFamily: 'GmarketSans',
                        fontSize: 12.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '·',
                      style: TextStyle(
                        fontFamily: 'GmarketSans',
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      ' 건물명 + 번지 (송정동 1623-2)',
                      style: TextStyle(
                        fontFamily: 'GmarketSans',
                        fontSize: 12.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '·',
                      style: TextStyle(
                        fontFamily: 'GmarketSans',
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      ' 건물명, 아파트명 (삼성전기 부산사업장, 반포 자이)',
                      style: TextStyle(
                        fontFamily: 'GmarketSans',
                        fontSize: 12.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
