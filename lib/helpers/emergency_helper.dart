import 'package:flutter/services.dart';

class EmergencyHelper {
  static const MethodChannel _callChannel = MethodChannel('emergency/call');

  static Future<void> callAdmin(String phoneNumber) async {
    try {
      await _callChannel.invokeMethod('callNumber', {'number': phoneNumber});
    } catch (e) {
      print("Error calling admin: $e");
    }
  }
}
