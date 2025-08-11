import 'package:get/get.dart';
import 'package:YLift/core/controllers/z-index_export.dart';
import 'package:YLift/app_meta_controller.dart';

class ProductMetaTagMiddleware extends GetMiddleware {
  @override
  GetPage? onPageCalled(GetPage? page) {
    final productId = Get.parameters['id'];
    if (productId != null) {
      Get.find<GlobalController>().siteInitLoaded.value = true;
      Get.find<GlobalController>().showingSplash.value = false;
      Get.find<GlobalController>().showingPromotion.value = false;
      Get.find<MetaTagController>().updateProductMetaTags(int.parse(productId));
    }
    return page;
  }
}