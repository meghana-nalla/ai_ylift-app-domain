import 'package:YLift/core/constants/color.dart';
import 'package:YLift/core/controllers/z-index_export.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:YLift/presentation/components/products/mobile_product_tile.dart';
import 'package:YLift/presentation/pages/mobile/categories/components/filter_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FilterableProductsPage extends StatefulWidget {
  const FilterableProductsPage({Key? key}) : super(key: key);

  @override
  State<FilterableProductsPage> createState() => _FilterableProductsPageState();
}

enum FilterType { Categories, Brands }
enum SortBy {
  bestSeller('Best Seller'),
  newArrivals('New Arrivals'),
  priceLowToHigh('Price: Low to High'),
  priceHighToLow('Price: High to Low');
  final String label;

  const SortBy(this.label);
}

class _FilterableProductsPageState extends State<FilterableProductsPage> {
  final GlobalController controller = Get.find<GlobalController>();
  List<ProductSimple> _allProducts = [];
  List<ProductSimple> _filteredProducts = [];
  List<ProductBrand> _selectedBrands = [];
  List<ProductCategory> _selectedCategories = [];
  List<int> _selectedBrandIds = [];
  List<int> _selectedCategoryIds = [];
  final NumberFormat currencyFormat = NumberFormat.currency(symbol: '\$');
  FilterType _currentFilterType = FilterType.Categories;
  SortBy _currentSortBy = SortBy.bestSeller;

  @override
  void initState() {
    super.initState();
    _loadInitialProducts();
  }

  Future<void> _loadInitialProducts() async {
    // Fetch all products initially (replace with your actual data source)
    _allProducts = await _fetchAllProducts(); // Replace with your method

    _filteredProducts = List.from(_allProducts);
    final categoryId = controller.selectedBrandId.value.isEmpty ? null : controller.selectedBrandId.value.split('=')[1];
    if (categoryId != null) {
      var category = controller.categories.firstWhereOrNull((element) => element.categoryId == int.parse(categoryId));
      _selectedCategories.add(category!);
      _filterProducts();
    }
    _sortProducts(_currentSortBy);
    setState(() {});
  }

  //Fetching products from API
  Future<List<ProductSimple>> _fetchAllProducts() async {
    List<ProductSimple> allProducts = controller.allProducts.value.products; //categoryId != null ? await controller.products.getProducts(categoryId: [categoryId]) : controller.allProducts.value.products;
    return allProducts;
  }

  void _filterProducts() {
    try {
      print('Filtering Products ');
      _selectedBrandIds = _selectedBrands.map((e) => e.brandId!).toList();
      _selectedCategoryIds = _selectedCategories.map((e) => e.categoryId).toList();
      _filteredProducts = _allProducts.where((product) {
        bool brandMatch = _selectedBrandIds.isEmpty ||
            _selectedBrandIds.contains(product.brandId);
        print('Brand Match $brandMatch');
        bool categoryMatch = _selectedCategoryIds.isEmpty ||
            product.categoryId!.any((productCategoryId) =>
                _selectedCategoryIds.contains(productCategoryId));
        print('Category Match $categoryMatch');
        return brandMatch && categoryMatch;
      }).toList();
    } catch (e) {
      print('Error filtering: $e');
    }
    _sortProducts(_currentSortBy);
    setState(() {});
  }

  void _toggleBrand(ProductBrand brand) {
    setState(() {
      if (_selectedBrands.contains(brand)) {
        _selectedBrands.remove(brand);
      } else {
        _selectedBrands.add(brand);
      }
      _filterProducts();
    });
  }

  void _toggleCategory(ProductCategory category) {
    setState(() {
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }
      _filterProducts();
    });
  }

  void _handleNavigation(ProductSimple item) async {
    controller.products.select(item);
    controller.navigateMobileIndex.value = 6;
    controller.display.update();
  }

  void _openFilterDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return FilterDialog(
          selectedBrands: _selectedBrands,
          selectedCategories: _selectedCategories,
          toggleBrand: _toggleBrand,
          toggleCategory: _toggleCategory,
          closeDialog: () {
            Navigator.of(context).pop();
          },
          currentFilterType: _currentFilterType,
          allProducts: _allProducts, // Pass allProducts here
          onBrandSelected: (brands){
            _selectedBrands = brands.toList();
            _filterProducts();
          },
          onCategorySelected: (categories){
            _selectedCategories = categories.toList();
            _filterProducts();
          },
        );
      },
    );
  }

  void _setFilterType(FilterType type) {
    setState(() {
      _currentFilterType = type;
    });
  }

  void _sortProducts(SortBy sortBy) {
    switch (sortBy) {
      case SortBy.bestSeller:
        _filteredProducts.sort((a, b) {
          final aRank = a.bestSellerRank ?? 10000;
          final bRank = b.bestSellerRank ?? 10000;
          return aRank.compareTo(bRank);
        });
        break;
      case SortBy.newArrivals:
        _filteredProducts.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
        break;
      case SortBy.priceLowToHigh:
        _filteredProducts.sort((a, b) {
          if (a.vendorId == 19 && b.vendorId != 19 && a.skus!.first.tieredPrice == 0) return -1;
          if (b.vendorId == 19 && a.vendorId != 19 && b.skus!.first.tieredPrice == 0) return 1;
          return a.skus!.first.tieredPrice.compareTo(b.skus!.first.tieredPrice);
        });
        break;
      case SortBy.priceHighToLow:
        _filteredProducts.sort((a, b) {
          if (a.vendorId == 19 && b.vendorId != 19 && a.skus!.first.tieredPrice == 0) return -1;
          if (b.vendorId == 19 && a.vendorId != 19 && b.skus!.first.tieredPrice == 0) return 1;
          return b.skus!.first.tieredPrice.compareTo(a.skus!.first.tieredPrice);
        });
        break;
    }
  }

  void _setSortBy(SortBy sortBy) {
    setState(() {
      _currentSortBy = sortBy;
    });
    _sortProducts(_currentSortBy);
    setState(() {});
  }

  @override
  void dispose() {
    if (controller.selectedBrandId.value.isNotEmpty) {
      controller.selectedBrandId.value = "";
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: BackButton(
      //     onPressed: (){
      //       controller.vroute.navigateTo('/shop');
      //     },
      //   ),
      //   title: YLSLogo(isMobile: true),
      //   backgroundColor: Colors.white,
      // ),
      body: _allProducts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.arrow_downward, color: Colors.white),
                    iconAlignment: IconAlignment.end,
                    onPressed: () {
                      _setFilterType(FilterType.Categories);
                      _openFilterDialog();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _currentFilterType == FilterType.Categories
                          ? YLiftColor.orange
                          : Colors.grey[300],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.all(6)
                    ),
                    label:  Text('Categories', style: TextStyle(fontSize: 13)),
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Icons.arrow_downward, color: Colors.white),
                    iconAlignment: IconAlignment.end,
                    onPressed: () {
                      _setFilterType(FilterType.Brands);
                      _openFilterDialog();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _currentFilterType == FilterType.Brands
                          ? YLiftColor.orange
                          : Colors.grey[300],
                      foregroundColor:  Colors.white,
                        padding: EdgeInsets.all(6)
                    ),
                    label: Text('Brands',
                        style: TextStyle(fontSize: 13)
                    ),
                  ),
                  DropdownButton<SortBy>(
                    value: _currentSortBy,
                    items: SortBy.values.map((SortBy sortBy) {
                      return DropdownMenuItem<SortBy>(
                        value: sortBy,
                        child: Text(sortBy.label,
                            style: const TextStyle(fontSize: 11.11)),
                      );
                    }).toList(),
                    onChanged: (SortBy? newValue) {
                      if (newValue != null) {
                        _setSortBy(newValue);
                      }
                    },
                  ),
                ],
              ),
              // ),
              const SizedBox(height: 16),
              // Product Grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3/5,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = _filteredProducts[index];
                    return MobileProductTile(
                        product: product,
                        hidePrice: controller.isAuthenticated.isFalse,
                        onProductTap: () {
                          _handleNavigation(product);
                        }
                    );
                  },
                ),
              ),
            ],
          ),
    );
  }
}