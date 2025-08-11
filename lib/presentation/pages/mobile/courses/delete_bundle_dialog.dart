import 'package:YLift/core/constants/color.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/components/_complex/know_y/knowy_training_image.dart';
import 'package:YLift/presentation/components/buttons/mobile_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:YLift/models/simple/CartSimple.dart';

class MobileDeleteBundleDialog extends StatefulWidget {
  final String tradeGoodId;
  final String title;
  final String skuNumber;

  final CartSimple cart;
  const MobileDeleteBundleDialog({
    super.key,
    required this.tradeGoodId,
    required this.title,
    required this.skuNumber,
    required this.cart,
  });

  @override
  State<MobileDeleteBundleDialog> createState() => _DeleteBundleDialogState();
}

class _DeleteBundleDialogState extends State<MobileDeleteBundleDialog> {
  bool isLoading = false;
  String? errorMessage;

  int get _unitsToRemove => widget.cart.tradeGoods
      .expand((tg) => tg.productIds)           // flatten to Iterable<Map<String,int>>
      .fold<int>(0, (t, m) => t + m.values.first); // add the single value in each map


  Future<void> _delete() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
      final global = Get.find<GlobalController>();
      await global.basket.removeTradeGood(widget.tradeGoodId);
      if (!mounted) return;
      Navigator.pop(context); // success ⇒ close and return
    } catch (_) {
      if (!mounted) return;
      setState(() {
        errorMessage = 'Failed to delete bundle, please try again later.';
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      insetPadding: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Title & Close ────────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Remove ${widget.cart.tradeGoods.first.goodsTradingName} Video Course',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                MobileIcon(
                  onPressed: () => Navigator.pop(context),
                  icon: Icons.close,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── Body copy ────────────────────────────────────────────────────
            Text(
              'Are you sure you want to remove this video course? This action will remove $_unitsToRemove Radiesse from your cart as well. ',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 24),

            if (errorMessage != null)
              Text(errorMessage!, style: const TextStyle(color: Colors.red)),

            // ── Delete CTA ───────────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: YLiftColor.orange,
                  side: const BorderSide(color: YLiftColor.orange, width: 1),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  textStyle: const TextStyle(fontSize: 14, letterSpacing: 1),
                ),
                onPressed: isLoading ? null : _delete,
                child: const Text('Delete Bundle'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
