import 'package:YLift/core/controllers/z-index_export.dart';
import 'package:YLift/models/simple/ProductCategory.dart';
import 'package:YLift/models/z-index_export.dart' show ApiUrl;
import 'package:galaxy_models/galaxy_models.dart';
import 'package:get/get.dart';

class CategoriesController extends GetxController {
  final global = Get.find<GlobalController>();

  final List<String> categoryId = ['110', '119', '135', '121', '131', '114'];

  final List<String> categoryName = [
    'Popular Dermal Fillers',
    'Our Best-Selling Skincare',
    'Popular DermaCeuticals',
    'Cannulas',
    'Threads',
    'Daily Practice Supplies',
  ];

  Future<List<ProductCategory>> getCategories() async {
    final response = await global.api.get(ApiUrl.categories.path);
    final statusCode = response.statusCode ?? 0;
    if (statusCode >= 200 && statusCode < 300) {
      final rCategories = response.data['rows'] as List<dynamic>;
      final categories = rCategories
          .map((e) => ProductCategory.fromJson(e))
          .toList(growable: false);
      return categories;
    } else {
      throw Exception(response.data);
    }
  }

  Future<List<ProductSubcategory>> getSubcategories() async {
    final response = await global.api.get(ApiUrl.getSubcategories.path);
    final statusCode = response.statusCode ?? 0;
    if (statusCode >= 200 && statusCode < 300) {
      final rCategories = response.data['rows'] as List<dynamic>;
      final categories = rCategories
          .map((e) => ProductSubcategory.fromJson(e))
          .toList(growable: false);
      print(categories);
      return categories;
    } else {
      throw Exception(response.data);
    }
  }

  // Future<void> setCategoryMapping() async{
  //   global.categoryProductsMap.value = await global.products.getSeparatedCategoryProductsGroupedByIds(categoryId);
  //   global.refresh();
  // }
}
