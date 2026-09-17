import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/models/cart_item.dart';

class CartDrawer extends StatelessWidget {
  const CartDrawer({super.key, required this.items, required this.onQuantityChanged, required this.onRemove, required this.onCheckout});

  final List<CartItem> items;
  final void Function(CartItem item, int quantity) onQuantityChanged;
  final ValueChanged<CartItem> onRemove;
  final VoidCallback onCheckout;

  int get _subtotal => items.fold(0, (sum, item) => sum + _price(item.product.price) * item.quantity);

  int _price(String value) => int.parse(value.replaceAll(RegExp(r'[^0-9]'), ''));

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Column(
            children: [
              Row(
                children: [
                  Text(strings.text('cart'), style: Theme.of(context).textTheme.headlineMedium),
                  const Spacer(),
                  IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close)),
                ],
              ),
              const Divider(height: 28),
              Expanded(
                child: items.isEmpty
                    ? _EmptyCart(strings: strings)
                    : ListView.separated(
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const Divider(height: 24),
                        itemBuilder: (_, index) => _CartLine(item: items[index], onQuantityChanged: onQuantityChanged, onRemove: onRemove),
                      ),
              ),
              if (items.isNotEmpty) ...[
                const Divider(height: 30),
                Row(children: [Text(strings.text('subtotal'), style: const TextStyle(fontWeight: FontWeight.bold)), const Spacer(), Text('₺ $_subtotal', style: const TextStyle(color: AppColors.forest, fontSize: 20, fontWeight: FontWeight.bold))]),
                const SizedBox(height: 7),
                Align(alignment: Alignment.centerLeft, child: Text(strings.text('shippingAtCheckout'), style: const TextStyle(color: Colors.black54, fontSize: 12))),
                const SizedBox(height: 18),
                SizedBox(width: double.infinity, child: FilledButton(onPressed: onCheckout, style: FilledButton.styleFrom(backgroundColor: AppColors.forest, padding: const EdgeInsets.symmetric(vertical: 16)), child: Text(strings.text('checkout')))),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart({required this.strings});
  final AppLocalizations strings;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.shopping_bag_outlined, color: AppColors.olive, size: 54),
      const SizedBox(height: 16),
      Text(strings.text('emptyCart'), style: const TextStyle(color: AppColors.forest, fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Text(strings.text('emptyCartDetail'), textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54)),
    ]),
  );
}

class _CartLine extends StatelessWidget {
  const _CartLine({required this.item, required this.onQuantityChanged, required this.onRemove});
  final CartItem item;
  final void Function(CartItem item, int quantity) onQuantityChanged;
  final ValueChanged<CartItem> onRemove;

  @override
  Widget build(BuildContext context) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
    ClipRRect(borderRadius: BorderRadius.circular(10), child: SizedBox(width: 68, height: 68, child: Image.network(item.product.imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: AppColors.sand)))),
    const SizedBox(width: 12),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(item.product.name, style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.bold)),
      const SizedBox(height: 3),
      Text('${item.product.price} · ${item.product.weight}', style: const TextStyle(color: Colors.black54, fontSize: 12)),
      const SizedBox(height: 10),
      Row(children: [
        _SmallQuantityButton(icon: Icons.remove, onTap: item.quantity > 1 ? () => onQuantityChanged(item, item.quantity - 1) : null),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 11), child: Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold))),
        _SmallQuantityButton(icon: Icons.add, onTap: () => onQuantityChanged(item, item.quantity + 1)),
        const Spacer(),
        IconButton(onPressed: () => onRemove(item), icon: const Icon(Icons.delete_outline, size: 19), color: AppColors.terracotta, visualDensity: VisualDensity.compact),
      ]),
    ])),
  ]);
}

class _SmallQuantityButton extends StatelessWidget {
  const _SmallQuantityButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(6), child: Ink(padding: const EdgeInsets.all(4), decoration: BoxDecoration(border: Border.all(color: const Color(0xFFDDD6C9)), borderRadius: BorderRadius.circular(6)), child: Icon(icon, size: 15, color: onTap == null ? Colors.black26 : AppColors.forest)));
}
