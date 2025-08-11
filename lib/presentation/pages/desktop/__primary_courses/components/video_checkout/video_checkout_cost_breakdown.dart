import 'package:flutter/material.dart';
import 'package:galaxy_ui/galaxy_ui.dart';

class VideoCheckoutCostBreakdown extends StatelessWidget {
  final String? address;
  final int? subtotal;
  final int? tax;
  final int? shippingCost;
  final int? total;

  const VideoCheckoutCostBreakdown({
    super.key,
    required this.address,
    required this.subtotal,
    required this.tax,
    required this.shippingCost,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Free Shipping',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            address ?? '(No selected address)',
            style: TextStyle(fontSize: 13.33),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Order Summary',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                CostRow(
                  'Subtotal',
                  subtotal,
                  style: TextStyle(fontSize: 13.33),
                ),
                CostRow(
                  'Estimated Tax',
                  tax,
                  style: TextStyle(fontSize: 13.33),
                ),
                CostRow(
                  'Estimated Shipping',
                  shippingCost,
                  style: TextStyle(fontSize: 13.33),
                ),
                const Divider(height: 32),
                CostRow(
                  'Estimated Item(s) Total',
                  total,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
