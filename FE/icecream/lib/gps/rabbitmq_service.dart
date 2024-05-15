import 'dart:async';
import 'dart:convert';
import 'package:dart_amqp/dart_amqp.dart';

class RabbitMQService {
  Client? _client;
  Channel? _channel;
  Exchange? _exchange;
  bool _isInitialized = false;

  Future<void> initRabbitMQ() async {
    bool isConnected = false;
    int maxAttempts = 5;
    int attempts = 0;

    while (!isConnected && attempts < maxAttempts) {
      try {
        _client = Client(
          settings: ConnectionSettings(host: "k10e202.p.ssafy.io", port: 5672
              // host: "10.0.2.2",  // 플러터 로컬 주소
              ),
        );
        _channel = await _client!.channel();
        _exchange = await _channel!
            .exchange("crosswalk.direct", ExchangeType.DIRECT, durable: true);
        isConnected = true;
      } catch (e) {
        attempts++;
        print('Attempt $attempts: Failed to connect to RabbitMQ: $e');
        await Future.delayed(const Duration(seconds: 2));
      }
    }

    if (!isConnected) {
      throw Exception(
          'Failed to connect to RabbitMQ after $maxAttempts attempts.');
    }
    _isInitialized = true;
  }
  bool get isInitialized => _isInitialized;
  Future<void> sendLocation(double latitude, double longitude, int userId, int destinationId) async {
    if (_exchange == null) {
      throw Exception('RabbitMQ not initialized.');
    }
    try {
      var locationData = {
        'user_id': userId,
        'latitude': latitude,
        'destination_id': destinationId,
        'longitude': longitude,
        'timestamp': DateTime.now().toIso8601String()
      };
      // 메시지를 RabbitMQ로 전송하기 전에 로그를 찍습니다.
      print('Sending location to RabbitMQ:');
      print('Latitude: $latitude');
      print('Longitude: $longitude');
      print('User ID: $userId');
      print('Destination ID: $destinationId');

      _exchange!.publish(jsonEncode(locationData), "Busan.ocean");
    } catch (e) {
      print('Failed to send message: $e');
      rethrow;
    }
  }

  void close() {
    _client?.close();
  }

  void startSendingLocation(double latitude, double longitude, int userId, int destinationId) {
    print("Starting periodic location updates...");
    if (!_isInitialized) {
      Timer.periodic(const Duration(seconds: 1), (timer) {
        print("Timer tick for sending location.");
        sendLocation(latitude, longitude, userId, destinationId);
      });
    }
  }
}
