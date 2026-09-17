import 'package:flutter/foundation.dart';

class FavoriteState extends ValueNotifier<Set<String>> {
  FavoriteState._() : super({});

  static final FavoriteState instance = FavoriteState._();

  bool isFavorite(String productId) => value.contains(productId);

  void toggleFavorite(String productId) {
    final newSet = Set<String>.from(value);
    if (newSet.contains(productId)) {
      newSet.remove(productId);
    } else {
      newSet.add(productId);
    }
    value = newSet;
  }
}
