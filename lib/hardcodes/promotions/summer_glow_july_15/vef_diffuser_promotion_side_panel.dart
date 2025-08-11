// import 'package:YLift/core/controllers/global.dart';
// import 'package:YLift/hardcodes/constants/ids.dart';
// import 'package:YLift/hardcodes/promotions/summer_glow_july_15/summer_glow_promotion.dart';
// import 'package:YLift/presentation/components/_complex/dialogs/mix_match_dialog.dart';
// import 'package:YLift/presentation/components/_simple/promotion_side_panel.dart';
// import 'package:YLift/presentation/pages/desktop/__primary_shopping/components/video_banner.dart';
// import 'package:YLift/presentation/pages/desktop/cart/components/black_side_panel.dart';
// import 'package:flutter/material.dart';
// import 'package:galaxy_models/core/core.dart';
// import 'package:get/get.dart';
// import 'package:video_player/video_player.dart';
//
// class VEFDiffuserPromotionSidePanel extends StatelessWidget {
//   const VEFDiffuserPromotionSidePanel({super.key});
//
//   int get spendingLeft => 1500000 - SummerGlowPromotion.totalGaldermaPurchase;
//   bool get isQualified => SummerGlowPromotion.totalGaldermaPurchase >= 1500000;
//
//   @override
//   Widget build(BuildContext context) {
//     const padding = EdgeInsets.symmetric(horizontal: 16);
//
//     return Obx(() {
//       return BlackSidePanel(
//         title: Text('Venus et Fleur Promotion'),
//         headerIcon:
//             isQualified
//                 ? const Icon(Icons.check, color: Colors.green, size: 16)
//                 : null,
//         children: [
//           Padding(
//             padding: padding,
//             child: Text(
//               'Enjoy a complimentary Venus et Fleur diffuser with your Galderma purchase of \$15,000 or more.',
//             ),
//           ),
//           const SizedBox(height: 8),
//
//           Padding(
//             padding: padding,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 8),
//                 Text(
//                   'Total Galderma current spending: ${SummerGlowPromotion.totalGaldermaPurchase.toCurrency()}',
//                 ),
//                 const SizedBox(height: 8),
//                 if (SummerGlowPromotion.totalGaldermaPurchase >= 1500000)
//                   Text(
//                     'You have qualified for the Venus et Fleur diffuser promotion!',
//                   ),
//               ],
//             ),
//           ),
//
//           if (!isQualified)
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8),
//               child: OrangeLineTextButton(
//                 label: 'Spend ${spendingLeft.toCurrency()} more on Galderma.',
//                 onTap: () {
//                   final global = Get.find<GlobalController>();
//                   final profileId = global.user.value.profileId;
//                   showDialog(
//                     context: context,
//                     builder:
//                         (context) => Obx(() {
//                           return MixMatchDialog(
//                             title: 'Venus et Fleur Diffuser Promotion',
//                             groupName: 'brand',
//                             cart: global.simpleCart.value,
//                             products: global.allProducts.value
//                                 .getProductsByVendorIds(
//                                   vendorIds: [VendorId.galderma],
//                                 ),
//                             spendingLeft: spendingLeft,
//                             description:
//                                 'Spend ${spendingLeft.toCurrency()} more Galderma to your cart to qualify for the promotion.',
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
//               ),
//             ),
//
//           const SizedBox(height: 8),
//
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             child: OrangeLineTextButton(
//               label: 'Learn More >>',
//               onTap: () {
//                 showDialog(
//                   context: context,
//                   builder: (context) {
//                     return const _VideoDialog();
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       );
//
//       // return PromotionSidePanel(
//       //   title: 'Venus et Fleur Promotion',
//       //   children: [
//       //     Padding(
//       //       padding: padding,
//       //       child: Text(
//       //         'Enjoy a complimentary Venus et Fleur diffuser with your Galderma purchase of \$15,000 or more.',
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
//       //           const SizedBox(height: 8),
//       //           Text(
//       //             'Total Galderma current spending: ${SummerGlowPromotion.totalGaldermaPurchase.toCurrency()}',
//       //             style: TextStyle(fontSize: 11.11),
//       //           ),
//       //           const SizedBox(height: 8),
//       //           if (SummerGlowPromotion.totalGaldermaPurchase >= 1500000)
//       //             Text(
//       //               'You have qualified for the Venus et Fleur diffuser promotion!',
//       //               style: TextStyle(fontSize: 11.11, color: YLiftColor.orange),
//       //             ),
//       //         ],
//       //       ),
//       //     ),
//       //
//       //     if (!isQualified)
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
//       //                       title: 'Venus et Fleur Diffuser Promotion',
//       //                       groupName: 'brand',
//       //                       cart: global.simpleCart.value,
//       //                       products: global.allProducts.value
//       //                           .getProductsByVendorIds(
//       //                             vendorIds: [VendorId.galderma],
//       //                           ),
//       //                       spendingLeft: spendingLeft,
//       //                       description:
//       //                           'Spend ${spendingLeft.toCurrency()} more Galderma to your cart to qualify for the promotion.',
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
//       //                 'Spend ${spendingLeft.toCurrency()} more of Galderma products',
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
//       //               return const _VideoDialog();
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
//
// class _VideoDialog extends StatefulWidget {
//   const _VideoDialog({super.key});
//
//   @override
//   State<_VideoDialog> createState() => _VideoDialogState();
// }
//
// class _VideoDialogState extends State<_VideoDialog> {
//   late final VideoPlayerController controller;
//
//   late Future<void> _videoFuture;
//
//   Future<void> _initializeVideo() async {
//     controller = VideoPlayerController.networkUrl(
//       Uri.parse(SummerGlowPromotion.videoUrl),
//     );
//     await controller.initialize();
//     await controller.setVolume(0);
//     await controller.setLooping(true);
//     await controller.play();
//   }
//
//   @override
//   void initState() {
//     _videoFuture = _initializeVideo();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Venus et Fleur Diffuser Promotion'),
//       content: SizedBox(
//         width: 1040,
//         height: 640,
//         child: FutureBuilder(
//           future: _videoFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             }
//
//             return VideoBanner(
//               controller: controller,
//               thumbnailUrl: SummerGlowPromotion.imageUrl,
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
