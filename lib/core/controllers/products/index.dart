import 'dart:developer';

import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/core/controllers/z-index_export.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../models/_clean/AllProducts.dart';

/// # ProductsController
///
class ProductsController extends GetxController {
  final GlobalController global = Get.find<GlobalController>();
  final RxMap<String, String> _zeroPriceMessages = <String, String>{}.obs;

  String? getZeroPriceMessage(int? vendorId) {
    if (vendorId == null) return null;
    if (global.isAuthenticated.isFalse) return null;
    return _zeroPriceMessages['$vendorId'];
  }

  /// This is the endpoint we are using to get all products as of 1/14/24
  Future<void>
  loadAllAuthProducts() async {
    try {
      // fetch endpoint data
      final PhantomResponse response = await global.api.getData(
          'public/all/products'
      );

      // throw if data is null
      if (response.data == null) {
        throw('Unable to process request, data was null');
      }

      // throw if request fails
      if (response.statusCode != 200 || response.statusMessage != 'Success') {
        throw('Request failed with status code of ${response.statusCode}');
      }

      // map data to ProductSimple
      final List<ProductSimple> allProducts = (response
          .data!['products'] as List)
          .map((e) => ProductSimple.fromJson(e as Map<String, dynamic>))
          .toList();

      final allProductsWithSkuData = allProducts.where(
              (e) {
            if (e.skus?.isEmpty ?? false) debugPrint(
                'Product ${e.productId} ${e.name} has no skus');
            if (e.isActive == false) debugPrint(
                'Product ${e.productId} ${e.name} is not active');
            return e.skus != null && e.skus!.isNotEmpty &&
                (e.isActive != null && e.isActive == true);
          }).toList();


      await getZeroPriceMessages();

      // assign to global controller
      global.allProducts.value =
          AllProducts(products: [], latestProductsFetch: DateTime.now());
      global.allProducts.value = AllProducts(products: allProductsWithSkuData,
          latestProductsFetch: DateTime.now());

      final virtualProducts = await getVirtualProducts();
      global.allVirtualProducts.value =
          AllVirtualProducts(virtualProducts: virtualProducts);

      global.refresh();
      print('Successfully fetched ${global.allProducts.value.products
          .length} products');
      print('Time of fetch: ${global.allProducts.value.latestProductsFetch
          .toIso8601String()}');
    } on Exception catch (e, s) {
      print('Error in ProductsController.loadAllAuthProducts() - $e\n$s');
    }
  }

  Future<void> getZeroPriceMessages() async {
    final response = await global.api.getData(ApiUrl.getZeroPriceMessages.path);
    if (response.isSuccess) {
      final data = response.data?['data'];
      if (data is! Map<String, dynamic>) return;
      final messages = Map<String, String>.fromEntries(
        data.entries.map((e) => MapEntry(e.key, '${e.value}')),
      );
      _zeroPriceMessages.value = messages;
      log('Zero Price Messages has been set to: $_zeroPriceMessages');
    } else {
      throw Exception('Failed to load zero price messages');
    }
  }

  List<ProductSimple> getFeaturedProducts() {
    List<ProductSimple> products;

    products = _fetchProductsFromMemory(featured: true) ?? [];
    return products;
  }

  List<ProductSimple> getBestSellerProducts() {
    List<ProductSimple> products;

    products = _fetchProductsFromMemory(isBestSeller: true) ?? [];
    return products;
  }

  // query the all products list to find a list of all products
  List<ProductSimple> _fetchProductsFromMemory({
    int offset = 0,
    int limit = 200,
    List<String>? categoryId,
    List<String>? brandIds,
    bool isBestSeller = false,
    bool featured = false,
  }) {
    // filter the products by category and brand
    var filteredProducts = global.allProducts.value.products.where((product) {
      if (categoryId?.isNotEmpty == true &&
          product.categoryId?.isNotEmpty == true &&
          !categoryId!.any((id) =>
              product.categoryId!.any((prodId) => prodId.toString() == id)))
        return false;
      if (brandIds?.isNotEmpty == true &&
          product.brandId?.toString() != null &&
          !brandIds!.any((id) => product.brandId?.toString() == id))
        return false;
      return true;
    }).toList();

    filteredProducts = filteredProducts.take(limit).toList();

    try {
      return filteredProducts;
    } catch (e) {
      return [];
    }
  }

  // async wrapper for memory products for now, eventually will be used for caching
  Future<List<ProductSimple>> getProducts({
    int limit = 200,
    int offset = 0,
    List<String>? categoryId,
    List<String>? brandIds,
    bool isBestSeller = false,
    bool featured = false,
  }) async {
    final list = _fetchProductsFromMemory(
        limit: limit,
        offset: offset,
        categoryId: categoryId,
        brandIds: brandIds,
        isBestSeller: isBestSeller,
        featured: featured
    );

    return list;
  }

  // Method to set the product
  void setDisplayProduct(int productId) async {
    global.displayProduct.value = await getProductSimple(productId);
  }

  /// # Gets the product information for a product using its id
  /// - productId: the id of the product
  /// - returns: the product information
  /// - throws: an exception if the request fails
  /// - api use note:
  ///
  /// 'https://api.ylift.com/v1/products/$productId'
  ///
  ///


  // new get product function (returns product simple)
  Future<ProductSimple> getProductSimple(int productId) async {
    try {
      String url = global.isAuthenticated.isTrue
          ? ApiUrl.getProductsAuth.withId(productId.toString())
          : ApiUrl.products.withId(productId.toString());
      final response = await global.api.get(url);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonMap = response.data['data']?['product'] ??
            response.data;
        ProductSimple product = ProductSimple.fromJson(jsonMap);
        return product;
      } else {
        throw Exception(
            'Failed to load product, status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error occurred: $e");
      throw Exception('Failed to load product: $e');
    }
  }

  /// # Gets the vendor information
  /// - vendorId: the id of the vendor
  /// - returns: the vendor information
  /// - throws: an exception if the request fails
  /// - api use note:
  ///
  /// 'https://api.ylift.com/v1/vendor/$vendorId'
  Future<VendorSimple> getVendor(int vendorId) async {
    try {
      final response = await global.api.get(
          ApiUrl.vendors.withId(vendorId.toString()));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonMap = response.data;
        VendorSimple vendor = VendorSimple.fromJson(jsonMap);
        return vendor;
      } else {
        throw Exception(
            'Failed to load product, status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error occurred: $e");
      throw Exception('Failed to load product: $e');
    }
  }

  /// # Gets the sku information for a product
  /// - id: the sku id of the product
  /// - returns: the sku information
  /// - throws: an exception if the request fails
  /// - api use note:
  ///
  /// 'https://api.ylift.com/v1/products/skus/$id'
  Future<SkuSimple> getSkuInfo(int id) async {
    try {
      final response = await global.api.get(ApiUrl.sku.withId(id.toString()));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonMap = response.data;
        SkuSimple product = SkuSimple.fromJson(jsonMap);
        return product;
      } else {
        throw Exception(
            'Failed to load product, status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error occurred: $e");
      throw Exception('Failed to load product: $e');
    }
  }

  /// # Gets a list of sku information for a product via the product id
  /// - productId: the id of the product
  /// - returns: a list of sku information
  /// - throws: an exception if the request fails
  /// - api use note:
  ///
  /// 'https://api.ylift.com/v1/products/skus?productId=$productId'
  Future<List<SkuSimple>> getSkusInfo(int productId) async {
    try {
      final response = await global.api.get(
          ApiUrl.skus.withId(productId.toString()));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonMap = response.data;
        List<dynamic> jsonList = jsonMap['rows'];
        List<SkuSimple> skus = jsonList
            .map((json) => SkuSimple.fromJson(json))
            .toList();
        return skus;
      } else {
        throw Exception(
            'Failed to load sku, status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error occurred: $e");
      throw Exception('Failed to load sku: $e');
    }
  }

  Future<List<ProductSimple>> getSimilarProducts(int productId) async {
    try {
      final response = await global.api.get(
          ApiUrl.similar.withId(productId.toString()));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonMap = response.data;
        List<dynamic> jsonList = jsonMap['rows'];
        List<ProductSimple> products = jsonList.map((json) =>
            ProductSimple.fromJson(json)).toList();
        return products;
      } else {
        throw Exception(
            'Failed to load products, status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error occurred: $e");
      throw Exception('Failed to load products: $e');
    }
  }

  /// # Product Selected (wrapper action)
  /// Accepts a ProductSimple object and navigates to the product details page
  /// - inside the setTappedProduct method, the product is set to the displayProduct value
  /// - inside the onTabTapped method, the tab navigation index is set to 6
  void select(ProductSimple product) async {
    var global = Get.find<GlobalController>();
    global.display.setTappedProduct(product);
    // global.vroute.navigateToIndex(6);
    global.vroute.navigateToProduct(product.productId!);
  }

  Future<void> likeProduct(int productId) async {
    if (global.user.value.likedProductsNotEmpty()) {
      if (global.user.value.likedProducts!.contains(productId)) {
        global.user.value.likedProducts!.remove(productId);
      } else {
        global.user.value.likedProducts!.add(productId);
      }
    } else {
      global.user.value.likedProducts = [productId];
    }
    await global.api.put('profiles/like/$productId', null);
    global.user.refresh();
    global.update();
  }

  Future<List<SkuSimple>> getSkusByProductId(String productId) async {
    final response = await global.api.get(
        '${ApiUrl.getProductSkus.path}/$productId');
    final statusCode = response.statusCode ?? 0;
    if (statusCode >= 200 && statusCode < 300) {
      final rSkus = response.data as List<dynamic>;

      final skus = rSkus.map((e) => SkuSimple.fromJson(e)).toList(
          growable: false);
      return skus;
    } else {
      throw Exception(response.data);
    }
  }

  RxList<int> likedProducts = <int>[].obs;

  // Virtual Items
  Future<List<VirtualProduct>> getVirtualProducts() async {
    final response = await global.api.getData(ApiUrl.getVirtualProducts.path);
    if (response.isSuccess) {
      final data = response.data?['virtualProducts'];
      if (data is! List<dynamic>) return [];
      final products = data.map((e) => VirtualProduct.fromJson(e)).toList(
          growable: false);
      return products;
    } else {
      throw Exception('Failed to load virtual products');
    }
  }

  Future<VirtualProduct?> getVirtualProduct(String virtualId) async {
    final response = await global.api.getData(
        '${ApiUrl.getVirtualProducts.path}$virtualId');
    if (response.isSuccess) {
      final data = response.data?['virtualProduct'];
      final product = VirtualProduct.fromJson(data);
      return product;
    } else {
      throw Exception('Failed to load virtual product');
    }
  }

  Future<VideoCourseData> getVideoData(String videoId) async {
    final response = await global.api.getData('${ApiUrl.getVideoData.path}/$videoId');
    if(response.isSuccess) {
      final rVideoData = response.data?['videoData'];
      final videoData = VideoCourseData.fromJson(rVideoData);
      return videoData;
    } else {
      throw Exception('Failed to load video data');
    }
  }

  Future<BundleProductPrices> getTradingProductsPrices(
      BundleProductsPricesRequest request) async {

    final apiOptions = Options(validateStatus: (status) => true);
    final response = await global.api.postData(
        ApiUrl.tradingGoodsProductsPricing.path, request.toJson(), options: apiOptions);
    print('Phantom Response tradingProductsPrices: ${response.message}');
    if (response.isSuccess) {
      print("is success");
      final data = response.data?['totals'];
      global.bundleProductPrices.value = BundleProductPrices.fromJson(data as Map<String, dynamic>);
      global.bundleProductPrices.refresh();
    }
    print('Phantom Response tradingProductsPrices: ${response.data?['totals']}');
    return BundleProductPrices.fromJson(response.data?['totals']);
  }
}
