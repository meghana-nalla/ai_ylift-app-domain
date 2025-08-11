// import 'package:YLift/models/z-index_export.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
//
// import 'cards_featured.dart';
//
// class BestsellersProductsSlider extends StatelessWidget {
//   final List<ProductSimple> products;
//   final VoidCallback onSeeAll;
//   ValueSetter<ProductSimple> onProductSelect;
//   BestsellersProductsSlider({
//     super.key,
//     required this.products,
//     required this.onSeeAll,
//     required this.onProductSelect
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Featured Products',
//                 style: Theme.of(context).textTheme.headlineSmall,
//               ),
//               TextButton(
//                 onPressed: onSeeAll,
//                 child: Text('See All'),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(height: 8 * 2),
//         SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Row(
//             children: List.generate(
//               products.length,
//                 (index) {
//                   return ProductCardFeatured(
//                       product: products[index],
//                       onProductSelected: () => onProductSelect(products[index]),
//                       hidePrice: false
//                   );
//                 }
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
