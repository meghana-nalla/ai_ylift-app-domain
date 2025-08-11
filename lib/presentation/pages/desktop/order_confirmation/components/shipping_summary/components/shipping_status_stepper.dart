import 'package:YLift/presentation/pages/desktop/order_confirmation/components/shipping_summary/components/shipping_status_view.dart';
import 'package:flutter/material.dart';

import '../shipping_summary_panel.dart';

class ShippingStatusStepper extends StatelessWidget {
  final ShippingStatus currentStatus;
  const ShippingStatusStepper({
    super.key,
    required this.currentStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        ShippingStatus.values.length * 2 - 1,
        (index) {
          if(index.isOdd) {
            return const Expanded(
            child: Divider(),
          );
          }
          final status = ShippingStatus.values[index~/2];

          return ShippingStatusView(
            status: status,
            groupValue: currentStatus,
          );
        },
      ),
    );
  }
}
