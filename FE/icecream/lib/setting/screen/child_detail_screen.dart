import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:icecream/com/widget/default_layout.dart';
import 'package:icecream/setting/model/all_destination_model.dart';
import 'package:icecream/setting/model/destination_model.dart';
import 'package:icecream/setting/repository/destination_repository.dart';
import 'package:icecream/setting/widget/add_container.dart';
import 'package:icecream/setting/widget/custom_elevated_button.dart';
import 'package:icecream/setting/widget/destination_container.dart';
import 'package:icecream/setting/widget/custom_modal.dart';
import 'package:icecream/setting/widget/custom_popupbutton.dart';
import 'package:icecream/setting/widget/custom_show_dialog.dart';
import 'package:icecream/setting/widget/custom_text_field.dart';
import 'package:icecream/setting/widget/detail_profile.dart';

class ChildDetailScreen extends StatefulWidget {
  final int user_id;
  const ChildDetailScreen({
    super.key,
    required this.user_id,
  });

  @override
  State<ChildDetailScreen> createState() => _ChildDetailScreenState();
}

class _ChildDetailScreenState extends State<ChildDetailScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // 안심 보행 목적지 조회
  Future<List<DestinationModel>> getDestination() async {
    final String baseUrl = dotenv.env['baseUrl']!;
    final dio = Dio();
    final destinationRepository = DestinationRespository(dio, baseUrl: baseUrl);
    try {
      final response =
          await destinationRepository.getDestinaion(user_id: widget.user_id);
      return response.data;
    } catch (e) {
      print(e);
      return [];
    }
  }

  // 하위 위젯에서 안심 보행 업데이트를 위한 콜백 함수
  void refresh() {
    setState(() {
      getDestination();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '자녀 관리',
      action: [
        CustomPopupButton(
          first: '이름 변경',
          secound: '전화번호 변경',
          third: '연결 해제',
          firstOnTap: () {
            showCustomModal(
              context,
              '이름 변경',
              Column(
                children: [
                  SizedBox(height: 16.0),
                  CustomTextField(
                    hintText: '변경할 이름을 입력해주세요',
                  ),
                  SizedBox(height: 16.0),
                  CustomElevatedButton(onPressed: () {}, child: '저장'),
                ],
              ),
              160.0,
            );
          },
          secoundOnTap: () {
            // QR 찍는 페이지로 이동
            context.push('/c_qrcode');
          },
          thirdOnTap: () {
            showCustomDialog(context, '연결 해제 하시겠습니까?');
          },
        ),
      ],
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            children: [
              DetailProfile(
                is_parents: false,
                id: '김자식',
                number: '010-1234-5678',
              ),
              Container(
                margin: EdgeInsets.only(bottom: 8.0, top: 16.0),
                width: double.infinity,
                height: 60,
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    Flexible(
                      child: Icon(
                        Icons.place,
                        size: 50,
                      ),
                      flex: 1,
                    ),
                    Flexible(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          '안심 보행',
                          style: TextStyle(
                            fontFamily: 'GmarketSans',
                            fontSize: 26.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder<List<DestinationModel>>(
                future: getDestination(),
                builder:
                    (context, AsyncSnapshot<List<DestinationModel>> snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  }
                  // snapshot.hasData가 없으면,
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  // snapshot.hasData가 있으면,
                  return ListView.separated(
                      shrinkWrap: true, // 자식 위젯의 크기만큼만 차지
                      itemBuilder: (_, index) {
                        final pItem = snapshot.data![index];
                        return DestinationContainer.fromModel(
                          model: pItem,
                          onDeleted: refresh,
                        );
                      },
                      separatorBuilder: (_, index) {
                        return SizedBox(
                          height: 10.0,
                        );
                      },
                      itemCount: snapshot.data!.length);
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              AddContainer(
                mention: '안심 보행지를 추가해주세요',
                onPressed: () {
                  context.goNamed('destination');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
