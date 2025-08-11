import 'package:YLift/core/constants/color.dart';
import 'package:YLift/core/controllers/galderma_promotion/index.dart';
import 'package:YLift/hardcodes/promotions/fragrance_vouchers/galderma_promotion_data.dart';
import 'package:YLift/hardcodes/promotions/practice_luxury/practice_luxury_select_gift_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PracticeLuxuryOrderRule extends StatefulWidget {
  final PracticeLuxuryPromotionData promotion;
  const PracticeLuxuryOrderRule({super.key, required this.promotion});

  static final galdermaController = Get.find<GaldermaController>();

  @override
  State<PracticeLuxuryOrderRule> createState() =>
      _PracticeLuxuryOrderRuleState();
}

class _PracticeLuxuryOrderRuleState extends State<PracticeLuxuryOrderRule> {
  final tapRecognizer = TapGestureRecognizer();
  final galdermaController = Get.find<GaldermaController>();

  @override
  void initState() {
    tapRecognizer.onTap = () {
      showDialog(
        context: context,
        builder:
            (context) =>
            PracticeLuxurySelectGiftDialog(promotion: widget.promotion),
      );
    };
    super.initState();
  }

  @override
  void dispose() {
    tapRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Galderma Practice Luxury Tier ${widget.promotion.tierLevel}',
              style: TextStyle(fontSize: 13.33),
            ),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 11.11),
                children: [
                  TextSpan(
                    text:
                    'Select your tier ${widget.promotion.tierLevel} free gift',
                    recognizer: tapRecognizer,
                    style: TextStyle(
                      color: YLiftColor.orange,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: YLiftColor.orange,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Spacer(),
        Obx(() {
          return Padding(
            padding: const EdgeInsets.only(top: 2),
            child:
            galdermaController.isRewardSelected
                ? Icon(
              Icons.check_circle,
              color: YLiftColor.green,
              size: 13.33,
            )
                : Icon(Icons.cancel, color: YLiftColor.orange, size: 13.33),
          );
        }),
      ],
    );
  }
}