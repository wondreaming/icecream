import 'package:flutter/material.dart';

class Child {
  final int userId;
  final String profileImage;
  final String username;
  final String phoneNumber;

  Child({
    required this.userId,
    required this.profileImage,
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
      'profile_image': profileImage,
      'username': username,
      'phone_number': phoneNumber,
    };
  }
}

class UserProvider extends ChangeNotifier {
  String _username = '';
  String _loginId = '';
  String _phoneNumber = '';
  String _profileImage = '';
  bool _isParent = false;
  List<Child> _children = [];

  String get username => _username;
  String get loginId => _loginId;
  String get phoneNumber => _phoneNumber;
  String get profileImage => _profileImage;
  bool get isParent => _isParent;
  List<Child> get children => _children;

  void setUserData(Map<String, dynamic> userData) {
    _username = userData['username'];
    _loginId = userData['login_id'] ?? '';
    _phoneNumber = userData['phone_number'];
    _profileImage = userData['profile_image'] ?? '';
    _isParent = userData.containsKey('children');

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
    notifyListeners();
  }
}