// import 'package:YLift/presentation/components/_simple/lock_pricing_chip.dart';
// import 'package:YLift/presentation/components/products/cards_featured.dart';
// import 'package:flutter/material.dart';
// import 'package:YLift/core/constants/color.dart';
// import 'package:YLift/models/z-index_export.dart';
// import 'package:YLift/core/constants/sample_index.dart';
// import 'package:intl/intl.dart';
// import 'package:YLift/core/extensions/price_extension.dart';
//
//
// class ProductCardMobile extends StatelessWidget {
//   final bool isAuthenticated;
//   final ProductSimple product;
//   final hidePrice;
//
//   final NumberFormat currencyFormat = NumberFormat.currency(symbol: '\$');
//
//   /// # Product Card Mobile
//   /// - Card that displays product information for grid view
//   /// - Used in product lists such as search results, category products, etc.
//   /// - Displays product image and name
//   ///
//   /// **Made for mobile view**
//   ProductCardMobile({
//     required this.product,
//     this.isAuthenticated = false,
//     this.hidePrice = false,
//   });
//
//   Widget _buildPriceWidget() {
//     final sku = product.skus?.first;
//     if (hidePrice || (sku?.tieredPrice ?? 0) == 0) {
//       return LockPricingChip(vendorId: product.vendorId);
//     } else if ((sku?.tieredPrice ?? 0) == 0 && (sku?.listPrice ?? 0) == 0) {
//       return LockPricingChip(vendorId: product.vendorId);
//     } else if ((sku?.tieredPrice ?? 0) > 0 &&
//         (sku?.listPrice ?? 0) != 0 &&
//         (sku?.listPrice != sku?.tieredPrice)) {
//       return Wrap(
//         spacing: 16,
//         children: [
//           Text(
//             sku!.tieredPrice.toCurrency(),
//             style: const TextStyle(
//                 color: YLiftColor.orange,
//                 fontSize: 13,
//                 fontWeight: FontWeight.bold),
//           ),
//           if (sku.listPrice != null && sku.listPrice != 0)
//             Text(
//               sku.listPrice!.toCurrency(),
//               style: const TextStyle(
//                 decoration: TextDecoration.lineThrough,
//                 fontSize: 13,
//                 color: Colors.grey,
//               ),
//             ),
//         ],
//       );
//     } else if ((sku?.tieredPrice ?? 0) > 0) {
//       return Text(
//         sku!.tieredPrice.toCurrency(),
//         style: const TextStyle(fontSize: 13.33),
//       );
//     } else {
//       return LockPricingChip(vendorId: product.vendorId);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     //final SkuSimple defaultSku = productInfo.skus != null ? productInfo.skus!.first : throw("Error Getting Sku");
//     return Container(
//       width: 173,
//       margin: EdgeInsets.symmetric(horizontal: 8),
//       padding: EdgeInsets.all(8),
//       child: Column(
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     height: 173,
//                     width: 173,
//                     child: Center(
//                       child: Image.network(
//                         product.imageUrl.isEmpty ? PLACEHOLDER_IMAGE : product.imageUrl,
//                         errorBuilder: (context, error, stackTrace) => Image.asset('msc/images/Placeholder_Product.png')
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 8.0),
//                   Text(product.name,
//                     style: TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.bold
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: 2,
//                   ),
//                 ],
//               ),
//             Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     (product.skus == null || product.skus!.isEmpty) ?
//                     Center(
//                       child: Text('Product has no skus'),
//                     )
//                         : _buildPriceWidget(),
//                     if (product.hasActivePromotion && !hidePrice)
//                       Text(
//                         product.promotionMessage!,
//                         style: TextStyle(fontSize: 11.11, color: YLiftColor.orange),
//                       ),
//                   ],
//                 ),
//
//                 // if (isAuthenticated) ...[
//                 //   if (productInfo.skus != null )...[
//                 //     if (productInfo.skus!.first.listPrice! > productInfo.skus!.first.tieredPrice) ...[
//                 //       Text(
//                 //         currencyFormat.format(((productInfo.skus!.first.listPrice ?? 0) / 100)), // replaced details
//                 //         style: TextStyle(
//                 //           fontSize: 13,
//                 //           color: Colors.red,
//                 //           decoration: TextDecoration.lineThrough,
//                 //           decorationColor: Colors.red,
//                 //           decorationThickness: 1.5,
//                 //         ),
//                 //       ),
//                 //     ],
//                 //       const SizedBox(width: 8),
//                 //       // This is the new price
//                 //       Text(
//                 //         currencyFormat.format(((productInfo.skus!.first.tieredPrice) / 100)), // replaced details
//                 //         style: TextStyle(
//                 //           fontSize: 13,
//                 //         ),
//                 //       ),
//                 //   ],
//                 // ],
//                 // if (!isAuthenticated) ...[
//                 //   Container(
//                 //     color: Colors.grey[200], // Light grey background
//                 //     padding: const EdgeInsets.symmetric(
//                 //         vertical: 2.0,
//                 //         horizontal:
//                 //         4.0), // Optional: Add some padding inside the container
//                 //     child: const Text(
//                 //       'Login for Pricing',
//                 //       style: TextStyle(
//                 //         fontSize: 8, // Adjusted font size
//                 //         fontWeight: FontWeight.w400,
//                 //         color: Colors.black,
//                 //         letterSpacing: 0.5,
//                 //       ),
//                 //     ),
//                 //   ),
//                 // ],
//               ]
//             ),
//           ],
//         ),
//     );
//   }
// }