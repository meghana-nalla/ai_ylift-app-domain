// import 'package:YLift/core/controllers/global.dart';
// import 'package:YLift/hardcodes/constants/ids.dart';
// import 'package:YLift/models/simple/home_promotion_banner_data.dart';
// import 'package:galaxy_models/carts/CartItemSimple.dart';
// import 'package:get/get.dart';
//
// class SummerGlowPromotion {
//   final int qualifyingQuantity;
//   final int providerCodes;
//
//   const SummerGlowPromotion._(this.qualifyingQuantity, this.providerCodes);
//
//   static const imageUrl =
//       'https://media.stage.ylift.app/api/optimized/variant/image/93ffc3f1-fd32-4c5f-bbcb-ae99ff464fc2';
//   static const videoUrl = 'https://media.stage.ylift.app/api/video/stream/79b864f0-10b7-4574-8a64-fc33dd45169f';
//   // static const videoUrl = 'https://media.stage.ylift.app/api/optimized/variant/image/93ffc3f1-fd32-4c5f-bbcb-ae99ff464fc2';
//
//   static final expirationDate = DateTime(2025, 8, 8, 18); // August 8, 2025 6 PM
//
//   static bool get isOngoing => DateTime.now().isBefore(expirationDate);
//
//   static SummerGlowPromotion? getCurrentPromotion() {
//     return list.firstWhereOrNull(
//       (promotion) => totalGaldermaQuantity == promotion.qualifyingQuantity,
//     );
//   }
//
//   static SummerGlowPromotion? getNextPromotion() {
//     return list.firstWhereOrNull(
//       (promotion) => totalGaldermaQuantity < promotion.qualifyingQuantity,
//     );
//   }
//
//   static const list = <SummerGlowPromotion>[
//     SummerGlowPromotion._(20, 12),
//     SummerGlowPromotion._(40, 24),
//     SummerGlowPromotion._(60, 60),
//     SummerGlowPromotion._(80, 80),
//     SummerGlowPromotion._(150, 175),
//     SummerGlowPromotion._(200, 250),
//   ];
//
//   static final homePromotionData = HomePromotionBannerData(
//     imageUrl: imageUrl,
//     vendorIds: [VendorId.galderma],
//     endDate: expirationDate,
//     isVideo: false,
//   );
//
//   static final _global = Get.find<GlobalController>();
//
//   static Iterable<CartItemSimple> get galdermaItems {
//     return _global.simpleCart.value.cartItems.where(
//       (cartItem) => cartItem.vendorId == VendorId.galderma,
//     );
//   }
//
//   static int get totalGaldermaPurchase {
//     return galdermaItems.fold<int>(0, (sum, item) => sum + item.total);
//   }
//
//   static int get totalGaldermaQuantity {
//     return galdermaItems.fold<int>(0, (sum, item) => sum + item.quantity);
//   }
//
//   static bool get isEligibleForVEFDiffuser => isOngoing && totalGaldermaPurchase >= 1500000;
// }
