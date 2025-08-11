import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/hardcodes/constants/ids.dart';
import 'package:YLift/core/repositories/image_repository.dart';
import 'package:YLift/hardcodes/promotions/dysport_promotion_june_9/dysport_promotion.dart';
import 'package:YLift/hardcodes/promotions/evolysse/evolysse_promotion.dart';
import 'package:YLift/hardcodes/promotions/restylane_promotion_june_9/restylane_promotion.dart';
import 'package:YLift/hardcodes/promotions/sculptra_promotion_june_9/sculptra_promotion.dart';
import 'package:YLift/hardcodes/promotions/spring_into_rewards/spring_into_rewards.dart';
import 'package:YLift/hardcodes/promotions/summer_glow_july_15/summer_glow_promotion.dart';
import 'package:YLift/presentation/pages/desktop/cart/components/merz_promotion_dialog.dart';

class HomePromotionBannerData {
  final String id;
  final String imageUrl;
  final List<int>? vendorIds;
  final List<int>? brandIds;
  final List<int>? categoryIds;
  final bool isTraining;
  final bool isEvents;
  final bool showCountdown;

  // If the promotion is a video, it will treat the imageUrl as video url
  final bool isVideo;

  final DateTime? startDate;

  /// No expiration date means it goes forever
  final DateTime? endDate;

  bool get isOngoing {
    if (endDate == null) return true;
    return DateTime.now().isBefore(endDate!);
  }

  bool get hasNavigation =>
      vendorIds != null ||
      brandIds != null ||
      categoryIds != null ||
      isTraining ||
      isEvents;

  const HomePromotionBannerData({
    this.id = '',
    required this.imageUrl,
    this.vendorIds,
    this.brandIds,
    this.categoryIds,
    this.isTraining = false,
    this.startDate,
    this.endDate,
    this.isEvents = false,
    this.showCountdown = false,
    this.isVideo = false,
  });

  static List<HomePromotionBannerData> getList() {
    final currentDate = DateTime.now();
    return list.where((element) {
      if (element.endDate == null) return true;
      return currentDate.isBefore(element.endDate!);
    }).toList();
  }

  /// Active Promotions
  static final list = <HomePromotionBannerData>[


    // Galderma summer glow promotion
    //SummerGlowPromotion.homePromotionData,

    // MERZ
    HomePromotionBannerData(
      imageUrl: MerzSyringePromotion.bannerImageUrl,
      brandIds: [MerzSyringePromotion.brandId],
    ),

    // TRAINING
    HomePromotionBannerData(
      imageUrl: ImageRepository.getBannerImage(
        '9dc16599-9583-411f-a3ac-48d4dc5ee942',
      ),
      isTraining: true,
    ),
  ];

  static List<HomePromotionBannerData> get activePromotions {
    final currentDate = DateTime.now();
    return list.where((promotion) {
      if (promotion.endDate == null) return true;
      return currentDate.isBefore(promotion.endDate!);
    }).toList();
  }

  // Expired Promotions
  // Just for collections
  static final _expiredPromotions = <HomePromotionBannerData>[
    // Practice Luxury
    HomePromotionBannerData(
      vendorIds: [19],
      imageUrl:
          '${YLiftConstant.baseUrl}/static/assets/optimized/custom_images/mar_20_gal_img0.png',
      endDate: DateTime(2025, 3, 31, 18), // March 31, 2025 6 PM
    ),

    HomePromotionBannerData(
      imageUrl:
          '${YLiftConstant.baseUrl}/static/assets/optimized/custom_images/mar_24_promo_banner.png',
      brandIds: [82],
      endDate: DateTime(2025, 4, 11, 18), // April 11, 2025 6 PM
    ),

    // Fragrance Vouchers
    HomePromotionBannerData(
      imageUrl:
          '${YLiftConstant.baseUrl}/static/assets/optimized/custom_images/mar_20_gal_img1.png',
      brandIds: [81, 83], // Galderma Vendor ID
      endDate: DateTime(2025, 3, 31, 18), // March 31, 2025 6 PM
    ),

    // Galderma CASSHBACK
    HomePromotionBannerData(
      imageUrl: ImageRepository.getBannerImage(
        '2ba2f7e0-9361-4375-9dec-fa91542e880a',
      ),
      vendorIds: [19], // Galderma Vendor ID
      endDate: DateTime(2025, 3, 8),
    ),



    HomePromotionBannerData(
      imageUrl: ImageRepository.getBannerImage(
        '3973e38e-ce5f-45f1-a1a4-483442052b26',
      ),
      vendorIds: [19], // Galderma Vendor ID
      endDate: DateTime(2025, 3, 15),
    ),

    // NEW PRODUCTS
    HomePromotionBannerData(
      vendorIds: [13, 29],
      imageUrl: ImageRepository.getBannerImage(
        '12259975-3e37-4c94-94fd-4fd1e1124c1c',
      ),
    ),

    HomePromotionBannerData(
      id: 'dial-in-discount',
      imageUrl:
      'https://media.stage.ylift.app/api/optimized/variant/image/3095d51c-1081-4523-8ccd-1bb6e65d2f9f',
      startDate: DateTime(2025, 6, 17, 9),
      endDate: DateTime(2025, 6, 20, 18),
      vendorIds: [VendorId.galderma],
      showCountdown: true,
    ),

    // Restylane Promotion June 30, 2025
    RestylanePromotionData.homePromotionData,

    // Sculptra Promotion June 27, 2025
    SculptraPromotionData.homePromotionData,

    // Dysport Promotion June 27, 2025
    DysportPromotionData.homePromotionData,
  ];
}
