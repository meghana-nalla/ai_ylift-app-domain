import 'package:YLift/core/constants/constant.dart';

class SpringIntoRewardsPromotion {
  final String tierName;
  final int totalQuantity;
  final int codeQuantityReward;

  int get totalReward => codeQuantityReward * 50;

  const SpringIntoRewardsPromotion._(
    this.tierName,
    this.totalQuantity,
    this.codeQuantityReward,
  );

  static const bannerImageUrl =
      '${YLiftConstant.baseImageUrl}/apr_14_galderma.png';
  static const vendorId = 19; // Galderma vendor id
  static final expirationDate = DateTime(2025, 5, 2, 23, 59, 59); // May 2, 2025

  static bool get isOngoing => DateTime.now().isBefore(expirationDate);

  static const list = <SpringIntoRewardsPromotion>[
    SpringIntoRewardsPromotion._('Tier 3', 20, 12), // tier 3
    SpringIntoRewardsPromotion._('Tier 3', 40, 24), // tier 3
    SpringIntoRewardsPromotion._('Tier 2', 60, 60), // tier 2
    SpringIntoRewardsPromotion._('Tier 2', 80, 80), // tier 2
    SpringIntoRewardsPromotion._('Tier 1', 150, 175), // tier 1
    SpringIntoRewardsPromotion._('Tier 1', 200, 250), // tier 1
  ];
}
