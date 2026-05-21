import 'package:safe_device/safe_device.dart';

class LocationSecurityService {
  static Future<bool> isMockLocationDetected() async {
    try {
      // 1. Detecta si una app está simulando la ubicación actualmente
      bool isMock = await SafeDevice.isMockLocation;
      
      // 2. Detecta si el modo de desarrollo está activo (común para usar Fake GPS)
      bool isDevMode = await SafeDevice.isDevelopmentModeEnable;

      // Retornamos true si cualquiera de las dos es positiva
      // Nota: Algunos usuarios legítimos usan modo dev, puedes quitar isDevMode si lo ves muy estricto.
      return isMock || isDevMode;
    } catch (e) {
      return false;
    }
  }
}
