import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/core/repositories/image_repository.dart';
import 'package:YLift/hardcodes/constants/peptide_subcategory.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:YLift/presentation/components/_complex/desktop_view/gap.dart';
import 'package:YLift/presentation/components/_complex/desktop_view/page_scaffold.dart';
import 'package:YLift/presentation/components/_complex/dialogs/add_to_cart_dialog.dart';
import 'package:YLift/presentation/components/shop/filter_list_view.dart';
import 'package:YLift/presentation/components/_complex/cards/product_card.dart';
import 'package:YLift/presentation/components/shop/vendor_and_brands_filter.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _noProductImageUrl = ImageRepository.getBannerImage(
  '7e514c99-1333-4318-88c8-c599a7856625',
);

enum ShopAllSortBy {
  bestSeller('BEST SELLER'),
  newArrivals('NEWEST ARRIVALS'),
  alphabeticalOrder('ALPHABETICAL ORDER'),
  priceLowToHigh('PRICE: LOW TO HIGH'),
  priceHighToLow('PRICE: HIGH TO LOW');

  final String label;
  const ShopAllSortBy(this.label);
}

class ShopAllPage extends StatefulWidget {
  const ShopAllPage({super.key});

  @override
  State<ShopAllPage> createState() => _ShopAllPageState();
}

class _ShopAllPageState extends State<ShopAllPage> {
  final global = Get.find<GlobalController>();

  int currentPage = 0;
  int numberOfPages = 1;

  String? queryString;
  final prefs = SharedPreferencesAsync();

  final scrollController = ScrollController();

  final peptideSubcategories = <ProductSubcategory>{};
  //final Set<ProductSubcategory> peptideSubcategories = <ProductSubcategory>{};
  void addPeptideSubcategory(ProductSubcategory subcategory) {
    print(subcategory);
    setState(() {
      if (peptideSubcategories.contains(subcategory)) {
        peptideSubcategories.remove(subcategory);
      } else {
        peptideSubcategories.add(subcategory);
        if (peptideSubcategories.containsAll(PeptideSubcategory.values)) {
          peptideSubcategories.clear();
        }
      }
    });
    final p = global.allProducts.value.getProductsByCategoryIds(
      categoryIds: [136],
    );
    final peptideProducts = p.where(
      (product) => peptideSubcategories.any((subcategory) {
        final subcategoryName = subcategory.name.toLowerCase();
        final productTags =
            product.tags?.map((tag) => tag.toLowerCase()) ?? <String>[];
        return productTags.contains(subcategoryName);
      }),
    );
    setState(() {
      if (peptideSubcategories.isEmpty) {
        products = global.allProducts.value.getProductsByCategoryIds(
          categoryIds: [136],
        );
      } else {
        products = peptideProducts.toList();
      }
      currentPage = 0;
      numberOfPages = (products!.length / _maxProductsShown).ceil();
      if (numberOfPages == 0) numberOfPages = 1;
    });
  }
  // void addPeptideSubcategory(ProductSubcategory subcategory) {
  //   setState(() {
  //     if (peptideSubcategories.contains(subcategory)) {
  //       peptideSubcategories.remove(subcategory);
  //     } else {
  //       peptideSubcategories.add(subcategory);
  //       final allPeptideSubs = global.subcategories.where(
  //         (s) => s.categoryId == 136,
  //       );
  //       if (peptideSubcategories.length == allPeptideSubs.length) {
  //         peptideSubcategories.clear(); // Toggle all
  //       }
  //     }
  //
  //     final p = global.allProducts.value.getProductsByCategoryIds(
  //       categoryIds: [136],
  //     );
  //     final peptideProducts = p.where((product) {
  //       final productTags =
  //           product.tags?.map((tag) => tag.toLowerCase()) ?? <String>[];
  //       return peptideSubcategories.any(
  //         (sub) => productTags.contains(sub.name.toLowerCase()),
  //       );
  //     });
  //
  //     products =
  //         peptideSubcategories.isEmpty
  //             ? global.allProducts.value.getProductsByCategoryIds(
  //               categoryIds: [136],
  //             )
  //             : peptideProducts.toList();
  //   });
  // }

  static const _maxProductsShown = 16;
  int get rangeStart => currentPage * _maxProductsShown;

  int get rangeEnd {
    final productsLast =
        products?.length ?? global.allProducts.value.products.length;
    return rangeStart + _maxProductsShown > productsLast
        ? productsLast
        : rangeStart + _maxProductsShown;
  }

  late ShopAllSortBy _sortBy;

  Set<ProductCategory> categoryFilters = <ProductCategory>{};

  Set<ProductBrand> brandFilters = <ProductBrand>{};
  ProductCategory? selectedCategory;
  List<ProductSimple>? products;
  List<ProductSimple> getProducts() =>
      products ?? global.allProducts.value.products;

  bool get hasNoProduct {
    final hasAnyFilter = categoryFilters.isNotEmpty || brandFilters.isNotEmpty;
    if ((products == null || products!.isEmpty) && hasAnyFilter) {
      return true;
    }
    return false;
  }

  bool isLoadingProducts = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _sortBy = global.shopAllSortBy.value;
    // handle route for /shop/brand/:brandId URLs
    final currentPath = Uri.base.path;
    if (currentPath.startsWith('/shop/brand/')) {
      final segments = currentPath.split('/');
      if (segments.length >= 4) {
        final brandId = segments[3];
        // Set the brand filter directly from URL
        global.selectedBrandId.value = 'brand=$brandId';
      }
    }
    initWithSearch();
  }

  Future<void> fromFilter() async {
    final extra = global.selectedBrandId.value;

    if (extra == "default") return;

    if (extra.startsWith('brand')) {
      // extract brand IDs from global.selectedBrandId.value
      final brandIds = extra.split('=').last.split(',');

      // find matching brands from global.brands
      final brands = global.brands.where(
        (brand) => brandIds.contains('${brand.brandId!}'),
      );

      // update the UI to show the selected brand filters
      setState(() {
        brandFilters.addAll(brands);
      });

      // get products for the selected brands
      final products = await global.products.getProducts(brandIds: brandIds);

      // update the UI with the filtered products
      setState(() {
        this.products = products;
        numberOfPages = (products.length / _maxProductsShown).ceil();
        isLoadingProducts = false;
      });

      // make sure to apply any selected sort
      _sortProducts(_sortBy);
    }
    if (extra.startsWith('category')) {
      // extract category IDs from global.selectedBrandId.value
      final categoryIds = extra.split('=').last.split(',');

      // find matching categories from global.categories
      final categories = global.categories.where(
        (e) => categoryIds.contains('${e.categoryId}'),
      );

      // update the UI to show the selected category filters
      setState(() {
        categoryFilters.addAll(categories);
      });

      // get products for the selected categories
      final products = await global.products.getProducts(
        categoryId: categoryIds,
      );

      // update the UI with the filtered products
      setState(() {
        this.products = products;
        numberOfPages = (products.length / _maxProductsShown).ceil();
        isLoadingProducts = false;
      });

      // make sure to apply any selected sort
      _sortProducts(_sortBy);
    }
    global.selectedBrandId.value = '';
  }

  void setCategory(ProductCategory? category) async {
    setState(() {
      selectedCategory = category;
      currentPage = 0;
    });

    if (selectedCategory == null) {
      setState(() {
        products = null;

        numberOfPages =
            (global.totalProductsCount.value / _maxProductsShown).ceil();
      });
    } else {
      _fetchFilteredProducts();
    }
  }

  Future<void> _fetchFilteredProducts() async {
    try {
      clearSearchData();

      setState(() {
        // isLoadingProducts = true;
        errorMessage = null;
      });

      if (categoryFilters.isEmpty && brandFilters.isEmpty) {
        products = global.allProducts.value.products;
        currentPage = 0;
        numberOfPages = (products!.length / _maxProductsShown).ceil();

        setState(() {
          isLoadingProducts = false;
        });
        return;
      }

      final categoryId = categoryFilters.map((e) => e.categoryId).toList();
      final brandIds = brandFilters.map((e) => e.brandId.toString()).toList();

      products = global.allProducts.value.getProductsByCategoriesAndBrands(
        categoryIds: categoryId.map((e) => int.parse(e.toString())).toList(),
        brandIds: brandIds.map((e) => int.parse(e.toString())).toList(),
      );
      setState(() {
        numberOfPages = (products!.length / _maxProductsShown).ceil();
      });
    } catch (e, s) {
      setState(() {
        errorMessage = '$e';
      });
      print('$e\n$s');
    } finally {
      setState(() {
        isLoadingProducts = false;
      });
    }
  }

  Future<String?> _getSearchQuery() async {
    if (global.selectedBrandId.value.isNotEmpty) {
      return global.selectedBrandId.value.split('=').first;
    }
    List<String>? queryList = (await prefs.getString('extra'))?.split('=');
    if (queryList == null || queryList.length <= 1) {
      return null;
    }

    if (queryList.first == 'brand' || queryList.first == 'category') {
      return queryList.first;
    }

    queryList.removeAt(0);
    String queryString = queryList.join(' ');
    return queryString.toUpperCase();
  }

  void initWithSearch() async {
    queryString = await _getSearchQuery();
    if (queryString == null ||
        queryString!.isEmpty ||
        queryString == 'ALL_PRODUCTS') {
      global.recentSearchQuery.value = "";
      queryString = null;
      brandFilters = {};
      categoryFilters = {};
      await getAllProducts();
      _sortProducts(_sortBy);
      return;
    }

    if (queryString == 'category' || queryString == 'brand') {
      global.recentSearchQuery.value = "";
      queryString = null;
      await init();
      return;
    }

    products = global.searchResultProducts;
    currentPage = 0;
    brandFilters = {};
    categoryFilters = {};
    numberOfPages =
        (global.searchResultProducts.length / _maxProductsShown).ceil();
    setState(() {
      isLoadingProducts = false;
    });
  }

  void clearSearchData() {
    setState(() {
      // isLoadingProducts = true;
    });
    products = [];
    global.searchResultProducts.value = [];
    currentPage = 0;
    numberOfPages = 0;
    queryString = null;
  }

  void _resetFilters() {
    brandFilters = {};
    categoryFilters = {};
    queryString = null;
    products = global.allProducts.value.products;
    _sortBy = ShopAllSortBy.bestSeller;
    _sortProducts(_sortBy);

    setState(() {
      currentPage = 0;
      numberOfPages =
          (global.allProducts.value.products.length / _maxProductsShown).ceil();
    });
  }

  Future<void> init() async {
    await getAllProducts();
    // await getCategory();
    await fromFilter();
    _sortProducts(_sortBy);
    setState(() {
      isLoadingProducts = false;
    });
  }

  Future<void> getAllProducts() async {
    // isLoadingProducts = true;
    clearSearchData();
    if (global.allProducts.value.products.isEmpty)
      await global.products.loadAllAuthProducts();
    products = global.allProducts.value.products;
    numberOfPages =
        (global.allProducts.value.products.length / _maxProductsShown).ceil();
  }

  void _sortProducts(ShopAllSortBy sortBy) {
    switch (sortBy) {
      case ShopAllSortBy.bestSeller:
        //final bestSellerProducts = products!.where((product) => product.isBestSeller && product.bestSellerRank != null).toList();
        // products?.sort((a, b) => a.bestSellerRank!.compareTo(b.bestSellerRank!));
        products?.sort((a, b) {
          final aRank = a.bestSellerRank ?? 10000;
          final bRank = b.bestSellerRank ?? 10000;
          return aRank.compareTo(bRank);
        });
        //products = bestSellerProducts;
        break;
      case ShopAllSortBy.newArrivals:
        _fetchFilteredProducts();
        products?.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
        break;
      case ShopAllSortBy.alphabeticalOrder:
        products?.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
        break;
      case ShopAllSortBy.priceLowToHigh:
        products?.sort((a, b) {
          if (a.vendorId == 19 &&
              b.vendorId != 19 &&
              a.skus!.first.tieredPrice == 0)
            return -1;
          if (b.vendorId == 19 &&
              a.vendorId != 19 &&
              b.skus!.first.tieredPrice == 0)
            return 1;
          return a.skus!.first.tieredPrice.compareTo(b.skus!.first.tieredPrice);
        });
        break;
      case ShopAllSortBy.priceHighToLow:
        products?.sort((a, b) {
          if (a.vendorId == 19 &&
              b.vendorId != 19 &&
              a.skus!.first.tieredPrice == 0)
            return -1;
          if (b.vendorId == 19 &&
              a.vendorId != 19 &&
              b.skus!.first.tieredPrice == 0)
            return 1;
          return b.skus!.first.tieredPrice.compareTo(a.skus!.first.tieredPrice);
        });
        break;
    }
    setState(() {
      currentPage = 0;
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final peptideSubcategoryList =
        global.subcategories.where((s) => s.categoryId == 136).toList();
    return GalaxyPageScaffold(
      padding: const EdgeInsets.only(
        top: YLiftConstant.mainNavigationHeight + 32,
      ),
      scrollController: scrollController,
      children: [
        Center(
          child: BannerDynOneHeader(
            imageUrl: ImageRepository.getBannerImage(
              '33f73021-e1fd-4bee-986b-45a33cdb7b43',
            ),
            title: 'Browse All Products',
            description:
                'Discover a comprehensive selection of aesthetic medicine essentials, from top-tier fillers and advanced skincare solutions to trusted medical supplies. Elevate your practice with premium, trusted products while enjoying exclusive discounts and special offers available only through the Y LIFT Store.',
            preferenceKey: 'shop_banner_visible',
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'SORT BY',
              style: TextStyle(
                decoration: TextDecoration.underline,
                fontSize: 13.33,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(width: 16),
            ...List.generate(
              (global.isAuthenticated.value)
                  ? ShopAllSortBy.values.length * 2 - 1
                  : ShopAllSortBy.values.length * 2 - 5,
              (index) {
                if (index.isOdd) return const SizedBox(width: 16);
                final sortBy = ShopAllSortBy.values[index ~/ 2];
                return DynamicSortButton(
                  label: sortBy.label,
                  isSelected: _sortBy == sortBy,
                  onPressed: () {
                    _sortProducts(sortBy);
                    setState(() {
                      _sortBy = sortBy;
                    });
                  },
                );
              },
            ),
          ],
        ),
        const Divider(height: 64),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 280,
              child: Column(
                children: [
                  // Update the FilterListView usage in build:
                  FilterListView<ProductCategory>(
                    name: 'CATEGORIES',
                    list: global.categories.toSet(),
                    selectedFilters: categoryFilters, // Add this
                    display: (value) => value.name,
                    onSelectedFilters: (filters) async {
                      categoryFilters = filters;
                      await _fetchFilteredProducts();
                      currentPage = 0;
                      numberOfPages =
                          (products!.length / _maxProductsShown).ceil();
                      setState(() {
                        isLoadingProducts = false;
                      });
                    },
                  ),
                  const Divider(
                    height: 32,
                    indent: 16,
                    endIndent: 16,
                  ),
                  VendorAndBrandsFilter(
                    selectedBrands: brandFilters,
                    onSelected: (brands) async {
                      brandFilters = brands;
                      await _fetchFilteredProducts();
                      currentPage = 0;
                      numberOfPages =
                          (products!.length / _maxProductsShown).ceil();
                      setState(() {
                        isLoadingProducts = false;
                      });
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _resetFilters();
                      });
                    },
                    child: const Text('Reset All Fields'),
                  ),
                ],
              ),
            ),
            // const GapX(),
            const SizedBox(width: 16),
            if (isLoadingProducts)
              const CircularProgressIndicator()
            else if (hasNoProduct)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (categoryFilters.length == 1 &&
                        categoryFilters.any(
                          (element) => element.name == 'Peptides',
                        )) ...[
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          GalaxyChip(
                            label: 'All Peptides',
                            isSelected: peptideSubcategories.isEmpty,
                            onTap: () {
                              setState(() {
                                peptideSubcategories.clear();
                                products = global.allProducts.value.getProductsByCategoryIds(
                                  categoryIds: [136],
                                );
                                currentPage = 0;
                                numberOfPages = (products!.length / _maxProductsShown).ceil();
                                if (numberOfPages == 0) numberOfPages = 1;
                              });
                            },
                          ),
                          // ...peptideSubcategories.map((category) {
                          //   return GalaxyChip(
                          //     label: category.name,
                          //     isSelected: peptideSubcategories.contains(category),
                          //     onTap: () => addPeptideSubcategory(category),
                          //   );
                          // }),
                          ...global.subcategories.map((subcategory) {
                            return GalaxyChip(
                              label: subcategory.name,
                              isSelected: peptideSubcategories.contains(
                                subcategory,
                              ),
                              onTap: () => addPeptideSubcategory(subcategory),
                            );
                          }),
                        ],
                      ),
                    ],

                    // Wrap(
                    //   spacing: 16,
                    //   runSpacing: 16,
                    //   children: [
                    //     GalaxyChip(
                    //       label: 'All Peptides',
                    //       isSelected: peptideSubcategories.isEmpty,
                    //       onTap: () {
                    //         setState(() {
                    //           peptideSubcategories.clear();
                    //           products = global.allProducts.value
                    //               .getProductsByCategoryIds(categoryIds: [136]);
                    //         });
                    //       },
                    //     ),
                    //     ...peptideSubcategoryList.map(
                    //       (sub) => GalaxyChip(
                    //         label: sub.name,
                    //         isSelected: peptideSubcategories.contains(sub),
                    //         onTap: () => addPeptideSubcategory(sub),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(height: 160),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'No Products Match. Try Adjusting Your Search or Filters',
                            style: TextStyle(
                              fontSize: 28,
                              color: Color(0xFFBBBBBB),
                            ),
                          ),
                          Image.network(
                            _noProductImageUrl,
                            width: 600,
                            height: 600,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            else
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (categoryFilters.length == 1 &&
                        categoryFilters.any(
                          (element) => element.name == 'Peptides',
                        )) ...[
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          GalaxyChip(
                            label: 'All Peptides',
                            isSelected: peptideSubcategories.isEmpty,
                            onTap: () {
                              setState(() {
                                peptideSubcategories.clear();
                                products = global.allProducts.value.getProductsByCategoryIds(
                                  categoryIds: [136],
                                );
                                currentPage = 0;
                                numberOfPages = (products!.length / _maxProductsShown).ceil();
                                if (numberOfPages == 0) numberOfPages = 1;
                              });
                            },
                          ),
                          // ...PeptideSubcategory.values.map((category) {
                          //   return GalaxyChip(
                          //     label: category.label,
                          //     isSelected: peptideSubcategories.contains(category),
                          //     onTap: () => addPeptideSubcategory(category),
                          //   );
                          // }),
                          ...global.subcategories
                              .where(
                                (sub) => sub.categoryId == 136,
                              ) // use correct parent ID
                              .map(
                                (sub) => GalaxyChip(
                                  label: sub.name,
                                  isSelected: peptideSubcategories.contains(
                                    sub,
                                  ),
                                  onTap: () {
                                    addPeptideSubcategory(sub);
                                    // setState(() {
                                    //   if (peptideSubcategories.contains(sub.name)) {
                                    //     peptideSubcategories.remove(sub.name);
                                    //   } else {
                                    //     peptideSubcategories.add(sub.name);
                                    //     if (peptideSubcategories.length == global.subcategories.where((s) => s.parentId == 136).length) {
                                    //       peptideSubcategories.clear(); // toggle all
                                    //     }
                                    //   }
                                    //
                                    //   final p = global.allProducts.value.getProductsByCategoryIds(categoryIds: [136]);
                                    //   final peptideProducts = p.where((product) {
                                    //     final productTags = product.tags?.map((t) => t.toLowerCase()) ?? <String>[];
                                    //     return peptideSubcategories.any((name) => productTags.contains(name.toLowerCase()));
                                    //   });
                                    //
                                    //   products = peptideSubcategories.isEmpty
                                    //       ? global.allProducts.value.getProductsByCategoryIds(categoryIds: [136])
                                    //       : peptideProducts.toList();
                                    // });
                                  },
                                ),
                              ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                    Text(
                      (queryString == null)
                          ? '${getProducts().length} PRODUCTS'
                          : '${getProducts().length} RESULTS FOR "$queryString"',
                      style: TextStyle(
                        color: Color(0xFF787878),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      children:
                          getProducts().getRange(rangeStart, rangeEnd).map((
                            product,
                          ) {
                            return ProductCard(
                              product: product,
                              hidePrice: global.isAuthenticated.isFalse,
                              onLiked: () async {
                                await global.products.likeProduct(
                                  product.productId!,
                                );
                                setState(() {});
                              },
                              onTap: () async {
                                await global.vroute.navigateToProduct(
                                  product.productId!,
                                );
                              },
                              onAddToCart: () {
                                showDialog(
                                  context: context,
                                  builder:
                                      (context) => AddToCartDialog(
                                        product: product,
                                        onSeeProduct: () async {
                                          await global.vroute.navigateToProduct(
                                            product.productId!,
                                          );
                                        },
                                        onAddToCart: (sku, quantity) async {
                                          if (global.isAuthenticated.isFalse) {
                                            await global.vroute.navigateTo(
                                              '/login',
                                            );
                                            return;
                                          }
                                          await global.basket.addToCart(
                                            customerId:
                                                global.user.value.profileId
                                                    .toString(),
                                            quantity: quantity,
                                            product:
                                                "${product.productId}-${sku.skuId}",
                                          );
                                          global.drawerController
                                              .openEndDrawer();
                                        },
                                      ),
                                );
                              },
                            );
                          }).toList(),
                    ),

                    // PAGINATIONS
                    if (numberOfPages > 1)
                      Center(
                        child: Wrap(
                          spacing: 8,
                          children: List.generate(
                            numberOfPages,
                            (index) {
                              final isSelected = index == currentPage;

                              return Material(
                                shape: const CircleBorder(),
                                color:
                                    isSelected
                                        ? const Color(0xFFFF8C68)
                                        : const Color(0xFFEEECEA),
                                clipBehavior: Clip.hardEdge,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      currentPage = index;
                                    });
                                    scrollController.animateTo(
                                      344,
                                      duration: const Duration(
                                        milliseconds: 400,
                                      ),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        color:
                                            isSelected
                                                ? Colors.white
                                                : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
        const GapY(factor: 4),
      ],
    );
  }
}
