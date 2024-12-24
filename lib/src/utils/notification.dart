import 'dart:math';

const characters =
    "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

String randomString(int length) {
  return List.generate(
      length, (_) => characters[Random().nextInt(characters.length)]).join();
}

class NotificationController {
  // singleton
  static final NotificationController _instance =
      NotificationController._internal();
  factory NotificationController() {
    return _instance;
  }

  NotificationController._internal();

  String? _deviceToken;
  String? _apnsToken;

  Future<String> get deviceToken async {
    if (_deviceToken != null) {
      return _deviceToken!;
    }

    return _deviceToken ?? "";
  }

  Future<String?> get apnsToken async {
    if (_apnsToken != null) {
      return _apnsToken!;
    }

    return null;
  }
}
