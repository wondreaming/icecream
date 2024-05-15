import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:icecream/com/const/dio_interceptor.dart';
import 'package:icecream/com/widget/default_layout.dart';
import 'package:icecream/provider/user_provider.dart';
import 'package:icecream/setting/model/child_name_model.dart';
import 'package:icecream/setting/model/destination_model.dart';
import 'package:icecream/setting/model/response_model.dart';
import 'package:icecream/setting/repository/destination_repository.dart';
import 'package:icecream/setting/repository/user_repository.dart';
import 'package:icecream/setting/widget/add_container.dart';
import 'package:icecream/setting/widget/custom_elevated_button.dart';
import 'package:icecream/setting/widget/destination_container.dart';
import 'package:icecream/setting/widget/custom_modal.dart';
import 'package:icecream/setting/widget/custom_popupbutton.dart';
import 'package:icecream/setting/widget/custom_show_dialog.dart';
import 'package:icecream/setting/widget/custom_text_field.dart';
import 'package:icecream/setting/widget/detail_profile.dart';
import 'package:provider/provider.dart';

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

  late String username = '';
  TextEditingController usernameController = TextEditingController();

  // 자녀 이름 수정
  Future<ResponseModel> patchChild() async {
    final dio = CustomDio().createDio();
    final userRepository = UserRespository(dio);

    ChildNameModel newChildName =
        ChildNameModel(user_id: widget.user_id, username: username);
    ResponseModel response =
        await userRepository.patchChild(childName: newChildName);
    return response;
  }

  // 자녀 해제
  Future<ResponseModel> deleteChild() async {
    final dio = CustomDio().createDio();
    final userRepository = UserRespository(dio);

    ResponseModel response =
        await userRepository.deleteChild(user_id: widget.user_id);
    return response;
  }

  // 안심 보행 목적지 조회
  Future<List<DestinationModel>> getDestination() async {
    final dio = CustomDio().createDio();
    final destinationRepository = DestinationRespository(dio);

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
  Future<void> refresh() async {
    await getDestination();
    setState(() {
      getDestination();
    });
  }

  // 자녀 연결 해제
  void saveDeleteChild() async {
    ResponseModel response;
    response = await deleteChild();

    if (response.status == 200) {
      context.pop();
    } else {
      final String message = response.message!;
      showCustomDialog(context, message, isNo: false, onPressed: () {
        context.pop();
      });
    }
  }

  // 자녀 이름 수정
  void saveUsername() async {
    ResponseModel response;
    response = await patchChild();

    if (response.status == 200) {
      usernameController.clear();
      context.pop();
    } else {
      final String message = response.message;
      showCustomDialog(context, message, isNo: false, onPressed: () {
        context.pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final children = userProvider.children;

    late Child child =
        children.firstWhere((child) => child.userId == widget.user_id);

    return DefaultLayout(
      title: '자녀 관리',
      action: [
        CustomPopupButton(
          isFourth: true,
          first: '이름 변경',
          secound: '전화번호 변경',
          third: '디바이스 변경',
          fourth: '연결 해제',
          firstOnTap: () {
            showCustomModal(
              context,
              '이름 변경',
              PopScope(
                canPop: true,
                onPopInvoked: (bool didPop) async {
                  usernameController.clear();
                },
                child: Column(
                  children: [
                    SizedBox(height: 16.0),
                    CustomTextField(
                      controller: usernameController,
                      onChanged: (String value) {
                        username = value;
                        print(username);
                      },
                      hintText: '변경할 이름을 입력해주세요',
                    ),
                    SizedBox(height: 16.0),
                    CustomElevatedButton(
                        onPressed: () {
                          saveUsername();
                        },
                        child: '저장'),
                  ],
                ),
              ),
              160.0,
            );
          },
          secoundOnTap: () {
            showCustomModal(
              context,
              '전화번호 변경',
              Column(
                children: [
                  SizedBox(height: 16.0),
                  CustomTextField(
                    hintText: '현재 전화번호를 입력해주세요',
                  ),
                  SizedBox(height: 16.0),
                  CustomElevatedButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: '저장'),
                ],
              ),
              160.0,
            );
          },
          thirdOnTap: () {
            // QR 찍는 페이지로 이동
            context.pushNamed('qrscan_page');
          },
          fourthOnTap: () {
            showCustomDialog(context, '연결 해제 하시겠습니까?', onPressed: () {
              saveDeleteChild();
            });
          },
        ),
      ],
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            children: [
              DetailProfile(
                user_id: child.userId,
                is_parents: false,
                id: child.username,
                number: child.phoneNumber,
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
                          user_id: child.userId,
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
                  context.pushNamed('destination',
                      pathParameters: {'user_id': widget.user_id.toString()});
                  onDataSaved:
                  () {
                    setState(() {
                      // 데이터를 새로고침하거나 UI를 업데이트
                      refresh();
                    });
                  };
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
