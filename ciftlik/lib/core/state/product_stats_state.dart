import 'dart:async';
import 'package:flutter/foundation.dart';

class ProductStatsState extends ValueNotifier<bool> {
  // Singleton instance
  static final ProductStatsState instance = ProductStatsState._();

  Timer? _timer;

  ProductStatsState._() : super(true) {
    _startTimer();
  }

  void _startTimer() {
    // Toggles between true and false every 4 seconds
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      value = !value;
    });
  }

  // Deterministic count generators based on product ID
  int getCartCount(String productId) {
    return (productId.hashCode % 42) + 12; // e.g. 12 to 53
  }

  int getViewCount(String productId) {
    return (productId.hashCode % 150) + 85; // e.g. 85 to 234
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
