import 'package:YLift/models/_clean/product.dart';
import 'package:get/get.dart';

class AllProducts {
  final List<ProductSimple> products;
  final DateTime latestProductsFetch;

  AllProducts({
    required this.products,
    required this.latestProductsFetch,
  });

  // Convert AllProducts instance to JSON
  Map<String, dynamic> toJson() =>
      {
        'products': products.map((product) => product.toJson()).toList(),
        'latestProductsFetch': latestProductsFetch.toIso8601String(),
      };

  // Create AllProducts instance from JSON
  factory AllProducts.fromJson(Map<String, dynamic> json) =>
      AllProducts(
        products: (json['products'] as List<dynamic>)
            .map((productJson) =>
            ProductSimple.fromJson(productJson as Map<String, dynamic>))
            .toList(),
        latestProductsFetch: DateTime.parse(
            json['latestProductsFetch'] as String),
      );

  ProductSimple? getById(int productId) {
    return products.firstWhereOrNull((element) => element.productId == productId);
  }

  List<ProductSimple> getByIds(List<int> productIds) {
    return products.where((element) => productIds.contains(element.productId)).toList();
  }

  // getters
  List<ProductSimple> getBestSellers({int? limit}) {
    try {
      var bestSellerProducts =
      products.where((product) =>
      product.isBestSeller && product.bestSellerRank != null).toList();
      bestSellerProducts.sort((a, b) =>
          a.bestSellerRank!.compareTo(b.bestSellerRank!));
      if (limit != null)
        bestSellerProducts = bestSellerProducts.take(limit).toList();
      return bestSellerProducts;
    } catch (e, s) {
      print('$e\n$s');
      rethrow;
    }
  }

  List<ProductSimple> getFeatured({int? limit}) {
    var featuredProducts = products
        .where((product) => product.featured == true)
        .toList();
    featuredProducts.sort((a, b) =>
        a.featuredOrder.compareTo(b.featuredOrder));
    if (limit != null) featuredProducts = featuredProducts.take(limit).toList();
    return featuredProducts;
  }

  List<ProductSimple> getNewArrivals({int? limit}) {
    var newArrivals = List<ProductSimple>.from(products)
      ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    if (limit != null) newArrivals = newArrivals.take(limit).toList();

    return newArrivals;
  }

  List<ProductSimple> getProductsByCategoryIds({
    required List<int> categoryIds,
    int? limit,
  }) {
    var categoryProducts =
    List<ProductSimple>.from(products).where((e) =>
        e.categoryId!.any((id) => categoryIds.contains(id))).toList();
    if (limit != null) categoryProducts = categoryProducts.take(limit).toList();

    return categoryProducts;
  }

  List<ProductSimple> getProductsByBrandIds({
    required List<int> brandIds,
    int? limit,
  }) {
    var brandProducts = List<ProductSimple>.from(products).where((e) =>
        brandIds.contains(e.brandId)).toList();
    if (limit != null) brandProducts = brandProducts.take(limit).toList();

    return brandProducts;
  }

  List<ProductSimple> getProductsByVendorIds({
    required List<int> vendorIds,
    int? limit,
  }) {
    var vendorProducts = List<ProductSimple>.from(products)
        .where((product) =>
    vendorIds.contains(product.vendorId) && product.hasPrice)
        .toList();
    if (limit != null) vendorProducts = vendorProducts.take(limit).toList();

    return vendorProducts;
  }

  List<ProductSimple> getProductsByCategoriesAndBrands({
    required List<int> categoryIds,
    required List<int> brandIds,
    int? limit,
  }) {
    List<ProductSimple> filteredProducts = [];

    if (categoryIds.isEmpty && brandIds.isEmpty) {
      return filteredProducts;
    }

    if (categoryIds.isEmpty && brandIds.isNotEmpty) {
      filteredProducts = getProductsByBrandIds(brandIds: brandIds);
    } else if (brandIds.isEmpty && categoryIds.isNotEmpty) {
      filteredProducts = getProductsByCategoryIds(categoryIds: categoryIds);
    } else {
      filteredProducts = products
          .where((product) =>
      product.categoryId!.any((id) => categoryIds.contains(id)) &&
          brandIds.contains(product.brandId))
          .toSet()
          .toList();
    }

    if (limit != null) filteredProducts = filteredProducts.take(limit).toList();

    return filteredProducts;
  }

  //Get a list of products based on tags
  List<ProductSimple> getProductsByTags({
    required List<String> tags,
    int? limit,
    int? productId,
  }) {
    List<ProductSimple> filteredProducts = [];
    try {
      if (tags.isEmpty) {
        return filteredProducts;
      }

      var valid_products = products.where((product) => product.tags != null).toSet().toList();
      filteredProducts = valid_products
          .where((product) =>
          product.tags!.any((id) => tags.contains(id)))
          .toSet()
          .toList();

      if (limit != null)
        filteredProducts = filteredProducts.take(limit).toList();

      if(productId != null) filteredProducts.removeWhere((product) => product.productId == productId);
    } catch (e) {
      print(e);
    }
    return filteredProducts;
  }
}
