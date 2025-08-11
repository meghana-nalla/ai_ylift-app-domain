import 'package:YLift/core/constants/color.dart';
import 'package:YLift/core/controllers/z-index_export.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:YLift/presentation/pages/mobile/categories/components/filterable_products_page.dart';
import 'package:YLift/presentation/pages/mobile/categories/components/vendor_and_brands_filter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterDialog extends StatefulWidget {
  final List<ProductBrand> selectedBrands;
  final List<ProductCategory> selectedCategories;
  final Function(ProductBrand) toggleBrand;
  final Function(ProductCategory) toggleCategory;
  final Function() closeDialog;
  final FilterType currentFilterType;
  final List<ProductSimple> allProducts;
  final void Function(Set<ProductBrand> brands) onBrandSelected;
  final void Function(Set<ProductCategory> categories) onCategorySelected;

  const FilterDialog({
    Key? key,
    required this.selectedBrands,
    required this.selectedCategories,
    required this.toggleBrand,
    required this.toggleCategory,
    required this.closeDialog,
    required this.currentFilterType,
    required this.allProducts,
    required this.onBrandSelected,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  final GlobalController controller = Get.find<GlobalController>();
  late List<bool> _isExpandedList;
  late List<ProductBrand> _selectedBrands;
  late List<ProductCategory> _selectedCategories;
  late List<int> _selectedBrandsId;
  late List<int> _selectedCategoriesId;

  ValueChanged<int> totalSelected = (value) => 0;

  @override
  void initState() {
    super.initState();
    _isExpandedList = [
      widget.currentFilterType == FilterType.Brands,
      widget.currentFilterType == FilterType.Categories,
      false
    ];
    _selectedBrands = List.from(widget.selectedBrands);
    _selectedCategories = List.from(widget.selectedCategories);
  }

  void _toggleExpanded(int index) {
    setState(() {
      _isExpandedList[index] = !_isExpandedList[index];
    });
  }

  int getFilteredProductCount() {
    _selectedBrandsId = _selectedBrands.map((e) => e.brandId!).toList();
    _selectedCategoriesId = _selectedCategories.map((e) => e.categoryId).toList();
    var total = widget.allProducts.where((product) {
      bool brandMatch = _selectedBrandsId.isEmpty || _selectedBrandsId.contains(product.brandId);
      bool categoryMatch =
          _selectedCategoriesId.isEmpty || product.categoryId!.any((productCategoryId) =>
              _selectedCategoriesId.contains(productCategoryId));
      return brandMatch && categoryMatch;
    }).length;
    return total;
  }

  void _handleBrandSelected(Set<ProductBrand> brands) {
    setState(() {
      _selectedBrands = brands.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
              '${widget.currentFilterType == FilterType.Brands ? 'Brand' : 'Category'} Filter',
              style: TextStyle(fontSize: 16)),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              // Close the dialog
              widget.closeDialog();
            },
          ),
        ),
        body: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  children: [
                    Wrap(
                      spacing: 8,
                      children: _selectedBrands.map((brand) {
                        //bool isSelected = widget.selectedBrands.contains(brand);
                        return FilterChip(
                          label: Text(brand.name, style: TextStyle(
                              color: Colors.white,
                              fontSize: 13)),
                          selected: true,
                          onSelected: (_) => widget.toggleBrand(brand),
                          backgroundColor: Colors.grey[300],
                          selectedColor: YLiftColor.orange,
                        );
                      }).toList(),
                    ),
                    Wrap(
                      spacing: 8,
                      children: _selectedCategories.map((category) {
                        return FilterChip(
                          label: Text(category.name, style: TextStyle(fontSize: 13)),
                          selected: true,
                          onSelected: (_) => widget.toggleCategory(category),
                          backgroundColor: Colors.grey[300],
                          selectedColor: YLiftColor.orange,
                        );
                      }).toList(),
                    ),
                  ]
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: ExpansionPanelList(
                  elevation: 1,
                  expandedHeaderPadding: EdgeInsets.zero,
                  expansionCallback: (int index, bool isExpanded) {
                    _toggleExpanded(index);
                  },
                  children: [
                    if (widget.currentFilterType == FilterType.Brands)
                      ExpansionPanel(
                        backgroundColor: Colors.white,
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return const ListTile(
                            title: Text('VENDORS & BRANDS', style: TextStyle(fontSize: 16)),
                          );
                        },
                        body: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: VendorAndBrandsFilter(
                            allProducts: widget.allProducts,
                            selectedBrands: _selectedBrands.toSet(),
                            onSelected: _handleBrandSelected,
                            totalProducts: totalSelected,
                          ),
                        ),
                        isExpanded: _isExpandedList[0],
                      ),
                    if (widget.currentFilterType == FilterType.Categories)
                      ExpansionPanel(
                        backgroundColor: Colors.white,
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return const ListTile(
                            title: Text('Categories'),
                          );
                        },
                        body: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Column(
                            children: [
                              ...controller.categories.map((category) {
                                bool isSelected = _selectedCategories.contains(category);
                                return CheckboxListTile(
                                  title: Text(category.name,
                                      style: TextStyle(fontSize:13)
                                  ),
                                  value: isSelected,
                                  onChanged: (bool? newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                        if (newValue) {
                                          _selectedCategories.add(category);
                                        } else {
                                          _selectedCategories.remove(category);
                                        }
                                      });
                                      //widget.onCategorySelected(_selectedCategories.toSet());
                                      getFilteredProductCount();
                                    }
                                  },
                                );
                              }).toList(),
                              // Sub-categories (example, you'll need to get this data)
                            ],
                          ),
                        ),
                        isExpanded: _isExpandedList[1],
                      ),
                  ],
                ),
              ),
            ),
            //Result button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  widget.onBrandSelected(_selectedBrands.toSet());
                  widget.onCategorySelected(_selectedCategories.toSet());
                  widget.closeDialog();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: YLiftColor.orange,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: Text('Show ${getFilteredProductCount()} results'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}