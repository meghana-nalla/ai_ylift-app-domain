import 'package:YLift/core/controllers/global.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_models/core/core.dart';
import 'package:get/get.dart';

final _global = Get.find<GlobalController>();

class MobileProductPriceView extends StatelessWidget {
  final int? price;
  final int? listPrice;

  const MobileProductPriceView({
    super.key,
    required this.price,
    this.listPrice,
  });

  @override
  Widget build(BuildContext context) {
    if (listPrice == null || listPrice == 0 || price == null) {
      return const SizedBox.shrink();
    }
    final discount = ((listPrice! - price!) / listPrice! * 100).round();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (price! > 0) ...[
          Text(
            price!.toCurrency(),
            style: const TextStyle(
              fontSize: 18,
              color: YLiftColor.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
        if (listPrice! > price!)
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Row(
              children: [
                SizedBox(width: 8),
                Text(
                  '($discount% off)',
                  style: const TextStyle(
                    color: YLiftColor.orange,
                    fontSize: 14,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  listPrice!.toCurrency(),
                  style: const TextStyle(
                    fontSize: 14,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
