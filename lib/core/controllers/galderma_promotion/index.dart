import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/models/api/z-index_export.dart';
import 'package:YLift/hardcodes/promotions/spring_into_rewards/spring_into_rewards.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/hardcodes/promotions/fragrance_vouchers/fragrance_vouchers_promotion_data.dart';
import 'package:YLift/hardcodes/promotions/fragrance_vouchers/galderma_promotion_data.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';

const _galdermaVendorId = 19;
const _restylaneBrandId = 81;
const _sculptraBrandId = 83;

class GaldermaController extends GetxController {
  final global = Get.find<GlobalController>();
  RxList<String> selectedRewards = <String>[].obs;
  bool get isRewardSelected => selectedRewards.isNotEmpty;

  Future<void> setReward(String value) async {
    final orderId = global.simpleCart.value.orderId;
    final queryParameters = <String, String>{
      'orderId': orderId!,
      'promotionTitle': 'galderma',
      'promotionText': value,
    };
    await global.api.putData(
      ApiUrl.setPromotionRewardText.withQuery(queryParameters),
      {},
    );
    print('reward set successfuly to $value');
    if (value.isEmpty) {
      selectedRewards.value = [];
    } else {
      selectedRewards.value = [value];
    }
  }

  List<CartItemSimple> get _cartItems => global.simpleCart.value.cartItems;
  List<CartItemSimple> get galdermaItems =>
      _cartItems.where((item) => item.vendorId == _galdermaVendorId).toList();
  int get totalGaldermaCount => galdermaItems.fold(
    0,
    (previousValue, element) => previousValue + element.quantity,
  );

  int get restylaneCount => galdermaItems
      .where((item) => item.brandId == _restylaneBrandId)
      .fold(0, (previousValue, element) => previousValue + element.quantity);
  int get sculptraCount => galdermaItems
      .where((item) => item.brandId == _sculptraBrandId)
      .fold(0, (previousValue, element) => previousValue + element.quantity);

  SpringIntoRewardsPromotion? get springIntoRewardsPromotion {
    if (totalGaldermaCount == 0) return null;
    if (totalGaldermaCount >
        SpringIntoRewardsPromotion.list.last.totalQuantity) {
      return SpringIntoRewardsPromotion.list.last;
    }

    return SpringIntoRewardsPromotion.list.firstWhereOrNull((element) {
      return totalGaldermaCount <= element.totalQuantity;
    });
  }

  bool get isSpringPromotionApplicable =>
      springIntoRewardsPromotion?.totalQuantity == totalGaldermaCount;
  int get quantityForNextTier =>
      (springIntoRewardsPromotion?.totalQuantity ?? 0) - totalGaldermaCount;

  // Below these are old promotions

  FragranceVoucersPromotionData? get fragranceVouchersPromotion {
    final reversedList = FragranceVoucersPromotionData.list.reversed.toList();
    return reversedList.firstWhereOrNull(
      (e) =>
          restylaneCount >= e.restylaneCount ||
          sculptraCount >= e.sculptraCount,
    );
  }

  int get galdermaTotal => galdermaItems.fold(
    0,
    (previousValue, element) => previousValue + element.total,
  );

  PracticeLuxuryPromotionData? get currentTierPromotion {
    if (DateTime.now().isAfter(PracticeLuxuryPromotionData.expirationDate)) {
      return null;
    }
    final reversedList = PracticeLuxuryPromotionData.list.reversed.toList();
    return reversedList.firstWhereOrNull(
      (e) => galdermaTotal >= e.spendingThreshold,
    );
  }

  bool get hasPracticeLuxuryPromotion => currentTierPromotion != null;

  PracticeLuxuryPromotionData? get nextTierPromotion {
    return PracticeLuxuryPromotionData.list.firstWhereOrNull(
      (e) => galdermaTotal < e.spendingThreshold,
    );
  }

  int get spendingLeftForNextTier =>
      nextTierPromotion!.spendingThreshold - galdermaTotal;
}
