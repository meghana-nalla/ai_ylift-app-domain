import 'package:YLift/core/constants/color.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/core/extensions/price_extension.dart';
import 'package:YLift/hardcodes/promotions/fragrance_vouchers/galderma_promotion_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
class PracticeLuxuryPromotionDialog extends StatelessWidget {
  const PracticeLuxuryPromotionDialog({super.key});

  static final global = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    final isMobile = global.isMobile.isTrue;
    return Dialog(
      child: SizedBox(
        width: 800,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child:
                    isMobile
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Practice Luxury Promotion',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            CloseIconButton(),
                          ],
                        )
                        : Row(
                          children: [
                            const Spacer(),
                            Text(
                              'Practice Luxury Promotion',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 220),
                            CloseIconButton(),
                          ],
                        ),
              ),
              const SizedBox(height: 16),
              if (isMobile)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '- This promotion is eligible for double dipping with the first promotion',
                        style: TextStyle(fontSize: 11.11),
                      ),
                      Text(
                        '- All Restylane, Sculptra, and Dyport Products Qualify for the Promo',
                        style: TextStyle(fontSize: 11.11),
                      ),
                    ],
                  ),
                )
              else ...[
                Text(
                  '- This promotion is eligible for double dipping with the other promotion',
                  style: TextStyle(fontSize: 13.33),
                ),
                Text(
                  '- All Restylane, Sculptra, and Dyport Products Qualify for the Promo',
                  style: TextStyle(fontSize: 13.33),
                ),
              ],

              const SizedBox(height: 8),
              Image.network(PracticeLuxuryPromotionData.headerImageUrl),
              ...PracticeLuxuryPromotionData.list.map((e) {
                return Column(
                  children: [
                    Divider(
                      color: YLiftColor.grey3,
                      indent: 32,
                      endIndent: 32,
                      height: 64,
                    ),
                    Text(
                      'Tier ${e.tierLevel}: ${e.spendingThreshold.toCurrency()}',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: YLiftColor.orange,
                      ),
                    ),
                    Text(
                      e.productDescriptions,
                      style: isMobile ? TextStyle(fontSize: 13.33) : null,
                    ),
                    const SizedBox(height: 8),
                    Image.network(e.imageUrl),
                  ],
                );
              }),
              if(!isMobile) Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    RoundedFilledButton(
                      padding: const EdgeInsets.all(24),
                      onPressed: () {
                        final global = Get.find<GlobalController>();
                        final brands = global.brands.where(
                          (brand) =>
                              brand.vendorIds.any((vendorId) => vendorId == 19),
                        );
                        final brandIds = brands.map((e) => e.brandId!);
                        global.selectedBrandId.value =
                            'brand=${brandIds.join(',')}';
                        global.vroute.navigateTo('/shop/all');
                        Navigator.pop(context);
                      },
                      child: Text('Go to Galderma Products'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PracticeLuxuryTierDialog extends StatelessWidget {
  final PracticeLuxuryPromotionData promotion;
  const PracticeLuxuryTierDialog(this.promotion, {super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 640,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Practice Luxury Promotion Tier ${promotion.tierLevel}',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Spend ${promotion.spendingThreshold.toCurrency()}',
                          style: TextStyle(fontSize: 13.33),
                        ),
                      ],
                    ),
                    const Spacer(),
                    CloseIconButton(),
                  ],
                ),
              ),
              Image.network(promotion.imageUrl),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Close'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
