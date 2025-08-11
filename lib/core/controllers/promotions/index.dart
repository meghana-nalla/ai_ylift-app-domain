import 'package:get/get.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:YLift/core/controllers/global.dart';

/// # PromotionsController
///
///
/// - Responsible for fetching active promotions from the API
class PromotionsController extends GetxController {
  final GlobalController global = Get.find<GlobalController>();

  Future<List<PromotionSimple>> fetchActivePromotions() async {
    try {
      final response = await global.api.get(ApiUrl.promotions.path);
      // print(response);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonMap = response.data;
        List<dynamic> jsonList = jsonMap['rows'];
        List<PromotionSimple> allPromotions = jsonList.map((json) {
          if (json['imageUrl'] != null && json['imageUrl'] is String) {
            json['imageUrl'] = json['imageUrl'];
          }


          return PromotionSimple.fromJson(json);
        }).toList();
        final currentDate = DateTime.now();
        final activePromotions = allPromotions.where((promotion) => currentDate.isBefore(promotion.expireAt)).toList();
        return activePromotions;
        // return allPromotions.activeOnly();
      } else {
        throw Exception('Failed to load promotions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load promotions: $e');
    }
  }

  Future<void> assignActivePromotions() async {
    try {
      List<PromotionSimple> activePromos = await fetchActivePromotions();
      global.promotions.assignAll(activePromos);
    } catch (e) {
      global.handleError('Error fetching active promotions', e);
    }
  }
}
