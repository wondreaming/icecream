import 'package:flutter/material.dart';

class Destination extends ChangeNotifier {
  late String address  = '주소를 입력해주세요';
  late double latitude;
  late double longitude;

  void changeTheValue(String newAddress, double newLatitude, double newLongitude){
    address = newAddress;
    latitude = newLatitude;
    longitude = newLongitude;
    notifyListeners();
  }
}


