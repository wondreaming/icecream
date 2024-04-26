import 'dart:async';
import 'dart:convert';
import 'package:dart_amqp/dart_amqp.dart';

class RabbitMQService {
  Client? _client;
  Channel? _channel;
  Exchange? _exchange;

  Future<void> initRabbitMQ() async {
    bool isConnected = false;
    int maxAttempts = 5;
    int attempts = 0;

    while (!isConnected && attempts < maxAttempts) {
      try {
        _client = Client(
          settings: ConnectionSettings(
            host: "10.0.2.2",
          ),
        );
        _channel = await _client!.channel();
        _exchange = await _channel!
            .exchange("icecream_ex", ExchangeType.DIRECT, durable: true);
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
  }

  Future<void> sendLocation(
      double latitude, double longitude, int userId) async {
    if (_exchange == null) {
      throw Exception('RabbitMQ not initialized.');
    }
    try {
      var locationData = {
        'userId': userId,
        'latitude': latitude,
        'longitude': longitude,
        'timestamp': DateTime.now().toIso8601String()
      };
      _exchange!.publish(jsonEncode(locationData), "ssafy123");
    } catch (e) {
      print('Failed to send message: $e');
      rethrow;
    }
  }

  void close() {
    _client?.close();
  }
}
