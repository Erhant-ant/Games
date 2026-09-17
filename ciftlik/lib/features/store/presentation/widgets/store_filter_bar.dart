import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/models/store_models.dart';

class StoreFilterBar extends StatelessWidget {
  const StoreFilterBar({
    super.key,
    required this.currentSort,
    required this.onSortChanged,
    required this.onFilterTap,
    this.activeFilterCount = 0,
  });

  final ProductSortOption currentSort;
  final ValueChanged<ProductSortOption> onSortChanged;
  final VoidCallback onFilterTap;
  final int activeFilterCount;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            OutlinedButton.icon(
              onPressed: onFilterTap,
              icon: const Icon(Icons.tune, size: 18),
              label: Text(strings.isTurkish ? 'Filtrele' : 'Filter'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF2C4C3B),
                side: const BorderSide(color: Color(0xFF2C4C3B)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            if (activeFilterCount > 0)
              Positioned(
                right: -6,
                top: -6,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Color(0xFFC04F43), // AppColors.terracotta
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    activeFilterCount.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
        DropdownButtonHideUnderline(
          child: DropdownButton<ProductSortOption>(
            value: currentSort,
            icon: const Icon(Icons.sort_rounded, color: Color(0xFF2C4C3B), size: 20),
            style: const TextStyle(color: Color(0xFF1D1B20), fontWeight: FontWeight.w600, fontSize: 13),
            items: ProductSortOption.values.map((option) {
              String text = '';
              switch (option) {
                case ProductSortOption.featured: text = strings.isTurkish ? 'Öne Çıkanlar' : 'Featured'; break;
                case ProductSortOption.priceAsc: text = strings.isTurkish ? 'Fiyat: Düşükten Yükseğe' : 'Price: Low to High'; break;
                case ProductSortOption.priceDesc: text = strings.isTurkish ? 'Fiyat: Yüksekten Düşüğe' : 'Price: High to Low'; break;
                case ProductSortOption.bestSellers: text = strings.isTurkish ? 'Çok Satanlar' : 'Best Sellers'; break;
                case ProductSortOption.newest: text = strings.isTurkish ? 'En Yeniler' : 'Newest'; break;
              }
              return DropdownMenuItem(value: option, child: Text(text));
            }).toList(),
            onChanged: (val) {
              if (val != null) onSortChanged(val);
            },
          ),
        ),
      ],
    );
  }
}
