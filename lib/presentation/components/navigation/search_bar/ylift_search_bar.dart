import 'dart:async';

import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:YLift/presentation/components/navigation/search_bar/popular_products_panel.dart';
import 'package:YLift/presentation/components/navigation/search_bar/product_suggestion_panel.dart';
import 'package:YLift/presentation/pages/desktop/grid_shopping/shop_all_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:galaxy_models/galaxy_models.dart';

/// THIS IS THE DESKTOP SEARCH BAR!!!
class YLiftSearchBar extends StatefulWidget {
  const YLiftSearchBar({super.key});

  @override
  State<YLiftSearchBar> createState() => _YLiftSearchBarState();
}

class _YLiftSearchBarState extends State<YLiftSearchBar> {
  final global = Get.find<GlobalController>();
  final _searchKey = GlobalKey();
  final searchController = TextEditingController();
  OverlayEntry? _overlayEntry;
  Timer? _debounceTimer;

  String? _recentQuery;

  void _initializeRecentQuery() {
    if (global.recentSearchQuery.value == 'ALL_PRODUCTS') {
      global.recentSearchQuery.value = "";
    }
    _recentQuery = global.recentSearchQuery.value;
    return;
  }

  @override
  void initState() {
    super.initState();
    _initializeRecentQuery();
    searchController.text = _recentQuery ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      key: _searchKey,
      controller: searchController,
      backgroundColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
      shadowColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
      shape: const WidgetStatePropertyAll<OutlinedBorder>(StadiumBorder(side: BorderSide(color: Colors.white))),
      leading: const Icon(Icons.search, color: Colors.white),
      hintText: (_recentQuery == null || _recentQuery!.isEmpty) ? "Search..." : _recentQuery,
      textStyle: const WidgetStatePropertyAll(TextStyle(color: Colors.white)),
      onTap: () {
        if (_overlayEntry == null) {
          global.recentSearchQuery.value = _recentQuery ?? '';
          showProductsSuggestion();
        }
      },
      onChanged: (query) => _handleSearch(query),
      onSubmitted: (query) => _handleEnterKey(query: query),
    );
  }

  void _handleEnterKey({String? query}) {
    closePopUp(); // Close the overlay after handling the enter key
    if (query == null || query.isEmpty || global.searchResultProducts.isEmpty) {
      _handleEmptySearchSubmit();
    } else {
      global.recentSearchQuery.value = query;
      _handleSearchSubmit(query);
    }
  }

  void _handleEmptySearchSubmit() {
    global.recentSearchQuery.value = 'ALL_PRODUCTS';
    if (global.vroute.currentRoute.value == '/shop/all') {
      Get.offAll(() => ShopAllPage());
    }
    global.vroute.navigateTo('/shop/all', extra: 'query=ALL_PRODUCTS');
    setState(() {});
  }

  void _handleSearchSubmit(String query) {
    if (global.vroute.currentRoute.value == '/shop/all') {
      Get.offAll(() => ShopAllPage());
    }
    global.vroute.navigateTo('/shop/all', extra: ('query=$query'));
    setState(() {});
  }

  int? _getCategoryIdFromQuery(String query) {
    final ProductCategory? category = global.categories.firstWhereOrNull((e) => e.name.toLowerCase().contains(query));
    if (category != null) {
      return category.categoryId;
    }
    return null;
  }

  int? _getVendorIdFromQuery(String query) {
    final VendorSimple? vendor = global.vendors.firstWhereOrNull((e) => e.name.toLowerCase().contains(query));
    if (vendor != null) {
      return vendor.vendorId;
    }
    return null;
  }

  void _resetSearch() {
    global.searchResultProducts.clear();
    setState(() {
      _recentQuery = "";
      searchController.text = "";
    });
    global.recentSearchQuery.value = "";
  }

  void _handleSearch(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 100), () {
      if (query.isEmpty) {
        _resetSearch();
        return;
      }

      if (global.allProducts.value.products.isEmpty) return;

      query = query.toLowerCase();
      global.searchResultProducts.value =
          global.allProducts.value.products.where((product) {
            final name = product.name.toLowerCase();
            final vendorId = _getVendorIdFromQuery(query) ?? 0;
            final categoryId = _getCategoryIdFromQuery(query) ?? 0;
            final brand = product.brandName?.toLowerCase() ?? '';

            return name.contains(query) ||
                (product.vendorId != null && product.vendorId! == vendorId) ||
                brand.contains(query) ||
                (product.categoryId?.isNotEmpty == true &&
                    product.categoryId!.contains(categoryId)) &&
                product.tags!.contains(query);
          }).toList();

      if (_overlayEntry == null) showProductsSuggestion();
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _overlayEntry?.remove();
    searchController.dispose();
    super.dispose();
  }

  void closePopUp() {
    setState(() {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  void showProductsSuggestion() {
    final renderBox = _searchKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: closePopUp,
            child: const ColoredBox(
              color: Colors.transparent,
              child: SizedBox.expand(),
            ),
          ),
          Positioned(
            left: position.dx,
            top: position.dy + size.height + 16,
            child: Obx(() => global.searchResultProducts.isEmpty
                ? PopularProductsPanel(
              products: global.allProducts.value.getBestSellers(limit: 4),
              onProductSelected: (product) async {
                closePopUp();
                await global.vroute.navigateToProduct(product.productId!);
              },
              onSeeAllProducts: () {
                _resetSearch();
                _handleEnterKey();
              },
            )
            : ProductsSuggestionPanel(
                products: global.searchResultProducts,
                onProductSelected: (product) async {
                  closePopUp();
                  await global.vroute.navigateToProduct(product.productId!);
                },
                onSeeAllProducts: () {
                  closePopUp();
                  _handleEnterKey(query: searchController.text);
                },
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }
}