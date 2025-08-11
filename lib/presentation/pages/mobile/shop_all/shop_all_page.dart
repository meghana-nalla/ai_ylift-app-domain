import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/models/simple/z-index_export.dart';
import 'package:YLift/presentation/components/mobile_footer.dart';
import 'package:YLift/presentation/components/products/mobile_product_tile.dart';
import 'package:YLift/presentation/pages/mobile/shop_all/components/mobile_brand_filter_sheet.dart';
import 'package:YLift/presentation/pages/mobile/shop_all/components/mobile_category_filter_sheet.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_models/core/constants/y_lift_color.dart';
import 'package:get/get.dart';

class MobileShopAllPage extends StatefulWidget {
  const MobileShopAllPage({super.key});

  @override
  State<MobileShopAllPage> createState() => _MobileShopAllPageState();
}

class _MobileShopAllPageState extends State<MobileShopAllPage> {
  final global = Get.find<GlobalController>();
  List<ProductCategory> get categories => global.categories;
  Set<int> categoryIds = {};
  Set<int> vendorIds = {};
  Set<int> brandIds = {};

  final searchController = TextEditingController();

  void fetchQuery() {
    final uri = Uri.base;
    final queryParameters = uri.queryParameters;
    if (queryParameters.containsKey('categoryIds')) {
      final categoryIdsParam = queryParameters['categoryIds'];
      if (categoryIdsParam != null) {
        categoryIds =
            categoryIdsParam
                .split(',')
                .map((id) => int.tryParse(id))
                .whereType<int>()
                .toSet();
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    searchController.addListener(() {
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchQuery();
    });
    super.initState();
  }

  Iterable<ProductSimple> get products {
    var allProducts = global.allProducts.value.products;
    if (categoryIds.isNotEmpty) {
      allProducts =
          allProducts.where((product) {
            return product.categoryId!.any(
              (categoryId) => categoryIds.contains(categoryId),
            );
          }).toList();
    }
    if (brandIds.isNotEmpty) {
      allProducts =
          allProducts.where((product) {
            return brandIds.contains(product.brandId);
          }).toList();
    }

    final searchText = searchController.text.trim().toLowerCase();
    if (searchText.isNotEmpty) {
      allProducts =
          allProducts.where((product) {
            final productName = product.name.trim().toLowerCase();
            final vendorName = product.vendorName?.trim().toLowerCase() ?? '';
            final brandName = product.brandName?.trim().toLowerCase() ?? '';
            final tags = product.tags ?? <String>[];
            final hasTag = tags.any(
              (tag) => tag.trim().toLowerCase().contains(searchText),
            );
            return productName.contains(searchText) ||
                vendorName.contains(searchText) ||
                brandName.contains(searchText) ||
                hasTag;
          }).toList();
    }
    return allProducts;
  }

  void showCategoryFilterSheet() {
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return MobileCategoryFilterSheet(
              categories: categories,
              selectedCategoryIds: categoryIds,
              onCategorySelected: (value) {
                setState(() {
                  categoryIds.contains(value)
                      ? categoryIds.remove(value)
                      : categoryIds.add(value);
                });
                setSheetState(() {});
              },
            );
          },
        );
      },
    );
  }

  void showBrandFilterSheet() {
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return MobileBrandFilterSheet(
              vendors: global.vendors
                  .where(
                    (vendor) => global.brands.any(
                      (brand) => brand.vendorIds.contains(vendor.vendorId),
                    ),
                  )
                  .toList(growable: false),
              brands: global.brands,
              selectedBrandIds: brandIds,
              onBrandsUpdated: (brandIds) {
                setState(() {
                  this.brandIds = brandIds;
                });
                setSheetState(() {});
              },
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              spacing: 8,
              children: [
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    suffixIcon:
                        searchController.text.isNotEmpty
                            ? IconButton(
                              onPressed: () {
                                searchController.clear();
                              },
                              icon: Icon(Icons.clear_rounded),
                            )
                            : null,
                    fillColor: Colors.white,
                    filled: true,
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search products',
                    isDense: true,
                  ),
                ),
                Row(
                  spacing: 16,
                  children: [
                    _DropdownButon(
                      count: categoryIds.length,
                      onTap: showCategoryFilterSheet,
                      label: 'Categories',
                    ),
                    _DropdownButon(
                      count: brandIds.length,
                      onTap: showBrandFilterSheet,
                      label: 'Brands',
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = constraints.maxWidth;
                final availableWidth = screenWidth - 16 - 8; // Subtract padding
                final crossAxisCount = availableWidth ~/ 160;

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 3 / 4.5,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  padding: const EdgeInsets.only(
                    left: 8,
                    right: 8,
                    bottom: 16,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products.elementAt(index);
                    return NewMobileProductTile(
                      product: product,
                      hidePrice: global.isAuthenticated.isFalse,
                      onProductTap:
                          () => global.vroute.navigateToProduct(
                            product.productId!,
                          ),
                    );
                  },
                );
              },
            ),
          ),
          CopyrightFooter(),
        ],
      ),
    );
  }
}

class _DropdownButon extends StatelessWidget {
  final int? count;
  final void Function() onTap;
  final String label;

  const _DropdownButon({
    super.key,
    this.count,
    required this.onTap,
    required this.label,
  });

  bool get hasCount => count != null && count! > 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: const StadiumBorder(),
        ),
        padding: EdgeInsets.only(
          left: hasCount ? 4 : 12,
          right: 8,
          top: 2,
          bottom: 2,
        ),
        child: Row(
          children: [
            if (hasCount) ...[
              Container(
                decoration: ShapeDecoration(
                  color: YLiftColor.orange,
                  shape: StadiumBorder(),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                child: Text(
                  '$count',
                  style: const TextStyle(fontSize: 10, color: Colors.white),
                ),
              ),
              const SizedBox(width: 6),
            ],
            Text(label),
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }
}
