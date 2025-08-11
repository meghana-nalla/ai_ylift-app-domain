import 'package:YLift/core/constants/color.dart';
import 'package:YLift/core/controllers/galderma_promotion/index.dart';
import 'package:YLift/hardcodes/promotions/fragrance_vouchers/galderma_promotion_data.dart';
import 'package:YLift/hardcodes/promotions/practice_luxury/practice_luxury_select_gift_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewPracticeLuxuryOrderRule extends StatefulWidget {
  final PracticeLuxuryPromotionData promotion;
  const NewPracticeLuxuryOrderRule({super.key, required this.promotion});

  static final galdermaController = Get.find<GaldermaController>();

  @override
  State<NewPracticeLuxuryOrderRule> createState() =>
      _NewPracticeLuxuryOrderRuleState();
}

class _NewPracticeLuxuryOrderRuleState
    extends State<NewPracticeLuxuryOrderRule> {
  final galdermaController = Get.find<GaldermaController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                'Galderma Practice Luxury Tier ${widget.promotion.tierLevel}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.33,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              galdermaController.isRewardSelected
                  ? Icon(Icons.check, color: Colors.green, size: 13.33)
                  : const Icon(
                    Icons.info_outline,
                    color: YLiftColor.orange,
                    size: 13.33,
                  ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder:
                    (context) => PracticeLuxurySelectGiftDialog(
                      promotion: widget.promotion,
                    ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              width: double.infinity,
              child:
                  galdermaController.isRewardSelected
                      ? Text(
                        'Reward selected, click to edit.',
                        style: TextStyle(
                          fontSize: 13.33,
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                        ),
                      )
                      : Text(
                        'Select your tier ${widget.promotion.tierLevel} free gift',
                        style: TextStyle(
                          fontSize: 13.33,
                          color: YLiftColor.orange,
                          decoration: TextDecoration.underline,
                          decorationColor: YLiftColor.orange,
                        ),
                      ),
            ),
          ),
        ),
        if (galdermaController.selectedRewards.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              galdermaController.selectedRewards.first,
              style: TextStyle(
                fontSize: 11.11,
                height: 1.6,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}
