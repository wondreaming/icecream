import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icecream/com/const/color.dart';
import 'package:icecream/com/widget/default_layout.dart';
import 'package:icecream/setting/service/location.dart';
import 'package:icecream/setting/widget/custom_elevated_button.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocationData();
  }

  // 지도 관련 변수
  late KakaoMapController mapController; // 카카오 맵 컨트롤러
  Set<Marker> markers = {}; // 마커변수
  LatLng? currentLocation; // 현재 위치를 받을 변수

  // 현재 위치 찾기
  void getLocationData() async {
    Location location = Location();
    await location.getCurrentLocation();
    setState(() {
      currentLocation = LatLng(location.latitude, location.longitude);
      markers.add(Marker(
          markerId: "currentLocation",
          latLng: LatLng(location.latitude, location.longitude)));
    });
    print(location.latitude); // 위도
    print(location.longitude); // 경도
    print('현재 위도 경도 $currentLocation');
    print('marker ${markers.toList()}');
  }

  @override
  Widget build(BuildContext context) {

    return DefaultLayout(
      isMap: true,
      title: '지도에서 위치 확인',
      child: Stack(
        children: [
          (currentLocation == null && markers.toList() == null)
              ? Center(child: CircularProgressIndicator())
              : KakaoMap(
                  onMapCreated: ((controller) async {
                    mapController = controller;
                    // markers.add(value)
                  }),
                ),
          Positioned(
              bottom: 210.0,
              right: 10.0,
              child: FloatingActionButton.extended(
                onPressed: () {
                  getLocationData();
                },
                backgroundColor: AppColors.background_color,
                icon: Icon(Icons.location_searching),
                label: Text('현재 위치'),
                isExtended: false,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              )),
          Positioned(
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: AppColors.background_color,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              width: MediaQuery.of(context).size.width,
              height: 200.0,
              child: Column(
                children: [
                  CustomElevatedButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: '이 위치로 주소 등록',
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
