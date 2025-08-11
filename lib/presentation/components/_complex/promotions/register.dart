// import 'package:flutter/material.dart';
//
// class RegisterPromotionCard extends StatelessWidget {
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
//                 'https://phantom.ylift.app/media/api/optimized/variant/image/file/d5520053-5684-4b8d-b37a-ba2f3af7e302',
//                 fit: BoxFit.cover,
//               ),
//             ),
//             Positioned.fill(
//               child: Container(
//                 color: Colors.white.withOpacity(0.5),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Hands-On / Virtual Trainings',
//                     style: Theme.of(context).textTheme.headlineMedium
//                   ),
//                   SizedBox(height: 8.0),
//                   Text(
//                     'Y LIFT Network Benefits',
//                       style: Theme.of(context).textTheme.headlineSmall
//                   ),
//                   SizedBox(height: 8.0),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                           '- Lorem ipsum dolor sit amet, consectetuer adipiscing elit.',
//                         style: Theme.of(context).textTheme.bodySmall,
//                       ),
//                       // Text(
//                       //   '- Lorem ipsum dolor sit amet, consectetuer adipiscing elit.',
//                       //   style: Theme.of(context).textTheme.bodySmall,
//                       // ),
//                       // Text(
//                       //   '- Lorem ipsum dolor sit amet, consectetuer adipiscing elit.',
//                       //   style: Theme.of(context).textTheme.bodySmall,
//                       // ),
//                       // Text(
//                       //   '- Lorem ipsum dolor sit amet, consectetuer adipiscing elit.',
//                       //   style: Theme.of(context).textTheme.bodySmall,
//                       // ),
//                     ],
//                   ),
//                   SizedBox(height: 16.0),
//                   Container(
//                     //width: MediaQuery.of(context).size.width * .20,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'Register Now',
//                             style: Theme.of(context).textTheme.titleMedium
//                         ),
//                         Icon(Icons.arrow_forward),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
