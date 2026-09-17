import 'store_models.dart';

class CartItem {
  const CartItem({required this.product, required this.quantity});

  final StoreProduct product;
  final int quantity;

  CartItem copyWith({int? quantity}) => CartItem(product: product, quantity: quantity ?? this.quantity);
}
