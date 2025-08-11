import 'package:YLift/core/constants/index.dart';
import 'package:YLift/core/extensions/price_extension.dart';
import 'package:YLift/presentation/components/_simple/lock_pricing_chip.dart';
import 'package:YLift/presentation/components/_simple/promo_indicator.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../core/constants/color.dart';
import '../../../../core/controllers/global.dart';
import 'package:galaxy_ui/galaxy_ui.dart';

class ProductSuggestionTile extends StatelessWidget {
  final String name;
  final String? subtitle;
  final int? listPrice;
  final int price;
  final String imageUrl;
  final bool isGalderma;
  final int? vendorId;

  final bool? hasPromotion;
  final void Function() onTap;

  final GlobalController global = Get.find<GlobalController>();

  ProductSuggestionTile({
    super.key,
    required this.name,
    this.subtitle,
    this.listPrice,
    this.hasPromotion,
    this.isGalderma = false,
    required this.price,
    required this.imageUrl,
    required this.onTap,
    this.vendorId,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 120,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  imageUrl,
                  errorBuilder: (context, error, stackTrace) => Image.network(
                    PLACEHOLDER_IMAGE,
                    fit: BoxFit.cover,
                  ),
                )
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11.11,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 11.11,
                        color: Color(0xFF343434),
                      ),
                    ),
                  const Spacer(),
                  if (global.isAuthenticated.value && price > 0 && price != double.infinity) ...[
                    if (listPrice == null || listPrice == 0) ...[
                      CurrencyText(price / 100)
                    ] else ...[
                      Row(
                        children: [
                          Text(
                      price.toCurrency(),
                            style: TextStyle(color: YLiftColor.orange, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          if (listPrice != null && listPrice! > price) ...[
                            Text(
                              listPrice!.toCurrency(),
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontSize: 13.33,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: YLiftColor.orange),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              child: (listPrice != 0) ? Text(
                                'Save ${((listPrice! - price) * 100) ~/ listPrice!}%',
                                style: TextStyle(fontSize: 11.11, color: YLiftColor.orange),
                              ) : SizedBox(height: 1),
                            ),
                          ],
                        ],
                      )
                    ],
                  ] else ... [
                    LockPricingChip(vendorId: vendorId),
                  ],
                ],
              ),
              if (hasPromotion != null && hasPromotion!) ...[
                const Spacer(),
                const PromoIndicator(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
