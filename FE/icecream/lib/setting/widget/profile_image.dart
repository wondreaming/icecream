import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:icecream/com/const/color.dart';
import 'package:icecream/setting/widget/custom_elevated_button.dart';
import 'package:icecream/setting/widget/custom_modal.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImage extends StatefulWidget {
  final double width;
  final double height;
  final String? imgUrl;
  final bool detail;
  const ProfileImage(
      {super.key,
      required this.width,
      required this.height,
      this.imgUrl,
      this.detail = false});

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  XFile? _image; // 이미지를 담을 변수 선언
  final ImagePicker picker = ImagePicker(); // ImagePicker 초기화

  // 이미지를 가져오는 함수
  Future getImage(ImageSource imageSource) async {
    // pickedFile에 ImagePricker로 가져온 이미지가 담김
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path);
      });
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: widget.imgUrl != null && widget.imgUrl!.isNotEmpty
              ? Image.asset(
                  widget.imgUrl!,
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
            bottom: 15,
            right: 15,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: AppColors.profile_black.withOpacity(0.5),
              ),
              child: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  customModal(
                    context,
                    '프로필 사진 수정',
                    Column(
                      children: [
                        SizedBox(height: 50.0),
                        _buildPhoto(),
                        SizedBox(height: 50.0),
                        _buildButton(),
                        SizedBox(height: 16.0),
                        CustomElevatedButton(
                          child: '저장',
                          onPressed: () {},
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPhoto() {
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

  Widget _buildButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: CustomElevatedButton(
            onPressed: () {
              getImage(ImageSource.camera);
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
              getImage(ImageSource.gallery);
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
