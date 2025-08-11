import 'package:YLift/core/constants/constant.dart';

class FragranceVoucersPromotionData {
  final int restylaneCount;
  final int sculptraCount;
  final int voucherCount;

  const FragranceVoucersPromotionData._(this.restylaneCount, this.sculptraCount, this.voucherCount);

  static const imageUrl = '${YLiftConstant.baseUrl}/static/assets/optimized/custom_images/mar_19_gal_img1.png';
  static const mensFragrance = '${YLiftConstant.baseUrl}/static/assets/optimized/custom_images/mar_19_gal_img2.png';
  static const womensFragrance = '${YLiftConstant.baseUrl}/static/assets/optimized/custom_images/mar_19_gal_img3.png';

  static final list = <FragranceVoucersPromotionData>[
    FragranceVoucersPromotionData._(16, 8, 4),
    FragranceVoucersPromotionData._(32, 16, 8),
    FragranceVoucersPromotionData._(48, 24, 12),
  ];
}
