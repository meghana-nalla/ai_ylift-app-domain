import 'dart:async';
import 'package:YLift/core/constants/color.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/components/navigation/search_bar/popular_products_panel.dart';
import 'package:YLift/presentation/components/navigation/search_bar/product_suggestion_panel.dart';
import 'package:YLift/presentation/pages/desktop/grid_shopping/shop_all_page.dart';
import '../../../pages/mobile/search/popular_products_panel_mobile.dart';
import '../../../pages/mobile/search/product_suggestion_panel_mobile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class YLiftMobileSearchBar extends StatefulWidget {
  const YLiftMobileSearchBar({super.key});

  @override
  State<YLiftMobileSearchBar> createState() => _YLiftMobileSearchBarState();
}

class _YLiftMobileSearchBarState extends State<YLiftMobileSearchBar> {
  final global = Get.find<GlobalController>();
  final _searchKey = GlobalKey();
  final searchController = TextEditingController();
  OverlayEntry? _overlayEntry;
  Timer? _debounceTimer;
  String? _recentQuery;

  @override
  void initState() {
    super.initState();
    if (global.recentSearchQuery.value == 'ALL_PRODUCTS') {
      global.recentSearchQuery.value = "";
    }
    _recentQuery = global.recentSearchQuery.value;
    searchController.text = _recentQuery ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 32,
        ),
        child: SearchBar(
          key: _searchKey,
          controller: searchController,
          backgroundColor: const WidgetStatePropertyAll<Color>(Colors.white),
          shadowColor: const WidgetStatePropertyAll<Color>(Colors.white),
          shape: const WidgetStatePropertyAll<OutlinedBorder>(
            StadiumBorder(side: BorderSide(color: Colors.grey)),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 6.0, right: 8.0),
            child: Container(
              width: 30,
              height: 30,
              decoration: ShapeDecoration(
                color: YLiftColor.orange,
                shape: const OvalBorder(),
              ),
              child: const Icon(Icons.search, size: 16, color: Colors.white),
            ),
          ),
          hintText: (_recentQuery == null || _recentQuery!.isEmpty)
              ? "Search Products"
              : _recentQuery,
          textStyle: const WidgetStatePropertyAll(TextStyle(color: Colors.black)),
          onTap: () {
            if (_overlayEntry == null) {
              global.recentSearchQuery.value = _recentQuery ?? '';
              showProductsSuggestion();
            }
          },
          onChanged: (query) => _handleSearch(query),
          onSubmitted: (query) => _handleEnterKey(query: query),
        ),
      ),
    );
  }

  void _handleEnterKey({String? query}) {
    closePopUp();
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
      global.searchResultProducts.value = global.allProducts.value.products.where((product) {
        final name = product.name.toLowerCase();
        final brand = product.brandName?.toLowerCase() ?? '';
        return name.contains(query) || brand.contains(query) || product.tags!.contains(query);
      }).toList();

      if (_overlayEntry == null) showProductsSuggestion();
    });
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
      builder: (context) => Positioned(
        left: 16,
        top: position.dy + size.height + 8,
        width: MediaQuery.of(context).size.width - 32,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(12),
          child: Obx(() => global.searchResultProducts.isEmpty
              ? PopularProductsPanelMobile(
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
              : ProductsSuggestionPanelMobile(
            products: global.searchResultProducts,
            onProductSelected: (product) async {
              closePopUp();
              await global.vroute.navigateToProduct(product.productId!);
            },
            onSeeAllProducts: () {
              closePopUp();
              _handleEnterKey(query: searchController.text);
            },
          )),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _overlayEntry?.remove();
    searchController.dispose();
    super.dispose();
  }
}


