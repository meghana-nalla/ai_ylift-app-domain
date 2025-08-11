import 'package:YLift/core/constants/color.dart';
import 'package:YLift/core/controllers/galderma_promotion/index.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/core/extensions/price_extension.dart';
import 'package:YLift/hardcodes/promotions/spring_into_rewards/spring_into_rewards.dart';
import 'package:YLift/presentation/components/_complex/dialogs/mix_match_dialog.dart';
import 'package:YLift/presentation/components/_simple/promotion_side_panel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RefreshYourBeautySidePanel extends StatelessWidget {
  const RefreshYourBeautySidePanel({super.key});

  static final global = Get.find<GlobalController>();
  static final galdermaController = Get.find<GaldermaController>();

  static const _padding = EdgeInsets.symmetric(horizontal: 16);

  String get addMoreMessage {
    if (galdermaController.quantityForNextTier < 0) {
      return 'Remove ${galdermaController.quantityForNextTier.abs()} products';
    }
    if (galdermaController.isSpringPromotionApplicable) {
      return 'Add more';
    } else {
      return 'Add ${galdermaController.quantityForNextTier} more';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentPromotion = galdermaController.springIntoRewardsPromotion;
      return PromotionSidePanel(
        title: 'Refresh Your Beauty with Restylane Promotion',
        description: 'Get free packages for each qualifying purchase.',
        children: [
          Padding(
            padding: _padding,
            child: Text(
              'Buy a combination of HA Filler, Sculptra, and / or Dysport to get \$50 coupon codes.',
              style: TextStyle(fontSize: 11.11),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: _padding,
            child: Row(
              children: [
                Text('Current Reward: ', style: TextStyle(fontSize: 11.11)),
                if (galdermaController.isSpringPromotionApplicable == false)
                  Text('None', style: TextStyle(fontSize: 11.11))
                else
                  Text(
                    '${currentPromotion!.codeQuantityReward} coupon codes (${(currentPromotion.totalReward * 100).toCurrency()})',
                    style: TextStyle(
                      fontSize: 11.11,
                      color:
                      galdermaController.isSpringPromotionApplicable
                          ? null
                          : YLiftColor.orange,
                    ),
                  ),
                const SizedBox(width: 4),
                if (galdermaController.isSpringPromotionApplicable)
                  Icon(Icons.check_circle, color: Colors.green, size: 11.11),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: _padding,
            child: Text(
              'Total Galderma products in Cart: ${galdermaController.totalGaldermaCount}',
              style: TextStyle(fontSize: 11.11),
            ),
          ),

          // Add more button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Obx(() {
                      final products = global.allProducts.value
                          .getProductsByVendorIds(
                        vendorIds: [SpringIntoRewardsPromotion.vendorId],
                      );
                      return MixMatchDialog(
                        title: 'Spring Into Rewards',
                        groupName: 'Galderma',
                        isQualified:
                        galdermaController.isSpringPromotionApplicable,
                        description:
                        'Add ${galdermaController.quantityForNextTier} Galderma products for the promotion to be applicable',
                        qualifiedMessage:
                        'You are qualified for ${currentPromotion?.codeQuantityReward} coupon codes',
                        cart: global.simpleCart.value,
                        products: products,
                        quantityLeft: galdermaController.quantityForNextTier,
                        onProductQuantityChanged: (sku, newQuantity) async {
                          await global.basket.addToCart(
                              customerId: global.user.value.profileId.toString(),
                              quantity: newQuantity,
                              product: "${sku.productId}-${sku.skuId}"
                          );
                        },
                      );
                    });
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    addMoreMessage,
                    style: TextStyle(
                      fontSize: 11.11,
                      color: YLiftColor.orange,
                      decoration: TextDecoration.underline,
                      decorationColor: YLiftColor.orange,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: _padding,
            child: Text(
              '*You must buy the exact specified total quantity or the promotion will not be applicable!',
              style: TextStyle(fontSize: 11.11, color: YLiftColor.orange),
            ),
          ),

          const Divider(height: 16, endIndent: 16, indent: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
              SpringIntoRewardsPromotion.list.map((e) {
                return Text(
                  'Buy ${e.totalQuantity} Galderma products: Get ${e.codeQuantityReward} coupon codes',
                  style: TextStyle(fontSize: 11.11),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Image.network(
                        SpringIntoRewardsPromotion.bannerImageUrl,
                      ),
                    );
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Learn More >>',
                    style: TextStyle(
                      fontSize: 11.11,
                      color: YLiftColor.orange,
                      decoration: TextDecoration.underline,
                      decorationColor: YLiftColor.orange,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
