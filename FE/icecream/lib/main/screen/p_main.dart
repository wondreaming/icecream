import 'package:flutter/material.dart';
import 'package:icecream/com/widget/default_layout.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:geolocator/geolocator.dart';

class StartFloatFabLocation extends FloatingActionButtonLocation {
  const StartFloatFabLocation();

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double fabY = scaffoldGeometry.scaffoldSize.height - 140.0;
    return Offset(-3.0, fabY);
  }
}

class PMain extends StatefulWidget {
  const PMain({super.key});

  @override
  _PMainState createState() => _PMainState();
}

class _PMainState extends State<PMain> {
  late Future<void> _initKakaoMapFuture;
  KakaoMapController? _mapController;
  Position? _initialPosition;

  @override
  void initState() {
    super.initState();
    _initKakaoMapFuture = initKakaoMap();
  }

  Future<void> initKakaoMap() async {
    await dotenv.load(); // Load environment variables
    final mapApiKey = dotenv.env['KAKAO_API_KEY'];
    AuthRepository.initialize(appKey: '$mapApiKey'); // Set API key
    // 현재 위치를 얻고 지도의 중심으로 설정합니다.
    _initialPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '보호자 메인',
      child: Scaffold(
        body: FutureBuilder(
          future: _initKakaoMapFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return KakaoMap(
                onMapCreated: (controller) {
                  _mapController = controller;
                  if (_initialPosition != null) {
                    _mapController?.panTo(LatLng(_initialPosition!.latitude,
                        _initialPosition!.longitude));
                  }
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(),
          child: FloatingActionButton(
            onPressed: _moveToCurrentLocation,
            backgroundColor: Colors.white,
            elevation: 3,
            tooltip: '현재 위치로 이동',
            shape: CircleBorder(
              side: BorderSide(
                color: Colors.grey.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: const Icon(Icons.my_location, color: Colors.blue),
          ),
        ),
        floatingActionButtonLocation: const StartFloatFabLocation(),
      ),
    );
  }

  void _moveToCurrentLocation() async {
    if (_mapController != null) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      _mapController!.panTo(LatLng(position.latitude, position.longitude));
    }
  }
}
