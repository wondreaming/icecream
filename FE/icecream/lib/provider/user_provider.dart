import 'package:flutter/material.dart';
import 'package:icecream/setting/widget/profile_image.dart';

class Child {
  final int userId;
  final String? profileImage;
  final String username;
  final String phoneNumber;

  Child({
    required this.userId,
    this.profileImage,
    required this.username,
    required this.phoneNumber,
  });

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      userId: json['user_id'],
      profileImage: json['profile_image'],
      username: json['username'],
      phoneNumber: json['phone_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'profile_image': profileImage ?? '',
      'username': username,
      'phone_number': phoneNumber,
    };
  }
}

class UserProvider extends ChangeNotifier {
  String _username = '';
  String _loginId = '';
  String _phoneNumber = '';
  String? _profileImage = '';
  bool _isParent = false;
  bool _isLoggedIn = false;
  List<Child> _children = [];
  int _userId = 0; // userId 추가

  String get username => _username;
  String get loginId => _loginId;
  String get phoneNumber => _phoneNumber;
  String? get profileImage => _profileImage;
  bool get isParent => _isParent;
  bool get isLoggedIn => _isLoggedIn;
  List<Child> get children => _children;
  int get userId => _userId; // userId getter 추가


  // profileImage에 대한 setter 추가
  set setProfileImage(String newImage) {
    if (_profileImage != newImage) {
      _profileImage = newImage;
      notifyListeners();
    }
  }

  // phoneNumber에 대한 setter 추가
  set setPhoneNumber(String newPhoneNumber) {
    if (_phoneNumber != newPhoneNumber) {
      _phoneNumber = newPhoneNumber;
      notifyListeners();
    }
  }

  // 이름에 대한 setter 추가
  set setUsername(String newUsername) {
    if (_username != newUsername) {
      _username = newUsername;
      notifyListeners();
    }
  }

  void setUserData(Map<String, dynamic> userData) {
    _username = userData['username'];
    _loginId = userData['login_id'] ?? '';
    _phoneNumber = userData['phone_number'];
    _profileImage = userData['profile_image'] ?? '';
    _isParent = userData.containsKey('children');
    _isLoggedIn = true;
    _userId = userData['user_id']; // userId 설정

    if (_isParent) {
      _children = (userData['children'] as List<dynamic>)
          .map((child) => Child.fromJson(child))
          .toList();
    } else {
      _children = [];
    }
    notifyListeners();
  }

  void clearUserData() {
    _username = '';
    _loginId = '';
    _phoneNumber = '';
    _profileImage = '';
    _children = [];
    _isParent = false;
    _isLoggedIn = false;
    _userId = 0; // userId 초기화
    notifyListeners();
  }
  // 자녀 정보 업데이트
  void updateChildren(List<Child> children) {
    _children = children;
    notifyListeners();
  }
}
