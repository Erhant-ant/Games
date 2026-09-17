class StoreCategory {
  const StoreCategory({required this.id, required this.title, required this.imageUrl});
  final String id;
  final String title;
  final String imageUrl;
}

class StoreProduct {
  const StoreProduct({
    required this.id,
    required this.name,
    required this.weight,
    required this.price,
    this.oldPrice,
    required this.imageUrl,
    required this.categoryId,
    this.optionsGroup,
    this.isMainOption = true,
  });
  final String id;
  final String name;
  final String weight;
  final String price;
  final String? oldPrice;
  final String imageUrl;
  final String categoryId;
  final String? optionsGroup;
  final bool isMainOption;
}

enum ProductSortOption {
  featured,
  priceAsc,
  priceDesc,
  bestSellers,
  newest,
}

class ProductFilterModel {
  const ProductFilterModel({
    this.minPrice,
    this.maxPrice,
    this.inStockOnly = false,
    this.selectedCategoryIds = const {},
  });

  final double? minPrice;
  final double? maxPrice;
  final bool inStockOnly;
  final Set<String> selectedCategoryIds;

  ProductFilterModel copyWith({
    double? minPrice,
    double? maxPrice,
    bool? inStockOnly,
    Set<String>? selectedCategoryIds,
  }) {
    return ProductFilterModel(
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      inStockOnly: inStockOnly ?? this.inStockOnly,
      selectedCategoryIds: selectedCategoryIds ?? this.selectedCategoryIds,
    );
  }

  bool get isActive => minPrice != null || maxPrice != null || inStockOnly || selectedCategoryIds.isNotEmpty;
  
  int get activeFilterCount {
    int count = 0;
    if (minPrice != null || maxPrice != null) count++;
    if (inStockOnly) count++;
    if (selectedCategoryIds.isNotEmpty) count++;
    return count;
  }
}
