// import 'package:YLift/core/constants/color.dart';
// import 'package:YLift/core/controllers/global.dart';
// import 'package:YLift/core/extensions/price_extension.dart';
// import 'package:YLift/hardcodes/constants/ids.dart';
// import 'package:YLift/hardcodes/promotions/summer_glow_july_15/summer_glow_promotion.dart';
// import 'package:YLift/presentation/components/_complex/dialogs/mix_match_dialog.dart';
// import 'package:YLift/presentation/components/_simple/promotion_side_panel.dart';
// import 'package:YLift/presentation/pages/desktop/cart/components/black_side_panel.dart';
// import 'package:flutter/material.dart';
// import 'package:galaxy_ui/galaxy_ui.dart';
// import 'package:get/get.dart';
//
// class SummerGlowPromotionSidePanel extends StatelessWidget {
//   const SummerGlowPromotionSidePanel({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     const padding = EdgeInsets.symmetric(horizontal: 16);
//
//     return Obx(() {
//       final currentPromotion = SummerGlowPromotion.getCurrentPromotion();
//       final nextPromotion = SummerGlowPromotion.getNextPromotion();
//
//       return BlackSidePanel(
//         title: Text('Summer Glow Promotion'),
//         headerIcon:
//             currentPromotion != null
//                 ? const Icon(Icons.check, color: Colors.green, size: 16)
//                 : null,
//         children: [
//           Padding(
//             padding: padding,
//             child: Text(
//               'Get exclusive savings of \$50 for each provider code with each qualifying Galderma purchase.',
//             ),
//           ),
//           const SizedBox(height: 16),
//
//           Padding(
//             padding: padding,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               spacing: 4,
//               children: [
//                 ...SummerGlowPromotion.list.map(
//                   (promotion) => Row(
//                     children: [
//                       Text(
//                         'Buy ${promotion.qualifyingQuantity}, get ${promotion.providerCodes} provider codes',
//                       ),
//                       const SizedBox(width: 8),
//                       if (SummerGlowPromotion.totalGaldermaQuantity ==
//                           promotion.qualifyingQuantity)
//                         ActiveIcon(true, size: 14),
//                     ],
//                   ),
//                 ),
//
//                 const SizedBox(height: 8),
//                 Text(
//                   'Total Galderma in Cart: ${SummerGlowPromotion.galdermaItems.fold<int>(0, (sum, item) => sum + item.quantity)}',
//                 ),
//                 const SizedBox(height: 8),
//                 if (currentPromotion != null)
//                   Text(
//                     'You get ${currentPromotion.providerCodes} provider codes (${(currentPromotion.providerCodes * 5000).toCurrency()} savings).',
//                   ),
//               ],
//             ),
//           ),
//
//           if (nextPromotion != null)
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8),
//               child: OrangeLineTextButton(
//                 onTap: () {
//                   final global = Get.find<GlobalController>();
//                   final profileId = global.user.value.profileId;
//                   showDialog(
//                     context: context,
//                     builder:
//                         (context) => Obx(() {
//                           return MixMatchDialog(
//                             title: 'Summer Glow Promotion',
//                             groupName: 'brand',
//                             cart: global.simpleCart.value,
//                             products: global.allProducts.value
//                                 .getProductsByVendorIds(
//                                   vendorIds: [VendorId.galderma],
//                                 ),
//                             quantityLeft:
//                                 nextPromotion.qualifyingQuantity -
//                                 SummerGlowPromotion.totalGaldermaQuantity,
//
//                             description:
//                                 'Add ${nextPromotion.qualifyingQuantity - SummerGlowPromotion.totalGaldermaQuantity} more Galderma to your cart to qualify for the promotion.',
//                             expandSkus: true,
//                             onProductQuantityChanged: (sku, newQuantity) async {
//                               await global.basket.addToCart(
//                                 customerId:
//                                     global.user.value.profileId.toString(),
//                                 quantity: newQuantity,
//                                 product: "${sku.productId}-${sku.skuId}",
//                               );
//                             },
//                           );
//                         }),
//                   );
//                 },
//                 label:
//                     'Add ${nextPromotion.qualifyingQuantity - SummerGlowPromotion.totalGaldermaQuantity} more and get ${nextPromotion.providerCodes} provider codes',
//               ),
//             ),
//
//           const SizedBox(height: 8),
//
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             child: OrangeLineTextButton(
//               onTap: () {
//                 showDialog(
//                   context: context,
//                   builder: (context) {
//                     return AlertDialog(
//                       content: Image.network(SummerGlowPromotion.imageUrl),
//                     );
//                   },
//                 );
//               },
//               label: 'Learn More >>',
//             ),
//           ),
//         ],
//       );
//
//       // return PromotionSidePanel(
//       //   title: 'Summer Glow Promotion Available',
//       //   children: [
//       //     Padding(
//       //       padding: padding,
//       //       child: Text(
//       //         'Get exclusive savings of \$50 for each provider code with each qualifying Galderma purchase.',
//       //         style: TextStyle(fontSize: 11.11),
//       //       ),
//       //     ),
//       //     const SizedBox(height: 8),
//       //
//       //     Padding(
//       //       padding: padding,
//       //       child: Column(
//       //         crossAxisAlignment: CrossAxisAlignment.start,
//       //         children: [
//       //           ...SummerGlowPromotion.list.map(
//       //             (promotion) => Row(
//       //               children: [
//       //                 Text(
//       //                   'Buy ${promotion.qualifyingQuantity}, get ${promotion.providerCodes} provider codes',
//       //                   style: TextStyle(fontSize: 11.11, height: 2),
//       //                 ),
//       //                 const SizedBox(width: 8),
//       //                 if (SummerGlowPromotion.totalGaldermaQuantity ==
//       //                     promotion.qualifyingQuantity)
//       //                   ActiveIcon(true, size: 12),
//       //               ],
//       //             ),
//       //           ),
//       //
//       //           const SizedBox(height: 8),
//       //           Text(
//       //             'Total Galderma in Cart: ${SummerGlowPromotion.galdermaItems.fold<int>(0, (sum, item) => sum + item.quantity)}',
//       //             style: TextStyle(fontSize: 11.11),
//       //           ),
//       //           const SizedBox(height: 8),
//       //           if (currentPromotion != null)
//       //             Text(
//       //               'You get ${currentPromotion.providerCodes} provider codes (${(currentPromotion.providerCodes * 5000).toCurrency()} savings).',
//       //               style: TextStyle(fontSize: 11.11, color: YLiftColor.orange),
//       //             ),
//       //           // else if (nextPromotion != null)
//       //           //   Text(
//       //           //     'Add ${nextPromotion.qualifyingQuantity - SculptraPromotionData.totalSculptraQuantity} more Sculptra and get ${nextPromotion.providerCodes} provider codes!',
//       //           //     style: TextStyle(fontSize: 11.11, color: YLiftColor.orange),
//       //           //   ),
//       //         ],
//       //       ),
//       //     ),
//       //
//       //     if (nextPromotion != null)
//       //       Padding(
//       //         padding: const EdgeInsets.symmetric(horizontal: 8),
//       //         child: InkWell(
//       //           onTap: () {
//       //             final global = Get.find<GlobalController>();
//       //             final profileId = global.user.value.profileId;
//       //             showDialog(
//       //               context: context,
//       //               builder:
//       //                   (context) => Obx(() {
//       //                     return MixMatchDialog(
//       //                       title: 'Summer Glow Promotion',
//       //                       groupName: 'brand',
//       //                       cart: global.simpleCart.value,
//       //                       products: global.allProducts.value
//       //                           .getProductsByVendorIds(
//       //                             vendorIds: [VendorId.galderma],
//       //                           ),
//       //                       quantityLeft:
//       //                           nextPromotion.qualifyingQuantity -
//       //                           SummerGlowPromotion.totalGaldermaQuantity,
//       //
//       //                       description:
//       //                           'Add ${nextPromotion.qualifyingQuantity - SummerGlowPromotion.totalGaldermaQuantity} more Galderma to your cart to qualify for the promotion.',
//       //                       expandSkus: true,
//       //                       onProductQuantityChanged: (sku, newQuantity) async {
//       //                         await global.basket.addToCart(
//       //                           customerId:
//       //                               global.user.value.profileId.toString(),
//       //                           quantity: newQuantity,
//       //                           product: "${sku.productId}-${sku.skuId}",
//       //                         );
//       //                       },
//       //                     );
//       //                   }),
//       //             );
//       //           },
//       //           child: Padding(
//       //             padding: const EdgeInsets.symmetric(
//       //               horizontal: 8,
//       //               vertical: 4,
//       //             ),
//       //             child: SizedBox(
//       //               width: double.infinity,
//       //               child: Text(
//       //                 'Add ${nextPromotion.qualifyingQuantity - SummerGlowPromotion.totalGaldermaQuantity} more and get ${nextPromotion.providerCodes} provider codes',
//       //                 style: TextStyle(
//       //                   fontSize: 11.11,
//       //                   color: YLiftColor.orange,
//       //                   decoration: TextDecoration.underline,
//       //                   decorationColor: YLiftColor.orange,
//       //                 ),
//       //               ),
//       //             ),
//       //           ),
//       //         ),
//       //       ),
//       //
//       //     const SizedBox(height: 8),
//       //
//       //     Padding(
//       //       padding: const EdgeInsets.symmetric(horizontal: 8),
//       //       child: InkWell(
//       //         onTap: () {
//       //           showDialog(
//       //             context: context,
//       //             builder: (context) {
//       //               return AlertDialog(
//       //                 content: Image.network(SummerGlowPromotion.imageUrl),
//       //               );
//       //             },
//       //           );
//       //         },
//       //         child: Padding(
//       //           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       //           child: SizedBox(
//       //             width: double.infinity,
//       //             child: Text(
//       //               'Learn More >>',
//       //               style: TextStyle(
//       //                 fontSize: 11.11,
//       //                 color: YLiftColor.orange,
//       //                 decoration: TextDecoration.underline,
//       //                 decorationColor: YLiftColor.orange,
//       //               ),
//       //             ),
//       //           ),
//       //         ),
//       //       ),
//       //     ),
//       //   ],
//       // );
//     });
//   }
// }
