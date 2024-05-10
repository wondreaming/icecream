import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icecream/com/const/dio_interceptor.dart';
import 'package:icecream/com/widget/default_layout.dart';
import 'package:icecream/setting/model/password_model.dart';
import 'package:icecream/setting/model/response_model.dart';
import 'package:icecream/setting/repository/user_repository.dart';
import 'package:icecream/setting/widget/custom_elevated_button.dart';
import 'package:icecream/setting/widget/custom_modal.dart';
import 'package:icecream/setting/widget/custom_popupbutton.dart';
import 'package:icecream/setting/widget/custom_show_dialog.dart';
import 'package:icecream/setting/widget/custom_text_field.dart';
import 'package:icecream/setting/widget/detail_profile.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  late bool _isHidden = true;
  late String password = '';
  TextEditingController passwordController = TextEditingController();

  // 비밀 번호 확인 api
  Future<ResponseModel> postPassword() async {
    final dio = CustomDio().createDio();
    final userRepository = UserRespository(dio);

    PasswordModel newPassword = PasswordModel(password: password);

    ResponseModel response =
        await userRepository.postPassword(password: newPassword);

    return response;
  }

  void checkPostPassword() async {
    ResponseModel response;
    response = await postPassword();

    print('배부름 ${response.status}');
    if (response.status == 200) {
      passwordController.clear();
      context.pop();
      changePasswordModal(context);
    } else {
      final String message = response.message;
      showCustomDialog(
        context,
        message,
        isNo: false,
      );
    }
  }

  // 비밀 번호 변경 api
  Future<ResponseModel> patchPassword() async {
    final dio = CustomDio().createDio();
    final userRepository = UserRespository(dio);

    PasswordModel newPassword = PasswordModel(password: password);
    ResponseModel response =
        await userRepository.patchPassword(password: newPassword);
    return response;
  }

  void changePassword() async {
    ResponseModel response;
    response = await patchPassword();

    if (response.status == 200) {
      passwordController.clear();
      context.pop();
    } else {
      final String message = response.message;
      showCustomDialog(context, message, isNo: false, onPressed: () {
        context.pop();
      });
    }
  }

  // 회원 로그아웃 api
  Future<ResponseModel> postLogout() async {
    final dio = CustomDio().createDio();
    final userRepository = UserRespository(dio);

    ResponseModel response = await userRepository.postLogout();
    return response;
  }

  // 회원 탈퇴 api
  Future<ResponseModel> deleteUser() async {
    final dio = CustomDio().createDio();
    final userRepository = UserRespository(dio);

    ResponseModel response = await userRepository.deleteUser();
    return response;
  }

  void deleteChild() async {
    ResponseModel response;
    response = await deleteUser();

    if (response.status == 200) {
      final String message = response.message;
      showCustomDialog(context, message, isNo: false, onPressed: () {
        context.pop();
      });
    } else {
      final String message = response.message;
      showCustomDialog(context, message, isNo: false, onPressed: () {
        context.pop();
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '마이 페이지',
      action: [
        CustomPopupButton(
          isFourth: true,
          first: '비밀번호 변경',
          secound: '전화번호 변경',
          third: '로그아웃',
          fourth: '회원 탈퇴',
          firstOnTap: () {
            showCustomModal(
              context,
              '비밀번호 변경',
              PopScope(
                canPop: true,
                onPopInvoked: (bool didPop) async {
                  passwordController.clear();
                },
                child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return Column(
                    children: [
                      SizedBox(height: 16.0),
                      CustomTextField(
                        controller: passwordController,
                        onChanged: (String value) {
                          password = value;
                        },
                        obscureText: _isHidden,
                        maxLines: 1,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isHidden = !_isHidden;
                            });
                          },
                          icon: Icon(_isHidden
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                        hintText: '현재 비밀번호를 입력해주세요',
                      ),
                      SizedBox(height: 16.0),
                      CustomElevatedButton(
                          onPressed: () {
                            checkPostPassword();
                          },
                          child: '다음'),
                    ],
                  );
                }),
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
            showCustomDialog(context, '로그아웃하시겠습니까?', onPressed: () {
              postLogout();
            });
          },
          fourthOnTap: () {
            showCustomDialog(context, '회원 탈퇴하시겠습니까?', onPressed: () {
              deleteChild();
            });
          },
        ),
      ],
      child: DetailProfile(
        name: '김싸피',
        id: 'ssafy',
        number: '010-1234-5678',
      ),
    );
  }
}

// 비밀번호 변경 모달
void changePasswordModal(BuildContext context) {
  late bool _isHidden1 = true;
  late bool _isHidden2 = true;
  late String password1 = '';
  late String password2 = '';
  TextEditingController passwordController1 = TextEditingController();
  TextEditingController passwordController2 = TextEditingController();
  showCustomModal(
    context,
    '비밀번호 변경',
    StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return Column(
        children: [
          SizedBox(height: 16.0),
          CustomTextField(
            controller: passwordController1,
            onChanged: (String value) {
              password1 = value;
            },
            obscureText: _isHidden1,
            maxLines: 1,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _isHidden1 = !_isHidden1;
                });
              },
              icon: Icon(_isHidden1 ? Icons.visibility_off : Icons.visibility),
            ),
            hintText: '변경할 비밀번호를 입력해주세요',
          ),
          SizedBox(height: 16.0),
          CustomTextField(
            controller: passwordController2,
            onChanged: (String value) {
              password2 = value;
            },
            obscureText: _isHidden2,
            maxLines: 1,
            suffixIcon: IconButton(
              onPressed: () {
                print('숨김이 될까요? $_isHidden2');
                setState(() {
                  _isHidden2 = !_isHidden2;
                });
              },
              icon: Icon(_isHidden2 ? Icons.visibility_off : Icons.visibility),
            ),
            hintText: '변경할 비밀번호를 다시 입력해주세요',
          ),
          SizedBox(height: 16.0),
          CustomElevatedButton(
              onPressed: () {
                if (password1 == password2) {
                  changePassword(context, password1);
                  context.pop();
                }
              },
              child: '저장'),
        ],
      );
    }),
    220.0,
  );
}

void changePassword(context, password) async {
  ResponseModel response;
  response = await patchPassword(password);
  print('변경이 잘 되었나 ${response.status}');
  if (response.status == 200) {
  } else {
    final String message = response.message;
    showCustomDialog(
      context,
      message,
      isNo: false,
    );
  }
}

// 비밀 번호 변경 api
Future<ResponseModel> patchPassword(password) async {
  final dio = CustomDio().createDio();
  final userRepository = UserRespository(dio);

  PasswordModel newPassword = PasswordModel(password: password);
  ResponseModel response =
      await userRepository.patchPassword(password: newPassword);
  return response;
}
