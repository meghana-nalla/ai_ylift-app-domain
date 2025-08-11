import 'dart:developer';

import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:get/get.dart';

import '../global.dart';

/// # QuickLinksController
///
class QuickLinksController extends GetxController {
  final GlobalController global = Get.find<GlobalController>();

  Future<List<QuickLinksSimple>> fetchQuickLinks() async {
    var sample = [
      'Categories',
      'Brands',
      'Best Sellers',
      'New Arrivals',
      'Featured',
      'Promotions',
    ];
    // removed trending, featured, and top rated
    return sample.map((e) => QuickLinksSimple(name: e)).toList();
  }

  Future<List<ProductCategory>> fetchCategoryLinks() async {
    try {
      final response = await global.api.get(ApiUrl.categories.path);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonMap = response.data;
        List<dynamic> jsonList = jsonMap['rows'];
        return jsonList.map((json) {
          return ProductCategory.fromJson(json);
        }).toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }

  Future<List<ProductSimple>> fetchCategoryLinksById(String id) async {
    try {
      final response = await global.api.get(ApiUrl.categories.withId(id));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonMap = response.data;
        List<dynamic> jsonList = jsonMap['rows'];
        return jsonList.map((json) {
          return ProductSimple.fromJson(json);
        }).toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }

  // TODO : Move to Products Controller
  Future<List<ProductBrand>> fetchBrandLinks() async {
    try {
      PhantomResponse response = await global.api.getData('${ApiUrl.brands.path}');
      if (response.isSuccess) {
        List<dynamic> data = response.data!['rows'];
        return data.map((json)=>ProductBrand.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load brands: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load brands: $e');
    }
  }

  Future<List<ProductSimple>> fetchBrandLinksById(int brandId) async {
    try {
      final response = await global.api.get(ApiUrl.productsByBrand.withId(brandId.toString()));
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json)=>ProductSimple.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load brands: ${response.statusCode}');
      }
    } catch (e) {
      global.showLoadingBar.value = false;
      throw Exception('Failed to load brands: $e');
    }
  }

  // TODO : Move to Products Controller
  Future<List<VendorSimple>> fetchVendors() async {
    PhantomResponse response = await global.api.getData(ApiUrl.vendors.path);
    if (response.isSuccess) {
      List<dynamic> data = response.data!['rows'];
      return data.map((e) => VendorSimple.fromJson(e)).toList(growable: false);
    } else {
      throw Exception('Failed to fetchVendors()');
    }
  }

  // Fetch a single brand by id (wip)
  Future<SearchResult> fetchBrandById(int brandId) async {
    try {
      final response = await global.api.get(ApiUrl.brands.withId(brandId.toString()));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonMap = response.data;
        SearchResult brandResult = SearchResult.fromJson(jsonMap);
        return brandResult;
      } else {
        throw Exception('API Request failed fetching brand with id $brandId: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get brand with id $brandId: $e');
    }
  }

  // Function to determine if a brand has any products associated with it
  Future<bool> brandHasProducts(int brandId) async {
    SearchResult brand = await fetchBrandById(brandId);
    return (brand.count! > 0);
  }

  Future<void> assignQuickLinks() async {
    try {
      List<QuickLinksSimple> links = await fetchQuickLinks();
      global.quickLinks.assignAll(links);
    } catch (e) {
      global.handleError('Error fetching quick links', e);
    }
  }

  //
  Future<void> assignBrands() async {
    try {
      List<ProductBrand> brandData = await fetchBrandLinks();
      global.brands.assignAll(brandData);
    } catch (e) {
      global.handleError('Error fetching brands', e);
    }
  }

  Future<void> assignVendors() async {
    try {
      final vendors = await fetchVendors();
      global.vendors.assignAll(vendors);
    } catch (e) {
      global.handleError('Error fetching vendors', e);
    }
  }

  Future<void> assignCategories() async {
    try {
      List<ProductCategory> categoryData = await fetchCategoryLinks();
      global.categories.assignAll(categoryData);
    } catch (e) {
      global.handleError('Error fetching categories', e);
    }
  }
}
