import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/core/constants/text_style.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:YLift/presentation/pages/desktop/cart/components/shipping_options.dart';
import 'package:flutter/material.dart';

class MobileShippingOptions extends StatelessWidget {
  final SkuSimple sku;
  final AddressSimple? address;
  final ShippingType? shippingType;
  final ShippingSettingsSimple? options;
  final bool allowChangeAddress;
  final Widget? trailing;
  final int total;

  final void Function(int newRate)? onSelectedRate;
  final void Function(ShippingType type)? onSelectedShippingType;

  const MobileShippingOptions({
    super.key,
    required this.sku,
    this.address,
    required this.total,
    this.options,
    this.allowChangeAddress = true,
    this.onSelectedRate,
    this.shippingType,
    this.onSelectedShippingType,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.local_shipping_outlined, size: 32),
            const SizedBox(width: 8),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Shipping Options', style: TextStyle(fontSize: 13.33)),
                  Text(
                    address?.display ?? 'No address',
                    style: TextStyle(fontSize: 11.11),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildOptions(),
      ],
    );
  }

  Widget _buildOptions() {
    if (shippingType != null &&
        shippingType != "NONE" &&
        total == 0) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Free shipping',
              style:
              YLiftTextStyle.bodyLarge.copyWith(color: YLiftColor.orange)),
        ],
      );
    }

    if (options != null && options!.isFlatRate) {
      final regularRate = options?.regularRate ?? 0;
      if (regularRate == 0) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Free shipping',
                // style: YLiftTextStyle.bodyLarge
                //     .copyWith(color: YLiftColor.orange),
            ),
          ],
        );
      }
      return ShippingOption(
        isSelected: true,
        onTap: () => onSelectedShippingType!(ShippingType.regular),
        labelText: 'Flat Rate \$${(options?.regularRate ?? 0) / 100}',
      );
    }

    return OverflowBar(
      children: [
        if((options?.regularRate ?? 0) > 0) ShippingOption(
          isSelected: shippingType == ShippingType.regular,
          onTap: () => onSelectedShippingType!(ShippingType.regular),
          labelText:
          'Regular Ground \$${(options?.regularRate ?? 0) / 100}',
        ),
        if((options?.expressRate ?? 0) > 0) ShippingOption(
          isSelected: shippingType == ShippingType.express,
          onTap: () => onSelectedShippingType!(ShippingType.express),
          labelText:
          'Express 2 Days \$${(options?.expressRate ?? 0) / 100}',
        ),
        if((options?.overnightRate ?? 0) > 0) ShippingOption(
          isSelected: shippingType == ShippingType.overnight,
          onTap: () => onSelectedShippingType!(ShippingType.overnight),
          labelText:
          'Overnight \$${(options?.overnightRate ?? 0) / 100}',
        ),
      ],
    );
  }
}
