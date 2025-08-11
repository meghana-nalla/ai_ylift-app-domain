import 'package:flutter/material.dart';
import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/presentation/pages/desktop/checkout/components/shipping_summary.dart';

import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:YLift/presentation/components/_complex/z-index_export.dart';

import 'components/shipping_status_stepper.dart';


const _vendors = <String>['Galderma', 'Benv'];

enum ShippingStatus {
  orderProcessing('Order Processing'),
  contactedDistributor('Contacted Distributor'),
  outForDelivery('Out of Delivery'),
  delivered('Delivered');

  final String label;
  const ShippingStatus(this.label);
}

class ShippingSummaryPanel extends StatefulWidget {
  const ShippingSummaryPanel({super.key});

  @override
  State<ShippingSummaryPanel> createState() => _ShippingSummaryPanelState();
}

class _ShippingSummaryPanelState extends State<ShippingSummaryPanel> {
  @override
  Widget build(BuildContext context) {
    return GalaxyPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Shipping Summary'),
          const SizedBox(height: YLiftConstant.gap),
          SizedBox(
            width: double.infinity,
            child: ShippingStatusStepper(
              currentStatus: ShippingStatus.orderProcessing,
            ),
          ),
          const SizedBox(height: YLiftConstant.gap),
          const ShippingSummaryHeader(),
          const Divider(height: 50),
          ListView.separated(
            shrinkWrap: true,
            itemCount: _vendors.length,
            separatorBuilder: (context, index) => const SizedBox(height: YLiftConstant.gap),
            itemBuilder: (context, index) {
              final vendor = _vendors[index];
              return ShippingSummaryRow(
                vendorName: vendor,
                shippingInformation: '65-32 Austin st Apt 62\n'
                    'Rego Park, NY, 11372',
                shippingSpeed: 'Express 2 days\n'
                    'Arrives by Wed, Oct 30',
              );
            },
          ),
        ],
      ),
    );
  }
}
