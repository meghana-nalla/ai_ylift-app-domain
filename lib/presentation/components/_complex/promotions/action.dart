// import 'package:flutter/material.dart';
//
// const _ladyImageUrl =
//     'https://phantom.ylift.app/media/api/optimized/variant/image/file/c967c02a-f9de-4e34-a736-abf6907b5831';
// class ActionPromotionCard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4.0,
//       child: Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height * 0.6,
//         child: Stack(
//           children: [
//             Positioned.fill(
//               child: Image.network(
//                 _ladyImageUrl,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             Positioned.fill(
//               child: Container(
//                 color: Colors.black.withOpacity(0.5),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Get Top-Tier\nPricing On Products',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   SizedBox(height: 8.0),
//                   Text(
//                     'After registering for our trainings',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.white,
//                     ),
//                   ),
//                   SizedBox(height: 16.0),
//                   ElevatedButton(
//                     onPressed: () {},
//                     child: Text('Learn More'),
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
