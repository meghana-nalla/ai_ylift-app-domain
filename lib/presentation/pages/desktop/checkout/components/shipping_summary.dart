import 'package:flutter/material.dart';
import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/core/constants/text_style.dart';
import 'package:YLift/presentation/components/z-index_export.dart'  hide RoundedFilledButton, UnderlinedTextButton;


import 'package:YLift/core/controllers/global.dart';
import 'package:get/get.dart';

import 'package:galaxy_ui/galaxy_ui.dart';

import '../../../../../core/constants/color.dart';

const _vendors = <String>['Galderma', 'Benv'];

class ShippingSummary extends StatefulWidget {
  const ShippingSummary({
    super.key,
    required this.controller,
  });

  final GlobalController controller;

  @override
  State<StatefulWidget> createState() => _ShippingSummaryState();
}

class _ShippingSummaryState extends State<ShippingSummary> {

  // if there are no vendor items, throw this error
  int _handleNoVendorItems() {
    throw('Error: cart.value.numberOfVendorItems was null');
    return 0;
  }

  // keep track of loading info
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.controller.cart.value.numberOfVendorItems == null) {
      setState(() {
        _isLoading = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return GalaxyPanel(
      child: (_isLoading)
          ? GalaxyHorizontalProgressBar(showLoadingBar: widget.controller.showLoadingBar.isTrue,backgroundColor: YLiftColor.orange,)
          : Column(
        children: [
          const ShippingSummaryHeader(),
          const Divider(height: 50),
          ListView.separated(
            shrinkWrap: true,
            itemCount: (widget.controller.cart.value.numberOfVendorItems != null)
                ? widget.controller.cart.value.numberOfVendorItems!
                : _handleNoVendorItems(),
            separatorBuilder: (context, index) => const SizedBox(height: YLiftConstant.gap),
            itemBuilder: (context, index) {
              final vendor = _vendors[index];
              return ShippingSummaryRow(
                vendorName: vendor,
                shippingInformation: '65-32 Austin st Apt 62\n'
                    'Rego Park, NY, 11372\n'
                    '(656)678-2929\n'
                    'info@ylift.com',
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

class ShippingSummaryHeader extends StatelessWidget {
  final void Function()? onEdit;

  const ShippingSummaryHeader({
    super.key,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    Widget shippingSpeed = const Text('Shipping Speed');
    if (onEdit != null) {
      shippingSpeed = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          shippingSpeed,
          UnderlinedTextButton(
            text: 'Edit',
            onPressed: onEdit!,
          ),
        ],
      );
    }

    return Row(
      children: [
        const Expanded(
          flex: 1,
          child: Text('Vendor'),
        ),
        const Expanded(
          flex: 2,
          child: Text('Shipping Information'),
        ),
        Expanded(
          flex: 2,
          child: shippingSpeed,
        ),
      ],
    );
  }
}

class ShippingSummaryRow extends StatelessWidget {
  final String vendorName;
  final String shippingInformation;
  final String shippingSpeed;

  const ShippingSummaryRow({
    super.key,
    required this.vendorName,
    required this.shippingInformation,
    required this.shippingSpeed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Text(vendorName),
        ),
        Expanded(
          flex: 2,
          child: Text(
            shippingInformation,
            style: YLiftTextStyle.descriptionGrey,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            shippingSpeed,
            style: YLiftTextStyle.descriptionGrey,
          ),
        ),
      ],
    );
  }
}
