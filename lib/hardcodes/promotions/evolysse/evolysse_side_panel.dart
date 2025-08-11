import 'package:YLift/core/constants/color.dart';
import 'package:YLift/core/controllers/galderma_promotion/index.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/hardcodes/promotions/evolysse/evolysse_promotion.dart';
import 'package:YLift/presentation/components/_simple/promotion_side_panel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EvolysseSidePanel extends StatelessWidget {
  const EvolysseSidePanel({super.key});

  static final global = Get.find<GlobalController>();
  static final galdermaController = Get.find<GaldermaController>();

  static const _padding = EdgeInsets.symmetric(horizontal: 16);

  @override
  Widget build(BuildContext context) {
    return PromotionSidePanel(
      title: 'Evolysse Promotion Available',
      children: [
        Padding(
          padding: _padding,
          child: Text(
            'Buy 20 to 300 units of Evolysse Smooth and Evolysse Form products to get exclusive pricing of \$150 each!',
            style: TextStyle(fontSize: 11.11),
          ),
        ),
        const SizedBox(height: 8),

        // Padding(
        //   padding: _padding,
        //   child: Text('Note: Promotion is only applied to each product line of Evolysse.', style: TextStyle(fontSize: 11.11),),
        // ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Image.network(
                      EvolyssePromotion.bannerImageUrl,
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
  }
}
