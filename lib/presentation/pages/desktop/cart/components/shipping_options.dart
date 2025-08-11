
import 'package:YLift/core/constants/text_style.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShippingOptions extends StatefulWidget {
  final SkuSimple sku;
  final AddressSimple? address;
  final ShippingType? shippingType;
  final ShippingSettingsSimple? options;
  final bool allowChangeAddress;
  final Widget? trailing;
  final int total;

  final void Function(int newRate)? onSelectedRate;
  final void Function(ShippingType type)? onSelectedShippingType;
  final void Function() update;

  const ShippingOptions({
    super.key,
    required this.sku,
    this.address,
    required this.total,
    this.options,
    this.allowChangeAddress = true,
    this.onSelectedRate,
    this.shippingType,
    this.onSelectedShippingType,
    required this.update,
    this.trailing,
  });

  @override
  State<ShippingOptions> createState() => _ShippingOptionsState();
}

class _ShippingOptionsState extends State<ShippingOptions> {
  final controller = Get.find<GlobalController>();
  ShippingType? shippingType;
  AddressSimple? address;
  @override
  void initState() {
    if (widget.shippingType != null) shippingType = widget.shippingType;
    if (widget.address != null) address = widget.address;
    super.initState();
  }

  void setShippingType(ShippingType type) async {
    setState(() {
      shippingType = type;
    });
    widget.onSelectedShippingType?.call(type);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 80),
            const Icon(Icons.local_shipping_outlined, size: 40),
            const SizedBox(width: 25),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Shipping Options', style: YLiftTextStyle.bodyLarge),
                    const SizedBox(width: 24),
                    if (widget.allowChangeAddress)
                      UnderlinedTextButton(
                        text: 'Set custom address',
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return SavedAddressesDialog(
                                address: address,
                                update: () {
                                  setState(() {});
                                },
                                onSelectedAddress: (address) async {
                                  await controller.basket.setCartItemAddress(
                                    profileId: controller.user.value.profileId,
                                    addressId: address.addressId,
                                    skuId: widget.sku.skuId,
                                  );
                                  setState(() {
                                    this.address = address;
                                  });
                                  widget.update();
                                },
                              );
                            },
                          );
                        },
                      ),
                  ],
                ),
                Text(widget.address?.display ?? 'No address'),
                if(widget.total > 0 && widget.options != null && (widget.options?.groupSize ?? 1) < 1000) Text(
                  'Group Sizing: ${widget.options!.groupSize}',
                  style: TextStyle(fontSize: 11.11, color: YLiftColor.orange),
                ),
                // OverflowBar(
                //   spacing: 25,
                //   children: [
                //     Text(widget.address?.display ?? 'No address'),
                //     if (controller.cart.value.checkout?.address != null)
                //       UnderlinedTextButton(
                //         text: 'Edit Location',
                //         onPressed: () {
                //           showDialog(
                //             context: context,
                //             builder: (context) => EditAddressDialog(
                //               address: (controller
                //                           .simpleCart.value.shippingAddress !=
                //                       null)
                //                   ? (controller
                //                       .simpleCart.value.shippingAddress!)
                //                   : AddressSimple.empty(),
                //               onEdit: (newAddress) async {
                //                 await controller.addressBook.updateAddress(
                //                   newAddress,
                //                   controller.simpleCart.value.shippingAddress ??
                //                       AddressSimple.empty(),
                //                 );
                //                 controller.simpleCart.value.shippingAddress =
                //                     newAddress;
                //               },
                //             ),
                //           );
                //         },
                //       ),
                //   ],
                // ),
              ],
            ),
            const Spacer(),
            if (widget.trailing != null)
              Padding(
                padding: const EdgeInsets.only(left: 80),
                child: widget.trailing!,
              ),
          ],
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: _buildOptions(),
        ),
      ],
    );
  }

  Widget _buildOptions() {
    if (widget.options!.isFree && widget.options!.isVendorGrouped) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Free Shipping',
              style: YLiftTextStyle.bodyLarge
                  .copyWith(color: YLiftColor.orange)),
        ],
      );
    }

    if (widget.options!.isVendorGrouped) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Part of Same Vendor Shipping (${widget.shippingType?.label})',
              style: YLiftTextStyle.bodyLarge
                  .copyWith(color: YLiftColor.orange)),
        ],
      );
    } // 385

    if (widget.shippingType != null &&
        widget.shippingType != "NONE" &&
        widget.total == 0) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Free shipping',
              style:
                  YLiftTextStyle.bodyLarge.copyWith(color: YLiftColor.orange)),
        ],
      );
    }

    if (widget.options != null && widget.options!.isFlatRate) {
      final regularRate = widget.options?.regularRate ?? 0;
      if (regularRate == 0) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Free shipping',
                    style: YLiftTextStyle.bodyLarge
                        .copyWith(color: YLiftColor.orange)),
          ],
        );
      }

      return ShippingOption(
        isSelected: true,
        onTap: () => setShippingType(ShippingType.regular),
        labelText: 'Flat Rate \$${(widget.options?.regularRate ?? 0) / 100}',
      );
    }

    return OverflowBar(
      children: [
        if (widget.options?.regularRate != null &&
            widget.options!.regularRate != 0) ...[
        ShippingOption(
          isSelected: shippingType == ShippingType.regular,
          onTap: () => setShippingType(ShippingType.regular),
          labelText:
              'Regular Ground \$${(widget.options?.regularRate ?? 0) / 100}',
        )],
        if (widget.options?.expressRate != null &&
            widget.options!.expressRate != 0)...[
        ShippingOption(
          isSelected: shippingType == ShippingType.express,
          onTap: () => setShippingType(ShippingType.express),
          labelText:
              'Express 2 Days \$${(widget.options?.expressRate ?? 0) / 100}',
        )],
        if (widget.options?.overnightRate != null &&
            widget.options!.overnightRate != 0) ...[
        ShippingOption(
          isSelected: shippingType == ShippingType.overnight,
          onTap: () => setShippingType(ShippingType.overnight),
          labelText:
              'Overnight \$${(widget.options?.overnightRate ?? 0) / 100}',
        ),
        ]

      ],
    );
  }
}

class ShippingOption extends StatelessWidget {
  final String labelText;
  final void Function() onTap;
  final bool isSelected;

  const ShippingOption({
    super.key,
    required this.onTap,
    required this.labelText,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      hoverColor: YLiftColor.beige,
      borderRadius: const BorderRadius.all(Radius.circular(4)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              ((!isSelected)
                  ? Icons.radio_button_unchecked
                  : Icons.radio_button_checked),
              size: 16,
            ),
            const SizedBox(width: 16),
            Text(labelText),
          ],
        ),
      ),
    );
  }
}
