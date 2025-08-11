import 'package:YLift/hardcodes/constants/ids.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/models/simple/home_promotion_banner_data.dart';
import 'package:get/get.dart';
import 'package:galaxy_models/galaxy_models.dart';
class DysportPromotionData {
  final int qualifyingQuantity;
  final int providerCodes;

  static bool get isOngoing => DateTime.now().isBefore(expirationDate);

  const DysportPromotionData._(this.qualifyingQuantity, this.providerCodes);

  static final _global = Get.find<GlobalController>();

  static const list = <DysportPromotionData>[
    DysportPromotionData._(30, 15),
    DysportPromotionData._(60, 30),
    DysportPromotionData._(90, 45),
    DysportPromotionData._(120, 60),
    DysportPromotionData._(200, 200),
  ];

  static DysportPromotionData? getCurrentPromotion() {
    return list.firstWhereOrNull(
          (promotion) => totalDysportQuantity == promotion.qualifyingQuantity,
    );
  }

  static DysportPromotionData? getNextPromotion() {
    return list.firstWhereOrNull(
          (promotion) => totalDysportQuantity < promotion.qualifyingQuantity,
    );
  }

  static const imageUrl =
      'https://media.stage.ylift.app/api/optimized/variant/image/697131cd-db63-423b-af88-a4cf626cab1a';
  static final expirationDate = DateTime(2025, 6, 27, 18); // June 27, 2025 6 PM

  static final homePromotionData = HomePromotionBannerData(
    imageUrl: imageUrl,
    brandIds: [BrandId.dysport],
    endDate: expirationDate,
  );

  static Iterable<CartItemSimple> get dysportItems {
    return _global.simpleCart.value.cartItems.where(
          (cartItem) => cartItem.brandId == BrandId.dysport,
    );
  }

  static int get totalDysportQuantity {
    return dysportItems.fold<int>(0, (sum, item) => sum + item.quantity);
  }
}
