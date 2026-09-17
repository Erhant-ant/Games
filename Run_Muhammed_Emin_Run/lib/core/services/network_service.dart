import 'dart:io';
import 'package:flutter/foundation.dart';

class NetworkService {
  static Future<bool> hasInternetConnection() async {
    if (kIsWeb) {
      // Web üzerinde dart:io çalışmadığı için şimdilik true dönüyoruz
      // (Gerçek internet kontrolü için web'de http paketi gerekir)
      return true;
    }

    try {
      final result = await InternetAddress.lookup('google.com').timeout(const Duration(seconds: 3));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } catch (_) { // Tüm hataları (timeout vb.) yakala
      return false;
    }
    return false;
  }
}
