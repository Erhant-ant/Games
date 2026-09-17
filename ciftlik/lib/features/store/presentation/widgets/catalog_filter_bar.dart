import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/models/store_models.dart';

class CatalogFilterBar extends StatelessWidget {
  const CatalogFilterBar({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onSelected,
    this.currentSortOption = ProductSortOption.featured,
    this.onSortChanged,
  });

  final List<StoreCategory> categories;
  final String? selectedCategoryId;
  final ValueChanged<String?> onSelected;
  final ProductSortOption currentSortOption;
  final ValueChanged<ProductSortOption>? onSortChanged;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    
    String getSortText(ProductSortOption option) {
      switch (option) {
        case ProductSortOption.featured:
          return strings.isTurkish ? 'Öne Çıkanlar' : 'Featured';
        case ProductSortOption.priceAsc:
          return strings.isTurkish ? 'Fiyat: Düşükten Yükseğe' : 'Price: Low to High';
        case ProductSortOption.priceDesc:
          return strings.isTurkish ? 'Fiyat: Yüksekten Düşüğe' : 'Price: High to Low';
        case ProductSortOption.bestSellers:
          return strings.isTurkish ? 'Çok Satanlar' : 'Best Sellers';
        case ProductSortOption.newest:
          return strings.isTurkish ? 'En Yeniler' : 'Newest';
      }
    }

    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChip(
                  selected: selectedCategoryId == null,
                  label: Text(strings.text('all')),
                  onSelected: (_) => onSelected(null),
                ),
                const SizedBox(width: 8),
                ...categories.map(
                  (category) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: selectedCategoryId == category.id,
                      label: Text(category.title),
                      selectedColor: AppColors.sage,
                      onSelected: (_) => onSelected(category.id),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
