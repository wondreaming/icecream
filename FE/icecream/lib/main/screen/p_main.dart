import 'package:flutter/material.dart';
import 'package:icecream/com/widget/default_layout.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:icecream/main/widget/childrenList.dart';

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
  Set<Marker> markers = {};

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _initKakaoMapFuture = initKakaoMap();
  }

  Future<void> initKakaoMap() async {
    await dotenv.load();
    final mapApiKey = dotenv.env['KAKAO_API_KEY'];
    AuthRepository.initialize(appKey: '$mapApiKey');
    _initialPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      automaticallyImplyLeading: false,
      title: '보호자 메인',
      padding: EdgeInsets.zero,
      child: Scaffold(
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!, width: 1),
              ),
              child: _buildExpansionPanelList(),
            ),
            Expanded(
              child: FutureBuilder(
                future: _initKakaoMapFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      _initialPosition != null) {
                    return KakaoMap(
                      onMapCreated: _onMapCreated,
                      markers: markers.toList(),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.fromLTRB(
            20,
            5,
            10,
            10,
          ),
          child: FloatingActionButton(
            onPressed: _moveToCurrentLocation,
            backgroundColor: Colors.white,
            elevation: 3,
            tooltip: '현재 위치로 이동',
            shape: CircleBorder(
              side: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1),
            ),
            child: const Icon(Icons.my_location, color: Colors.blue),
          ),
        ),
        floatingActionButtonLocation: const StartFloatFabLocation(),
      ),
    );
  }

  Widget _buildExpansionPanelList() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      children: [
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return const ListTile(
              title: Text('자녀 목록', style: TextStyle(fontSize: 16)),
            );
          },
          body: const ChildList(),
          isExpanded: _isExpanded,
        ),
      ],
    );
  }

  void _onMapCreated(KakaoMapController controller) {
    _mapController = controller;
    if (_initialPosition != null) {
      controller.panTo(
          LatLng(_initialPosition!.latitude, _initialPosition!.longitude));
      _addMarkerAtPosition(_initialPosition!);
    }
  }

  void _moveToCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _mapController?.panTo(LatLng(position.latitude, position.longitude));
    _addMarkerAtPosition(position);
  }

  void _addMarkerAtPosition(Position position) {
    final marker = Marker(
      markerId: UniqueKey().toString(),
      latLng: LatLng(position.latitude, position.longitude),
    );
    setState(() {
      markers.add(marker);
    });
  }
}
