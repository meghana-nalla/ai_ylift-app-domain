import 'package:YLift/core/constants/color.dart';

import 'package:flutter/material.dart';

import '../shipping_summary_panel.dart';

class ShippingStatusView extends StatelessWidget {
  final ShippingStatus status;
  final ShippingStatus groupValue;
  const ShippingStatusView({
    super.key,
    required this.status,
    required this.groupValue,
  });

  bool get isSelected => groupValue == status;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: isSelected ? YLiftColor.green : YLiftColor.grey2,
        shape: const StadiumBorder(),
      ),
      width: 200,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      alignment: Alignment.center,
      child: Text(
        status.label,
        style: TextStyle(color: isSelected ? Colors.white : Colors.black),
      ),
    );
  }
}
