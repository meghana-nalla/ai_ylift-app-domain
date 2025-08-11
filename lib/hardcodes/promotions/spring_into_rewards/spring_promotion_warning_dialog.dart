// import 'package:YLift/core/controllers/galderma_promotion/index.dart';
// import 'package:YLift/models/promotions/spring_into_rewards.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:galaxy_ui/galaxy_ui.dart';
// class SpringPromotionWarningDialog extends StatelessWidget {
//   const SpringPromotionWarningDialog({super.key});
//
//   static final galdermaController = Get.find<GaldermaController>();
//
//   String get message{
//     if (galdermaController.quantityForNextTier < 0) {
//       return 'Remove ${galdermaController.quantityForNextTier.abs()} products and get ${galdermaController.springIntoRewardsPromotion?.codeQuantityReward} \$50 coupon codes!';
//     }
//     if (galdermaController.isSpringPromotionApplicable) {
//       return 'Add more';
//     } else {
//       return 'Add ${galdermaController.quantityForNextTier} more and get ${galdermaController.springIntoRewardsPromotion?.codeQuantityReward} \$50 coupon codes!';
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Spring Into Rewards Promotion Inapplicable'),
//       content: SizedBox(
//         width: 800,
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Image.network(SpringIntoRewardsPromotion.bannerImageUrl),
//               const SizedBox(height: 16),
//               Text(
//                 'Spring Into Rewards Promotion is ongoing right now and you have not met the requirements yet.',
//               ),
//               Text(
//                 'In order to qualify for the promotion, you have to purchase an exact amount listed above.',
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 'Current total Galderma products: ${galdermaController.totalGaldermaCount}',
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 message,
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//         ),
//       ),
//       actions: [
//         OutlinedButton(
//           onPressed: () {
//             Navigator.pop(context, true);
//           },
//           child: const Text('I want to skip this promotion'),
//         ),
//         RoundedFilledButton(
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           child: const Text('Go back to Cart'),
//         ),
//       ],
//     );
//   }
// }
