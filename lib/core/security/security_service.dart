import 'package:flutter/services.dart';

class SecurityService {
  static const _channel = MethodChannel('com.example.login/security');

  static Future<void> setSecureMode(bool enable) async {
    try {
      await _channel.invokeMethod('setSecureMode', {'enable': enable});
    } on PlatformException catch (e) {
      // En un entorno de producción, podrías loguear esto a un servicio de errores
      print("Error configurando modo seguro: ${e.message}");
    }
  }
}
