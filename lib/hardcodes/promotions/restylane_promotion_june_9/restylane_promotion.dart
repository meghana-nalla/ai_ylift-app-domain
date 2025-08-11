import 'package:YLift/hardcodes/constants/ids.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/models/simple/home_promotion_banner_data.dart';
import 'package:get/get.dart';

class RestylanePromotionData {
  final int qualifyingQuantity;
  final int freeVouchers;

  static bool get isOngoing => DateTime.now().isBefore(expirationDate);

  const RestylanePromotionData._(this.qualifyingQuantity, this.freeVouchers);

  static final _global = Get.find<GlobalController>();

  static const list = <RestylanePromotionData>[
    RestylanePromotionData._(32, 8),
    RestylanePromotionData._(48, 12),
    RestylanePromotionData._(64, 16),
    RestylanePromotionData._(80, 20),
    RestylanePromotionData._(300, 125),
  ];

  static RestylanePromotionData? getCurrentPromotion() {
    return list.firstWhereOrNull(
      (promotion) => totalRestylaneQuantity == promotion.qualifyingQuantity,
    );
  }

  static RestylanePromotionData? getNextPromotion() {
    return list.firstWhereOrNull(
      (promotion) => totalRestylaneQuantity < promotion.qualifyingQuantity,
    );
  }

  static const imageUrl =
      'https://media.stage.ylift.app/api/optimized/variant/image/47a3f1a7-b7a4-4058-9624-a2f85871c4b3';
  static final expirationDate = DateTime(2025, 6, 30, 18); // June 30, 2025 6 PM

  static final homePromotionData = HomePromotionBannerData(
    imageUrl: imageUrl,
    brandIds: [BrandId.restylane], // Restylane brand ID
    endDate: expirationDate, // June 30, 2025 6 PM
  );

  static Iterable<CartItemSimple> get restylaneItems {
    return _global.simpleCart.value.cartItems.where(
      (cartItem) => cartItem.brandId == BrandId.restylane,
    );
  }

  static int get totalRestylaneQuantity {
    return restylaneItems.fold<int>(0, (sum, item) => sum + item.quantity);
  }
}
