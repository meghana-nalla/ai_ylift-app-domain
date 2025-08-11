import 'package:YLift/core/constants/color.dart';
import 'package:YLift/core/controllers/galderma_promotion/index.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/core/extensions/price_extension.dart';
import 'package:YLift/hardcodes/promotions/fragrance_vouchers/fragrance_vouchers_promotion_data.dart';
import 'package:YLift/hardcodes/promotions/fragrance_vouchers/fragrance_vouchers_promotion_dialog.dart';
import 'package:YLift/presentation/components/_complex/desktop_view/panel.dart';
import 'package:YLift/hardcodes/promotions/fragrance_vouchers/galderma_promotion_data.dart';
import 'package:YLift/hardcodes/promotions/practice_luxury/practice_luxury_promotion_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GaldermaPromotionSideGalaxyPanel extends StatelessWidget {
  GaldermaPromotionSideGalaxyPanel({super.key});

  final global = Get.find<GlobalController>();
  final galdermaController = Get.find<GaldermaController>();

  void showFragranceVouchersDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => FragranceVouchersPromotionDialog());
  }

  @override
  Widget build(BuildContext context) {
    return GalaxyPanel(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Galderma Promotion Available', style: TextStyle(fontWeight: FontWeight.w600)),
            const Divider(),
            Text('Promo 1: Fragrance Vouchers', style: TextStyle(fontSize: 13.33)),
            Text('Get fragrance vouchers on each qualifying purchase.', style: TextStyle(fontSize: 11.11)),
            Text('Total Restylane in Cart: ${galdermaController.restylaneCount}', style: TextStyle(fontSize: 11.11)),
            Text('Total Sculptra in Cart: ${galdermaController.sculptraCount}', style: TextStyle(fontSize: 11.11)),
            ...FragranceVoucersPromotionData.list.map((e) {
              final promotion = galdermaController.fragranceVouchersPromotion;
              return InkWell(
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      children: [
                        Text(
                          '${e.restylaneCount} Restylane or ${e.sculptraCount} Sculptra: Get ${e.voucherCount} vouchers',
                          style: TextStyle(fontSize: 11.11),
                        ),
                        if (promotion != null && promotion.voucherCount == e.voucherCount) ...[
                          const SizedBox(width: 8),
                          Icon(Icons.check_circle, color: Colors.green, size: 11.11),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 4),
            GestureDetector(
              onTap: () => showFragranceVouchersDialog(context),
              child: Text(
                'Learn more >>',
                style: TextStyle(
                  fontSize: 11.11,
                  color: YLiftColor.orange,
                  decoration: TextDecoration.underline,
                  decorationColor: YLiftColor.orange,
                ),
              ),
            ),
            const Divider(),
            Text('Promo 2: Practice & Luxury Goods', style: TextStyle(fontSize: 13.33)),
            Text('Get luxury goods on each qualifying purchase.', style: TextStyle(fontSize: 11.11)),
            const SizedBox(height: 4),
            Text(
              'Current spending on Galderma: ${galdermaController.galdermaTotal.toCurrency()}',
              style: TextStyle(fontSize: 11.11),
            ),
            if (galdermaController.nextTierPromotion != null) ...[
              const SizedBox(height: 4),
              Text(
                'Spend ${galdermaController.spendingLeftForNextTier.toCurrency()} more to reach Tier ${galdermaController.nextTierPromotion!.tierLevel}.',
                style: TextStyle(fontSize: 11.11, color: YLiftColor.orange),
              ),
            ],
            const SizedBox(height: 4),
            GestureDetector(
              onTap: () {
                showDialog(context: context, builder: (context) => PracticeLuxuryPromotionDialog());
              },
              child: Text(
                'Learn more >>',
                style: TextStyle(
                  fontSize: 11.11,
                  color: YLiftColor.orange,
                  decoration: TextDecoration.underline,
                  decorationColor: YLiftColor.orange,
                ),
              ),
            ),
            const SizedBox(height: 4),
            ...PracticeLuxuryPromotionData.list.map((e) {
              final currentPromotion = galdermaController.currentTierPromotion;
              return InkWell(
                onTap: () {
                  showDialog(context: context, builder: (context) => PracticeLuxuryTierDialog(e));
                },
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      children: [
                        Text(
                          'Tier ${e.tierLevel}: Spend ${e.spendingThreshold.toCurrency()}',
                          style: TextStyle(fontSize: 11.11),
                        ),
                        if (currentPromotion != null && currentPromotion.tierLevel == e.tierLevel) ...[
                          const SizedBox(width: 8),
                          Icon(Icons.check_circle, color: Colors.green, size: 11.11),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}