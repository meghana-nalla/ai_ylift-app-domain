// import 'package:YLift/hardcodes/promotions/summer_glow_july_15/summer_glow_promotion.dart';
// import 'package:YLift/presentation/pages/desktop/__primary_shopping/components/video_banner.dart';
// import 'package:flutter/material.dart';
// import 'package:galaxy_models/core/core.dart';
// import 'package:galaxy_ui/galaxy_ui.dart';
// import 'package:video_player/video_player.dart';
//
// class SummerGlowExitIntentDialog extends StatefulWidget {
//   const SummerGlowExitIntentDialog({super.key});
//
//   @override
//   State<SummerGlowExitIntentDialog> createState() =>
//       _SummerGlowExitIntentDialogState();
// }
//
// class _SummerGlowExitIntentDialogState
//     extends State<SummerGlowExitIntentDialog> {
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
//     return Dialog(
//       child: Container(
//         width: 1040,
//         padding: const EdgeInsets.symmetric(vertical: 24),
//         constraints: BoxConstraints(maxHeight: 800),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: Text(
//                 'Galderma & Venus et Fleur Diffuser Promotion',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.symmetric(horizontal: 24),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     FutureBuilder(
//                       future: _videoFuture,
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return Center(child: CircularProgressIndicator());
//                         } else if (snapshot.hasError) {
//                           return Image.network(SummerGlowPromotion.imageUrl);
//                         }
//
//                         return VideoBanner(
//                           controller: controller,
//                           thumbnailUrl: SummerGlowPromotion.imageUrl,
//                         );
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       'You are about to miss out on the Galderma & Venus et Fleur Diffuser Promotion!',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       'Summer Glow Promotion (Galderma)',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     if (SummerGlowPromotion.getCurrentPromotion() == null &&
//                         SummerGlowPromotion.getNextPromotion() != null) ...[
//                       Text(
//                         'Total Galderma in Cart: ${SummerGlowPromotion.totalGaldermaQuantity}',
//                         style: TextStyle(fontSize: 13.33),
//                       ),
//                       Text(
//                         'Add ${SummerGlowPromotion.getNextPromotion()!.qualifyingQuantity - SummerGlowPromotion.totalGaldermaQuantity} and get ${SummerGlowPromotion.getNextPromotion()!.providerCodes} provider codes!',
//                         style: TextStyle(fontSize: 13.33),
//                       ),
//                     ] else
//                       Text(
//                         'You get ${SummerGlowPromotion.getCurrentPromotion()!.providerCodes} provider codes (${(SummerGlowPromotion.getCurrentPromotion()!.providerCodes * 5000).toCurrency()} savings).',
//                         style: TextStyle(
//                           fontSize: 13.33,
//                           color: YLiftColor.orange,
//                         ),
//                       ),
//                     const SizedBox(height: 16),
//                     Text(
//                       'Venus et Fleur Diffuser Promotion',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     if (SummerGlowPromotion.totalGaldermaPurchase <
//                         1500000) ...[
//                       Text(
//                         'Total Galderma current spending: ${SummerGlowPromotion.totalGaldermaPurchase.toCurrency()}',
//                         style: TextStyle(fontSize: 13.33),
//                       ),
//                       Text(
//                         'Spend ${(1500000 - SummerGlowPromotion.totalGaldermaPurchase).toCurrency()} more to receive complementary Venus et Fleur diffuser promotion!',
//                         style: TextStyle(fontSize: 13.33),
//                       ),
//                     ] else ...[
//                       Text(
//                         'You have qualified for the Venus et Fleur diffuser promotion!',
//                         style: TextStyle(fontSize: 13.33),
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 16),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: OverflowBar(
//                 alignment: MainAxisAlignment.end,
//                 spacing: 16,
//                 children: [
//                   OutlinedButton(
//                     style: OutlinedButton.styleFrom(
//                       foregroundColor: Colors.black,
//                       side: BorderSide(color: Colors.black),
//                       shape: const RoundedRectangleBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(8)),
//                       ),
//                       textStyle: TextStyle(letterSpacing: 1),
//                     ),
//                     onPressed: () {
//                       Navigator.pop(context, true);
//                     },
//                     child: const Text('Proceed to Checkout'),
//                   ),
//
//                   GalaxyFilledButton(
//                     backgroundColor: Colors.black,
//                     onPressed: () {
//                       Navigator.pop(context, false);
//                     },
//                     child: const Text('Back to Cart'),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
