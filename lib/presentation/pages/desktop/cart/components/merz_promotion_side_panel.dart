import 'package:YLift/core/constants/color.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/core/extensions/price_extension.dart';
import 'package:YLift/presentation/components/_complex/desktop_view/panel.dart';
import 'package:YLift/presentation/pages/desktop/cart/components/black_side_panel.dart';
import 'package:YLift/presentation/pages/desktop/cart/components/merz_promotion_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MerzPromotionSidePanel extends StatelessWidget {
  MerzPromotionSidePanel({super.key});

  final global = Get.find<GlobalController>();

  bool get hasMerzPromotion => global.simpleCart.value.hasMerzPromotion;

  String get freeSyringeMessage {
    final freeSyringes = global.simpleCart.value.merzPromotion!.freeSyringes;
    final boxes = global.simpleCart.value.merzPromotion!.freeBoxes;
    final boxUnit = boxes > 1 ? 'boxes' : 'box';
    return 'You get $boxes free $boxUnit! ($freeSyringes syringes)';
  }

  String get groupedSyringeMessages {
    final merzPromotion = global.simpleCart.value.merzPromotion;
    var cartSyringes = global.simpleCart.value.merzTotalSyringes;
    if (merzPromotion == null) return 'Syringes: $cartSyringes';
    return 'Syringes: ${cartSyringes + merzPromotion.freeSyringes} ($cartSyringes + ${merzPromotion.freeSyringes} free)';
  }

  int get syringeUnitPriceWithPromotion {
    final totalCost = global.simpleCart.value.merzTotalCost;
    final totalSyringes =
        global.simpleCart.value.merzTotalSyringes +
        global.simpleCart.value.merzPromotion!.freeSyringes;
    final unitPrice = totalCost / totalSyringes;
    return unitPrice.round();
  }

  @override
  Widget build(BuildContext context) {
    return BlackSidePanel(
      title: Text('Merz Promotion'),
      headerIcon:
          global.simpleCart.value.merzPromotion != null
              ? Icon(Icons.check, color: Colors.green, size: 13.33)
              : null,
      childrenPadding: EdgeInsets.symmetric(horizontal: 16),
      children: [
        Text(
          'Free syringes',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        if (global.simpleCart.value.hasMerzPromotion) ...[
          Text(freeSyringeMessage),
          const SizedBox(height: 4),
        ],
        Text(
          global.simpleCart.value.merzPromotionMessage!,
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => MerzPromotionDialog(),
            );
          },
          child: Text(
            'Learn more >>',
            style: TextStyle(
              color: YLiftColor.orange,
              decoration: TextDecoration.underline,
              decorationColor: YLiftColor.orange,
            ),
          ),
        ),
        const Divider(height: 32),
        Row(
          children: [
            Text(
              'BootYLift Training',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            if (global.simpleCart.value.bootYliftIncluded)
              Icon(Icons.check_circle, color: Colors.green, size: 13.33),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Buy 30+ boxes and get free bootYLift training!',
        ),
        if (!global.simpleCart.value.bootYliftIncluded) ...[
          const SizedBox(height: 4),
          Text(
            'Add ${30 - global.simpleCart.value.merzTotalBoxes} more for this offer',
          ),
        ],
        const Divider(height: 32),
        Row(
          children: [
            Text('Syringes: '),
            Text(groupedSyringeMessages),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text('Total Cost: '),
            Text(
              global.simpleCart.value.merzTotalCost.toCurrency(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 4),
        if (hasMerzPromotion)
          Row(
            children: [
              Text('Unit Price with Promotion: '),
              Text(
                global.simpleCart.value.merzSyringeUnitPriceWithPromotion
                    .toCurrency(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          )
        else
          Row(
            children: [
              Text('Unit Price: '),
              Text(
                (global.simpleCart.value.merzTotalCost /
                        global.simpleCart.value.merzTotalSyringes)
                    .toCurrency(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
      ],
    );
    return GalaxyPanel(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Merz Promotion Available',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const Divider(),
          Text('Free syringes', style: TextStyle(fontSize: 13.33)),
          const SizedBox(height: 4),
          if (global.simpleCart.value.hasMerzPromotion) ...[
            Text(
              freeSyringeMessage,
              style: TextStyle(fontSize: 11.11),
            ),
            const SizedBox(height: 4),
          ],
          Text(
            global.simpleCart.value.merzPromotionMessage!,
            style: TextStyle(fontSize: 11.11, color: YLiftColor.orange),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => MerzPromotionDialog(),
              );
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
          const Divider(),
          Row(
            children: [
              Text('BootYLift Training', style: TextStyle(fontSize: 13.33)),
              const Spacer(),
              if (global.simpleCart.value.bootYliftIncluded)
                Icon(Icons.check_circle, color: Colors.green, size: 13.33),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Buy 30+ boxes and get free bootYLift training!',
            style: TextStyle(fontSize: 11.11),
          ),
          if (!global.simpleCart.value.bootYliftIncluded) ...[
            const SizedBox(height: 4),
            Text(
              'Add ${30 - global.simpleCart.value.merzTotalBoxes} more for this offer',
              style: TextStyle(fontSize: 11.11, color: YLiftColor.orange),
            ),
          ],
          const Divider(),
          Row(
            children: [
              Text('Syringes: ', style: TextStyle(fontSize: 11.11)),
              Text(
                groupedSyringeMessages,
                style: TextStyle(fontSize: 11.11, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text('Total Cost: ', style: TextStyle(fontSize: 11.11)),
              Text(
                global.simpleCart.value.merzTotalCost.toCurrency(),
                style: TextStyle(fontSize: 11.11, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 4),
          if (hasMerzPromotion)
            Row(
              children: [
                Text(
                  'Unit Price with Promotion: ',
                  style: TextStyle(fontSize: 11.11),
                ),
                Text(
                  global.simpleCart.value.merzSyringeUnitPriceWithPromotion
                      .toCurrency(),
                  style: TextStyle(
                    fontSize: 11.11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          else
            Row(
              children: [
                Text('Unit Price: ', style: TextStyle(fontSize: 11.11)),
                Text(
                  (global.simpleCart.value.merzTotalCost /
                          global.simpleCart.value.merzTotalSyringes)
                      .toCurrency(),
                  style: TextStyle(
                    fontSize: 11.11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
