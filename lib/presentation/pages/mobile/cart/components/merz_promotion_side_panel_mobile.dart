import 'package:YLift/core/constants/color.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MerzPromotionSidePanelMobile extends StatelessWidget {
  MerzPromotionSidePanelMobile({super.key});

  final global = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    if (!global.simpleCart.value.hasMerzPromotion) return const SizedBox.shrink();

    final message = global.simpleCart.value.merzPromotionMessage ?? '';
    final boxes = global.simpleCart.value.merzPromotion?.freeBoxes ?? 0;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Merz Promotion', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            SizedBox(height: 6),
            Text('Free syringes: $boxes boxes', style: TextStyle(fontSize: 12)),
            if (message.isNotEmpty) ...[
              SizedBox(height: 3),
              Text(message, style: TextStyle(color: YLiftColor.orange, fontSize: 12)),
            ],
            SizedBox(height: 8),
            Text('Learn more >>', style: TextStyle(fontSize: 12, color: YLiftColor.orange, decoration: TextDecoration.underline),
              // You could add tap to show modal with more info
            ),
          ],
        ),
      ),
    );
  }
}
