import 'package:YLift/core/constants/color.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/core/extensions/price_extension.dart';
import 'package:YLift/hardcodes/promotions/dysport_promotion_june_9/dysport_promotion.dart';
import 'package:YLift/presentation/components/_simple/promotion_side_panel.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:get/get.dart';

class DysportPromotionSidePanel extends StatelessWidget {
  const DysportPromotionSidePanel({super.key});

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.symmetric(horizontal: 16);

    return Obx(() {
      final currentPromotion = DysportPromotionData.getCurrentPromotion();
      final nextPromotion = DysportPromotionData.getNextPromotion();

      return PromotionSidePanel(
        title: 'Dysport Promotion Available',
        children: [
          Padding(
            padding: padding,
            child: Text(
              'Get exclusive savings of \$50 for each provider code with each qualifying Dysport purchase.',
              style: TextStyle(fontSize: 11.11),
            ),
          ),
          const SizedBox(height: 8),

          Padding(
            padding: padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...DysportPromotionData.list.map(
                  (promotion) => Row(
                    children: [
                      Text(
                        'Buy ${promotion.qualifyingQuantity}, get ${promotion.providerCodes} provider codes',
                        style: TextStyle(fontSize: 11.11, height: 2),
                      ),
                      const SizedBox(width: 8),
                      if (DysportPromotionData.totalDysportQuantity ==
                          promotion.qualifyingQuantity)
                        ActiveIcon(true, size: 12),
                    ],
                  ),
                ),

                const SizedBox(height: 8),
                Text(
                  'Total Dysport in Cart: ${DysportPromotionData.dysportItems.fold<int>(0, (sum, item) => sum + item.quantity)}',
                  style: TextStyle(fontSize: 11.11),
                ),
                const SizedBox(height: 8),
                if (currentPromotion != null)
                  Text(
                    'You get ${currentPromotion.providerCodes} provider codes (${(currentPromotion.providerCodes * 5000).toCurrency()} savings).',
                    style: TextStyle(fontSize: 11.11, color: YLiftColor.orange),
                  )
                // else if (nextPromotion != null)
                //   Text(
                //     'Add ${nextPromotion.qualifyingQuantity - DysportPromotionData.totalDysportQuantity} more Dysport and get ${nextPromotion.providerCodes} provider codes!',
                //     style: TextStyle(fontSize: 11.11, color: YLiftColor.orange),
                //   ),
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
                  global.basket.updateCartItemQuantity(
                    profileId: '$profileId',
                    quantity: nextPromotion.qualifyingQuantity,
                    product: '554-2237',
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
                      'Add ${nextPromotion.qualifyingQuantity - DysportPromotionData.totalDysportQuantity} more and get ${nextPromotion.providerCodes} provider codes',
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
                      content: Image.network(DysportPromotionData.imageUrl),
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
