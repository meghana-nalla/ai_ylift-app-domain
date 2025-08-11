import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/core/constants/text_style.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:YLift/presentation/components/_simple/product_image_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:galaxy_models/galaxy_models.dart';
class OrderProductTile extends StatelessWidget {
  final String productId;
  final String name;
  final String? sku;
  final String? description;
  final String? imageUrl;
  final String? variety;
  final int price;
  final int quantity;
  final AddressSimple? address;
  final List<ShippingQuantity>? shippingQuantities;
  final Map<String, AddressSimple>? optionalAddresses;

  final void Function()? onTap;

  const OrderProductTile({
    super.key,
    required this.productId,
    required this.name,
    required this.price,
    this.quantity = 1,
    this.sku,
    this.description,
    this.variety,
    this.imageUrl,
    this.address,
    this.shippingQuantities,
    this.optionalAddresses,
    this.onTap,
  }) : assert(quantity >= 0);

  static final currencyFormat = NumberFormat.currency(symbol: '\$');

  @override
  Widget build(BuildContext context) {
    final global = Get.find<GlobalController>();

    Widget bottomDescription = Text('Quantity: $quantity', style: YLiftTextStyle.descriptionGrey);
    if (variety != null) {
      bottomDescription = IntrinsicHeight(
        child: Row(
          children: [
            Text(variety!, style: YLiftTextStyle.descriptionGrey),
            const VerticalDivider(width: YLiftConstant.gap),
            bottomDescription,
          ],
        ),
      );
    }

    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      onTap: onTap,
      child: SizedBox(
        height: 160,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: ProductImageView(imageUrl: imageUrl),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, maxLines: 2, style: YLiftTextStyle.bodyLarge),
                  const SizedBox(height: 16),
                  if (sku != null && sku!.isNotEmpty) Text('YLS: $productId-$sku ', style: YLiftTextStyle.descriptionGrey),
                  if (description != null) Text(description!, style: YLiftTextStyle.descriptionGrey),
                  const SizedBox(height: 8),
                  if (shippingQuantities != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: shippingQuantities!.map(
                        (e) {
                          final address = optionalAddresses?['${e.shippingAddressId}'];
                          if (address == null) return const Text('(No address)');
                          return Text(address.display);
                        },
                      ).toList(),
                    )
                  else if (address != null)
                    Text(address!.display),
                  const Spacer(),
                  bottomDescription,
                ],
              ),
            ),
            Text(currencyFormat.format(price / 100),
                style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
