import 'package:YLift/core/constants/color.dart';
import 'package:YLift/core/constants/index.dart';
import 'package:YLift/presentation/components/_simple/lock_pricing_chip.dart';
import 'package:flutter/material.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:intl/intl.dart';
import 'package:YLift/core/extensions/price_extension.dart';

class ProductCardFeatured extends StatelessWidget {
  final ProductSimple product;
  final VoidCallback onProductSelected;
  final NumberFormat currencyFormat = NumberFormat.currency(symbol: '\$');
  final bool hidePrice;

  ProductCardFeatured({
    super.key,
    required this.product,
    required this.onProductSelected,
     this.hidePrice = false,
  });

  Widget _buildPriceWidget() {
    final sku = product.skus?.first;
    if (hidePrice || (sku?.tieredPrice ?? 0) == 0) {
      return LockPricingChip(vendorId: product.vendorId);
    } else if ((sku?.tieredPrice ?? 0) == 0 && (sku?.listPrice ?? 0) == 0) {
      return LockPricingChip(vendorId: product.vendorId);
    } else if ((sku?.tieredPrice ?? 0) > 0 &&
        (sku?.listPrice ?? 0) != 0 &&
        (sku?.listPrice != sku?.tieredPrice)) {
      return Row(
        children: [
          Text(
            sku!.tieredPrice.toCurrency(),
            style: TextStyle(
              fontSize: 13,
                color: YLiftColor.orange,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          if (sku.listPrice != null && sku.listPrice != 0)
            Text(
              sku.listPrice!.toCurrency(),
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
        ],
      );
    } else if ((sku?.tieredPrice ?? 0) > 0) {
      return Text(
        sku!.tieredPrice.toCurrency(),
        style: const TextStyle(fontSize: 13),
      );
    } else {
      return LockPricingChip(vendorId: product.vendorId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 173,
      margin: EdgeInsets.symmetric(horizontal: 8),
      padding: EdgeInsets.all(8),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: onProductSelected,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 173,
                        width: 173,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: FadeInImage.assetNetwork(
                            placeholder: 'msc/images/ys_logo.png',
                              image: product.imageUrl.isEmpty ? PLACEHOLDER_IMAGE: product.imageUrl,
                              imageErrorBuilder: (context, error, stackTrace) => Image.asset('msc/images/Placeholder_Product.png')
                          ),
                        ),
                      ),
                      //const SizedBox(height: 4),
                      Text(
                        product.name,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold
                        ),
                        overflow: TextOverflow.ellipsis,
                        //maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 4),
            Column(children: [
              (product.skus == null || product.skus!.isEmpty) ?
              Center(
                child: Text('Product has no skus'),
              )
                  : _buildPriceWidget(),
              if (product.hasActivePromotion && !hidePrice)
                Text(
                  product.promotionMessage!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(fontSize: 11.11, color: YLiftColor.orange, overflow: TextOverflow.ellipsis),
                ),
            ]
            ),
          ],
        ),
      ),
    );
  }
}


// class UnlockNetworkPrice extends StatelessWidget {
//   final bool isGalderma;
//   const UnlockNetworkPrice({
//     super.key,
//     this.isGalderma = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final global = Get.find<GlobalController>();
//
//     return GestureDetector(
//       onTap:
//           () => global.vroute.navigateTo('/login'),
//       child: Container(
//         width: 156,
//         decoration: const BoxDecoration(
//           color: Color(0xFFF3F4F3),
//           borderRadius: BorderRadius.all(Radius.circular(4)),
//         ),
//         padding: const EdgeInsets.symmetric(vertical: 4),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(
//               Icons.lock,
//               size: 12,
//               color: Color(0xFFBBBBBB),
//             ),
//             const SizedBox(width: 8),
//                Text(
//                 (isGalderma) ? 'Unlock Network Pricing' : 'Login for Pricing',
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(fontSize: 8),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
