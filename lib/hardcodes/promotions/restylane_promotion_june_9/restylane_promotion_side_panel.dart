import 'package:YLift/core/constants/color.dart';
import 'package:YLift/hardcodes/constants/ids.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/hardcodes/promotions/restylane_promotion_june_9/restylane_promotion.dart';
import 'package:YLift/presentation/components/_complex/dialogs/mix_match_dialog.dart';
import 'package:YLift/presentation/components/_simple/promotion_side_panel.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:get/get.dart';

class RestylanePromotionSidePanel extends StatelessWidget {
  const RestylanePromotionSidePanel({super.key});

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.symmetric(horizontal: 16);

    return Obx(() {
      final currentPromotion = RestylanePromotionData.getCurrentPromotion();
      final nextPromotion = RestylanePromotionData.getNextPromotion();

      return PromotionSidePanel(
        title: 'Restylane Promotion Available',
        children: [
          Padding(
            padding: padding,
            child: Text(
              'Receive a pair of designer sunglasses and free vouchers with your Restylane purchase.',
              style: TextStyle(fontSize: 11.11),
            ),
          ),
          const SizedBox(height: 8),

          Padding(
            padding: padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...RestylanePromotionData.list.map(
                  (promotion) => Row(
                    children: [
                      Text(
                        'Buy ${promotion.qualifyingQuantity}, get ${promotion.freeVouchers} free vouchers',
                        style: TextStyle(fontSize: 11.11, height: 2),
                      ),
                      const SizedBox(width: 8),
                      if (RestylanePromotionData.totalRestylaneQuantity ==
                          promotion.qualifyingQuantity)
                        ActiveIcon(true, size: 12),
                    ],
                  ),
                ),

                const SizedBox(height: 8),
                Text(
                  'Total Restylane in Cart: ${RestylanePromotionData.restylaneItems.fold<int>(0, (sum, item) => sum + item.quantity)}',
                  style: TextStyle(fontSize: 11.11),
                ),
                const SizedBox(height: 8),
                if (currentPromotion != null)
                  Text(
                    'You get ${currentPromotion.freeVouchers} free vouchers upon checkout.',
                    style: TextStyle(fontSize: 11.11, color: YLiftColor.orange),
                  ),
              ],
            ),
          ),

          if (nextPromotion != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: InkWell(
                onTap: () {
                  final global = Get.find<GlobalController>();
                  final profileId = global.user.value.profileId;
                  showDialog(
                    context: context,
                    builder:
                        (context) => Obx(() {
                          return MixMatchDialog(
                            title:
                                'Add ${nextPromotion.qualifyingQuantity - RestylanePromotionData.totalRestylaneQuantity} more Restylane',
                            groupName: 'brand',
                            cart: global.simpleCart.value,
                            products: global.allProducts.value
                                .getProductsByBrandIds(
                                  brandIds: [BrandId.restylane],
                                ),
                            quantityLeft:
                                nextPromotion.qualifyingQuantity -
                                RestylanePromotionData.totalRestylaneQuantity,
                            description:
                                'Add ${nextPromotion.qualifyingQuantity - RestylanePromotionData.totalRestylaneQuantity} more Restylane to your cart to qualify for the promotion.',
                            expandSkus: true,
                            onProductQuantityChanged: (sku, newQuantity) async {
                              await global.basket.addToCart(
                                customerId:
                                    global.user.value.profileId.toString(),
                                quantity: newQuantity,
                                product: "${sku.productId}-${sku.skuId}",
                              );
                            },
                          );
                        }),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Add ${nextPromotion.qualifyingQuantity - RestylanePromotionData.totalRestylaneQuantity} more and get ${nextPromotion.freeVouchers} provider codes',
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

          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Image.network(RestylanePromotionData.imageUrl),
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
