import 'dart:async';

import 'package:YLift/core/constants/color.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/components/_complex/dialogs/select_merz_dialog.dart';
import 'package:YLift/presentation/pages/desktop/cart/components/merz_promotion_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MerzOrderRule extends StatefulWidget {
  final MerzSyringePromotion merzPromotion;
  const MerzOrderRule({
    super.key,
    required this.merzPromotion,
  });

  @override
  State<MerzOrderRule> createState() => _MerzOrderRuleState();
}

class _MerzOrderRuleState extends State<MerzOrderRule> {
  final tapRecognizer = TapGestureRecognizer();
  final global = Get.find<GlobalController>();
  bool isFlashing = false;
  Timer? _timer;

  bool get isQualified => global.simpleCart.value.merzTotalFreeSyringes == widget.merzPromotion.freeSyringes;

  @override
  void initState() {
    super.initState();
    tapRecognizer.onTap = showMerzDialog;

    // Start flashing effect when not qualified
    if (!isQualified) {
      _startFlashing();
    }
  }

  void _startFlashing() {
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        isFlashing = !isFlashing;
      });
    });
  }

  void _stopFlashing() {
    _timer?.cancel();
    setState(() {
      isFlashing = false;
    });
  }

  @override
  void dispose() {
    tapRecognizer.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void showMerzDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Obx(() {
          return SelectMerzDialog(
            merzPromotion: global.simpleCart.value.merzPromotion!,
            title: 'Select your ${widget.merzPromotion.freeBoxes} free boxes (${widget.merzPromotion.freeSyringes} syringes)',
            products: global.allProducts.value.getProductsByBrandIds(brandIds: [MerzSyringePromotion.brandId]),
            freeItems: global.simpleCart.value.merzFreeItems,
            maxQuantity: widget.merzPromotion.freeBoxes,
            onProductQuantityChanged: (sku, newQuantity) {
              global.basket.addFreeItem(product: sku.combinedId, quantity: newQuantity);
            },
          );
        });
      },
    );
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
              'Merz',
              style: TextStyle(fontSize: 13.33),
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: isQualified ? 1.0 : (isFlashing ? 0.3 : 1.0), // Flashing effect
              child: RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 11.11),
                  children: [
                    TextSpan(
                      text: 'Select your ${widget.merzPromotion.freeBoxes} free boxes (${widget.merzPromotion.freeSyringes} syringes)',
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
            ),
            ...global.simpleCart.value.merzFreeItems.map((freeItem) {
              return Text(
                '${freeItem.productName}: ${freeItem.quantity} boxes (${freeItem.quantity * 2} syringes)',
                style: TextStyle(fontSize: 11.11, height: 1.6),
              );
            }),
          ],
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: isQualified
              ? Icon(Icons.check_circle, color: YLiftColor.green, size: 13.33)
              : Icon(Icons.cancel, color: YLiftColor.orange, size: 13.33),
        ),
      ],
    );
  }
}
