// // TODO : All of these rules should be sever side
// import 'package:flutter/material.dart';
//
// import '../../models/simple/cart_item.dart';
// import '../../models/simple/cart_shop_item.dart';
//
// class GaldermaRule {
//   static int checkGaldermaRule(List<ShoppingItem> cartItems) {
//     List<int> galdermaProdRules = [547, 548, 549, 550, 551, 552, 559, 560];
//     int galdermaOrderRule = 0;
//     for (var item in cartItems) {
//       if (galdermaProdRules.contains(item.productId)) {
//         galdermaOrderRule += item.quantity!;
//       }
//     }
//     return galdermaOrderRule;
//   }
// }
