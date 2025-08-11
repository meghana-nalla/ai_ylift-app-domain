import 'package:YLift/core/constants/color.dart';
import 'package:flutter/material.dart';

class PromotionAvailableChip extends StatelessWidget {
  final void Function()? onTap;
  const PromotionAvailableChip({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    Widget chip = Container(
      decoration: BoxDecoration(
        color: YLiftColor.promotionQualified,
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Text(
        'Promotion Available!',
        style: TextStyle(fontSize: 11.11, color: Colors.white),
      ),
    );

    if (onTap != null) {
      chip = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(onTap: onTap, child: chip),
      );
    }

    return chip;
  }
}
