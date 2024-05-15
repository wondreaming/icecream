import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:icecream/com/const/color.dart';
import 'package:icecream/com/const/dio_interceptor.dart';
import 'package:icecream/provider/user_provider.dart';
import 'package:icecream/setting/model/response_model.dart';
import 'package:icecream/setting/repository/user_repository.dart';
import 'package:icecream/setting/widget/custom_elevated_button.dart';
import 'package:icecream/setting/widget/custom_modal.dart';
import 'package:icecream/setting/widget/custom_show_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http_parser/http_parser.dart';

class ProfileImage extends StatefulWidget {
  final int user_id;
  final double width;
  final double height;
  final String? imgUrl;
  final bool detail;
  const ProfileImage(
      {super.key,
      required this.width,
      required this.height,
      this.imgUrl,
      this.detail = false,
      required this.user_id});

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  XFile? _image; // 이미지를 담을 변수 선언
  final ImagePicker picker = ImagePicker(); // ImagePicker 초기화

  // 이미지를 가져오는 함수
  Future getImage(ImageSource imageSource, StateSetter setModalState) async {
    // pickedFile에 ImagePricker로 가져온 이미지가 담김
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setModalState(() {
        _image = XFile(pickedFile.path);
      });
    } else {
      return null;
    }
  }

  // 이미지 프로필 수정 api
  Future<ResponseModel> postImgUrl() async {
    final dio = CustomDio().createDio();
    final userRepository = UserRespository(dio);
    if (_image == null) {
      throw Exception("이미지를 등록해주세요");
    }
    File newImage = File(_image!.path);
    MultipartFile multipartFile = await MultipartFile.fromFile(newImage.path,
        filename: newImage.path.split('/').last, contentType: MediaType("image", "jpeg"));
    print('111111111111111111 $newImage');
    ResponseModel response = await userRepository.postImage(
        user_id: widget.user_id, profile_image: multipartFile!);

    return response;
  }

  void changeImgUrl() async {
    ResponseModel response;
    response = await postImgUrl();

    if (response.status == 200) {
      if (response.data != null) {
        Provider.of<UserProvider>(context, listen: false).setProfileImage =
            response.data!;
      }
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
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: widget.imgUrl != null && widget.imgUrl!.isNotEmpty
              ? Image(
                  image: NetworkImage(widget.imgUrl!),
                  fit: BoxFit.cover,
                  width: widget.width,
                  height: widget.height,
                )
              : Icon(
                  Icons.account_circle_rounded,
                  color: AppColors.profile_black.withOpacity(0.5),
                  size: (widget.width + 5),
                ),
        ),
        if (widget.detail)
          Positioned(
            bottom: 5,
            right: 5,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: AppColors.profile_black.withOpacity(0.5),
              ),
              child: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // 모달을 열기 전에 _image를 null로 설정
                  setState(() {
                    _image = null;
                  });
                  showCustomModal(
                    context,
                    '프로필 사진 수정',
                    StatefulBuilder(
                      builder:
                          (BuildContext context, StateSetter setModalState) {
                        return Column(
                          children: [
                            SizedBox(height: 50.0),
                            _buildPhoto(setModalState),
                            SizedBox(height: 50.0),
                            _buildButton(setModalState),
                            SizedBox(height: 16.0),
                            CustomElevatedButton(
                              child: '저장',
                              onPressed: () {
                                changeImgUrl();
                              },
                            ),
                            SizedBox(height: 10.0),
                            CustomElevatedButton(
                              backgroundColor: AppColors.input_border_color,
                              child: '삭제',
                              onPressed: () {
                                Provider.of<UserProvider>(context,
                                        listen: false)
                                    .setProfileImage = '';
                                context.pop();
                              },
                            ),
                          ],
                        );
                      },
                    ),
                    480.0,
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPhoto(StateSetter setModalState) {
    return _image != null
        ? ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.file(
              height: 200,
              width: 200,
              File(_image!.path),
              fit: BoxFit.cover,
            ),
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Container(
              height: 200,
              width: 200,
              color: AppColors.profile_black.withOpacity(0.5),
            ),
          );
  }

  Widget _buildButton(StateSetter setModalState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: CustomElevatedButton(
            onPressed: () {
              getImage(ImageSource.camera, setModalState);
            }, // 카메라에서 찍은 사진 가져오기
            child: '카메라',
            backgroundColor: AppColors.input_border_color,
          ),
          flex: 1,
        ),
        SizedBox(
          width: 16.0,
        ),
        Flexible(
          child: CustomElevatedButton(
            onPressed: () {
              getImage(ImageSource.gallery, setModalState);
            }, // 갤러리에서 사진 가져오기
            child: '갤러리',
            backgroundColor: AppColors.input_border_color,
          ),
          flex: 1,
        ),
      ],
    );
  }
}
