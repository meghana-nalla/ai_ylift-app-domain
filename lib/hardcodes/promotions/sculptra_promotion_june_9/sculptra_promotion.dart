import 'package:YLift/hardcodes/constants/ids.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/models/simple/home_promotion_banner_data.dart';
import 'package:get/get.dart';

class SculptraPromotionData {
  final int qualifyingQuantity;
  final int providerCodes;

  static bool get isOngoing => DateTime.now().isBefore(expirationDate);

  const SculptraPromotionData._(this.qualifyingQuantity, this.providerCodes);

  static final _global = Get.find<GlobalController>();

  static const list = <SculptraPromotionData>[
    SculptraPromotionData._(6, 3),
    SculptraPromotionData._(12, 6),
    SculptraPromotionData._(18, 9),
    SculptraPromotionData._(24, 12),
    SculptraPromotionData._(50, 50),
  ];

  static SculptraPromotionData? getCurrentPromotion() {
    return list.firstWhereOrNull(
      (promotion) => totalSculptraQuantity == promotion.qualifyingQuantity,
    );
  }

  static SculptraPromotionData? getNextPromotion() {
    return list.firstWhereOrNull(
      (promotion) => totalSculptraQuantity < promotion.qualifyingQuantity,
    );
  }

  static const productId = '553-2236';

  static const imageUrl =
      'https://media.stage.ylift.app/api/optimized/variant/image/d355ca95-8a21-40c0-b2bf-dfe7e23b38b9';
  static final expirationDate = DateTime(2025, 6, 27, 18); // June 27, 2025 6 PM

  static final homePromotionData = HomePromotionBannerData(
    imageUrl: imageUrl,
    brandIds: [BrandId.sculptra],
    endDate: expirationDate,
  );

  static Iterable<CartItemSimple> get sculptraItems {
    return _global.simpleCart.value.cartItems.where(
      (cartItem) => cartItem.brandId == BrandId.sculptra,
    );
  }

  static int get totalSculptraQuantity {
    return sculptraItems.fold<int>(0, (sum, item) => sum + item.quantity);
  }
}
