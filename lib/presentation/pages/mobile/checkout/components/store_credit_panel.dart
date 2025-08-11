import 'package:YLift/presentation/components/mobile_panel.dart';
import 'package:YLift/presentation/components/store_credit_loader.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_models/core/core.dart';

class MobileStoreCreditPanel extends StatelessWidget {
  final bool useStoreCredit;
  final void Function(int? value) onChanged;

  const MobileStoreCreditPanel({
    super.key,
    required this.useStoreCredit,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return StoreCreditLoader(
      builder: (context, balance) {
        return MobilePanel(
          padding: EdgeInsets.only(top: 16, bottom: 8),
          margin: const EdgeInsets.only(top: 16),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Text(
                'Store Credit: ${balance.toCurrency()}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // GestureDetector(
            //   onTap: () {
            //     useStoreCredit ? onChanged(null) : onChanged(balance);
            //   },
            //   child: Row(
            //     children: [
            //       const SizedBox(width: 8),
            //       Transform.scale(
            //         scale: 0.8,
            //         child: Checkbox(
            //           visualDensity: VisualDensity.compact,
            //           value: useStoreCredit,
            //           onChanged: (value) {
            //             onChanged(value == true ? balance : null);
            //           },
            //         ),
            //       ),
            //       Text(
            //         'Apply store credit to this order',
            //         style: TextStyle(fontSize: 12),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        );
      },
    );
  }
}
