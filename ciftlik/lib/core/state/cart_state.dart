import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/store_models.dart';

class CartState extends ValueNotifier<List<CartItem>> {
  CartState._() : super([]);
  static final CartState instance = CartState._();

  int get count => value.fold(0, (sum, item) => sum + item.quantity);

  void add(StoreProduct product, [int quantity = 1]) {
    final items = List<CartItem>.from(value);
    final index = items.indexWhere((item) => item.product.id == product.id);
    if (index == -1) {
      items.add(CartItem(product: product, quantity: quantity));
    } else {
      final current = items[index];
      items[index] = current.copyWith(quantity: current.quantity + quantity);
    }
    value = items;
  }

  void changeQuantity(CartItem item, int quantity) {
    final items = List<CartItem>.from(value);
    final index = items.indexOf(item);
    if (index == -1) return;
    items[index] = item.copyWith(quantity: quantity);
    value = items;
  }

  void remove(CartItem item) {
    final items = List<CartItem>.from(value);
    items.remove(item);
    value = items;
  }

  void clear() {
    value = [];
  }
}
