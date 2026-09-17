import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/models/store_models.dart';
import '../../data/store_data.dart';

class FilterDrawer extends StatefulWidget {
  const FilterDrawer({
    super.key,
    required this.initialFilter,
    required this.onApply,
    this.showCategoryFilter = true,
  });

  final ProductFilterModel initialFilter;
  final ValueChanged<ProductFilterModel> onApply;
  final bool showCategoryFilter;

  @override
  State<FilterDrawer> createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer> {
  late double? _minPrice;
  late double? _maxPrice;
  late bool _inStockOnly;
  late Set<String> _selectedCategoryIds;

  final _minPriceController = TextEditingController();
  final _maxPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _minPrice = widget.initialFilter.minPrice;
    _maxPrice = widget.initialFilter.maxPrice;
    _inStockOnly = widget.initialFilter.inStockOnly;
    _selectedCategoryIds = Set.from(widget.initialFilter.selectedCategoryIds);

    if (_minPrice != null) _minPriceController.text = _minPrice.toString();
    if (_maxPrice != null) _maxPriceController.text = _maxPrice.toString();
  }

  void _apply() {
    final minVal = double.tryParse(_minPriceController.text);
    final maxVal = double.tryParse(_maxPriceController.text);

    widget.onApply(ProductFilterModel(
      minPrice: minVal,
      maxPrice: maxVal,
      inStockOnly: _inStockOnly,
      selectedCategoryIds: _selectedCategoryIds,
    ));
    Navigator.of(context).pop();
  }

  void _clear() {
    setState(() {
      _minPriceController.clear();
      _maxPriceController.clear();
      _inStockOnly = false;
      _selectedCategoryIds.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final categories = StoreData.categories(strings.isTurkish);

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(strings.isTurkish ? 'Filtreler' : 'Filters', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(strings.isTurkish ? 'Fiyat Aralığı' : 'Price Range', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _minPriceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Min (₺)',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _maxPriceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Max (₺)',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SwitchListTile(
                    title: Text(strings.isTurkish ? 'Sadece Stoktakiler' : 'In Stock Only', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    value: _inStockOnly,
                    activeColor: const Color(0xFF2C4C3B), // AppColors.forest
                    onChanged: (val) => setState(() => _inStockOnly = val),
                    contentPadding: EdgeInsets.zero,
                  ),
                  if (widget.showCategoryFilter) ...[
                    const SizedBox(height: 24),
                    Text(strings.isTurkish ? 'Kategoriler' : 'Categories', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    ...categories.map((c) {
                      final isSelected = _selectedCategoryIds.contains(c.id);
                      return CheckboxListTile(
                        title: Text(c.title),
                        value: isSelected,
                        activeColor: const Color(0xFF2C4C3B),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (val) {
                          setState(() {
                            if (val == true) {
                              _selectedCategoryIds.add(c.id);
                            } else {
                              _selectedCategoryIds.remove(c.id);
                            }
                          });
                        },
                      );
                    }),
                  ],
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _clear,
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                      child: Text(strings.isTurkish ? 'Temizle' : 'Clear'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton(
                      onPressed: _apply,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF2C4C3B),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(strings.isTurkish ? 'Uygula' : 'Apply'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
