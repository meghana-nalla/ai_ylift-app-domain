import 'package:get/get.dart';
import 'package:YLift/core/controllers/global.dart';

class ProductSearchService {
  static final GlobalController controller = Get.find<GlobalController>();

  // Find all products in best sellers (for now) which contain the given keyword in name
  static void searchProductsByName(String keyword) {
    controller.dynamicProducts.value = controller.bestSellerProducts.where(
            (product) => product.name.toLowerCase().contains(keyword.toLowerCase())
    ).toList();
  }
}