import 'dart:async';
import 'package:YLift/core/controllers/global.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:YLift/presentation/components/_simple/product_image_view.dart';
import 'package:YLift/presentation/components/_simple/promotion_available_chip.dart';
import 'package:YLift/presentation/pages/desktop/cart/components/merz_promotion_dialog.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:get/get.dart';
import 'package:galaxy_models/galaxy_models.dart';

// class ProductRadioTile extends StatelessWidget {
//   final CartItemSimple product;
//   final void Function(SkuSimple sku) onDeleted;
//   final void Function() update;
//   final Map<String, AddressSimple>? optionalAddresses;
//
//   ProductRadioTile({
//     super.key,
//     required this.product,
//     required this.onDeleted,
//     required this.update,
//     this.optionalAddresses,
//   });
//
//   final GlobalController global = Get.find<GlobalController>();
//   final RxBool isUpdatingQuantity = false.obs;
//   final RxInt quantity = 1.obs;
//
//   void setQuantity(int newQuantity) {
//     quantity.value = newQuantity;
//     isUpdatingQuantity.value = true;
//
//     Debouncer.debounce(
//       'quantity_${product.sku.skuId}',
//       () async {
//         try {
//           await global.basket.updateCartItemQuantity(
//             profileId: global.user.value.profileId.toString(),
//             skuId: product.sku.skuId,
//             quantity: quantity.value,
//           );
//         } finally {
//           isUpdatingQuantity.value = false;
//         }
//       },
//       const Duration(milliseconds: 1000),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     quantity.value = product.quantity;
//
//     return Obx(
//       () => Column(
//         children: [
//           IntrinsicHeight(
//             child: Row(
//               children: [
//                 const SizedBox(width: 40),
//                 Radio(
//                   value: 2,
//                   groupValue: 1,
//                   onChanged: (value) {},
//                 ),
//                 const SizedBox(width: 8),
//                 SizedBox.square(
//                   dimension: 160,
//                   child: Image.network(
//                     product.imageUrl ?? PLACEHOLDER_IMAGE,
//                     loadingBuilder: (context, child, loadingProgress) {
//                       if (loadingProgress == null) return child;
//                       return Center(
//                         child: CircularProgressIndicator(
//                           value: loadingProgress.expectedTotalBytes != null
//                               ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
//                               : null,
//                         ),
//                       );
//                     },
//                     errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
//                   ),
//                 ),
//                 const SizedBox(width: 25),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(product.productName, style: YLiftTextStyle.bodyLarge),
//                     Text('SKU: ${product.sku.skuId}'),
//                     SizedBox(
//                       width: 240,
//                       child: Row(
//                         children: [
//                           const Text('Quantity'),
//                           const SizedBox(width: 24),
//                           StepperWidget(
//                             height: 24,
//                             quantityIncrement: product.sku.quantityIncrement!,
//                             quantityMax: product.sku.quantityMaximum,
//                             quantityMin: product.sku.quantityMinimum,
//                             currentValue: quantity.value,
//                             onQuantityChanged: setQuantity,
//                           ),
//                         ],
//                       ),
//                     ),
//                     const Spacer(),
//                     Row(
//                       children: [
//                         UnderlinedTextButton(
//                           onPressed: () => onDeleted(product.sku),
//                           text: 'Delete',
//                         ),
//                         const GapX(),
//                         if (product.hasSplit)
//                           UnderlinedTextButton(
//                             text: 'Cancel Split',
//                             onPressed: () {
//                               global.basket.cancelSplit(
//                                   profileId: global.user.value.profileId.toString(), skuId: product.sku.skuId);
//                             },
//                           )
//                         else
//                           UnderlinedTextButton(
//                             text: 'Split',
//                             onPressed: () {
//                               showDialog(
//                                 context: context,
//                                 builder: (context) => QuantitySplitDialog(product: product),
//                               );
//                             },
//                           ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 const Spacer(),
//                 Align(
//                   alignment: Alignment.topRight,
//                   child: isUpdatingQuantity.value
//                       ? const CircularProgressIndicator()
//                       : Text(
//                           '\$${(product.total / 100).toStringAsFixed(2)}',
//                           style: YLiftTextStyle.title,
//                         ),
//                 ),
//               ],
//             ),
//           ),
//           const GapY(),
//           if (product.shippingSettings == null)
//             const Text('Free Shipping')
//           else if (product.shippingQuantities != null)
//             // SHIPPING QUANTITY SPLIT
//             ...product.shippingQuantities!.map((shippingQuantity) {
//               final address = global.simpleCart.value.optionalAddress!['${shippingQuantity.shippingAddressId}']!;
//               // final data = splitData[address.id]!;
//               return Padding(
//                 padding: const EdgeInsets.only(bottom: 24),
//                 child: ShippingOptions(
//                   sku: product.sku,
//                   address: address,
//                   total: product.total,
//                   allowChangeAddress: false,
//                   shippingType: shippingQuantity.shippingType,
//                   options: product.shippingSettings!,
//                   onSelectedShippingType: (type) {
//                     final qty = shippingQuantity.copyWith(shippingType: type);
//                     final list = [
//                       qty,
//                       ...product.shippingQuantities!.where((p) => p.shippingAddressId != qty.shippingAddressId)
//                     ];
//                     final data = list.map<Map<String, dynamic>>((e) => e.toPayload()).toList();
//                     global.basket.setCartItemSplitQuantity(
//                       profileId: global.user.value.profileId.toString(),
//                       skuId: product.sku.skuId,
//                       data: data,
//                     );
//                     // splitData[address.id] = (data.$1, type);
//                   },
//                   update: update,
//                   trailing: QuantityCounter(
//                     value: shippingQuantity.quantity,
//                     quantityRule: QuantityRule(
//                       min: product.sku.quantityMinimum,
//                       max: product.sku.quantityMaximum,
//                       increment: product.sku.quantityIncrement,
//                     ),
//                     onChanged: (newValue) {
//                       final qty = shippingQuantity.copyWith(quantity: newValue);
//                       final list = [
//                         qty,
//                         ...product.shippingQuantities!.where((p) => p.shippingAddressId != qty.shippingAddressId)
//                       ];
//                       final data = list.map<Map<String, dynamic>>((e) => e.toPayload()).toList();
//
//                       global.basket.setCartItemSplitQuantity(
//                         profileId: global.user.value.profileId.toString(),
//                         skuId: product.sku.skuId,
//                         data: data,
//                       );
//                       // splitData[address.id] = (newValue, data.$2);
//                     },
//                   ),
//                 ),
//               );
//             })
//           else if (product.shippingSettings != null)
//             ShippingOptions(
//               sku: product.sku,
//               total: product.total,
//               address: optionalAddresses?[product.shippingAddress] ?? global.simpleCart.value.shippingAddress,
//               shippingType: product.shippingType,
//               options: product.shippingSettings!,
//               onSelectedShippingType: (type) async {
//                 await global.basket.setCartShippingType(
//                   profileId: global.user.value.profileId.toString(),
//                   skuId: product.sku.skuId,
//                   type: type,
//                 );
//               },
//               update: update,
//             ),
//         ],
//       ),
//     );
//   }
// }

class CartItemTile extends StatefulWidget {
  final CartItemSimple cartItem;
  final bool isChecked;
  final void Function(bool isChecked)? onCheck;
  final void Function(int newQuantity)? onUpdateQuantity;
  final void Function()? onDelete;
  final void Function()? onSaveForLater;

  const CartItemTile({
    super.key,
    required this.cartItem,
    this.isChecked = false,
    this.onCheck,
    this.onUpdateQuantity,
    this.onDelete,
    this.onSaveForLater,
  });

  @override
  State<CartItemTile> createState() => _CartItemTileState();
}

class _CartItemTileState extends State<CartItemTile> {
  final global = Get.find<GlobalController>();
  bool isSelected = true;

  SkuSimple? selectedSku;
  late Future<List<SkuSimple>> skusFuture;

  FreeCartItem? get freeItem =>
      global.simpleCart.value.freeItems.firstWhereOrNull((element) => element.skuId == widget.cartItem.skuId);

  @override
  void initState() {
    // skusFuture = global.products.getSkusByProductId('${widget.cartItem.productId!}');
    selectedSku = widget.cartItem.sku;
    super.initState();
  }

  int? getMinimum(){
    final skuId = widget.cartItem.skuId;
    final productId = widget.cartItem.productId!;
    final product = '$productId-$skuId';
    final rules = global.simpleCart.value.tradeGoods.expand((tradeGood) => tradeGood.productIds).toList();
    int? getValueByKey(List<Map<String, int>> dataList, String keyToFind) {
      for (var map in dataList) {
        if (map.containsKey(keyToFind)) {
          return map[keyToFind];
        }
      }
      return null; // Return null if the key is not found in any map
    }

    final minimum = getValueByKey(rules, product);
    return minimum;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final sku = widget.cartItem.sku;
    final product = widget.cartItem;

    return SizedBox(
      height: 160,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Checkbox(
              value: widget.isChecked,
              onChanged: (value) {
                if (value == null) return;
                widget.onCheck?.call(value);
              },
            ),
          ),
          SizedBox.square(
            dimension: 160,
            child: ProductImageView(imageUrl: widget.cartItem.imageUrl),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              global.vroute.navigateToProduct(widget.cartItem.productId!);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.cartItem.productName,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                if (widget.cartItem.caption != null) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    widget.cartItem.caption!,
                                    style: textTheme.bodySmall,
                                  ),
                                ],
                                const SizedBox(height: 4),
                                Text(
                                  'YLS: #${product.productId}-${sku.skuId}', // we should be checking if this is a physical product
                                  style: TextStyle(fontSize: 11.11),
                                ),
                                if (sku.attributeName != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    sku.attributeName!,
                                    style: TextStyle(fontSize: 11.11),
                                  ),

                                ],
                              ],
                            ),
                          ),
                        ),
                        if (MerzSyringePromotion.productIds.contains(widget.cartItem.productId!) && global.simpleCart.value.hasMerzPromotion) ...[
                          const SizedBox(height: 4),
                          PromotionAvailableChip(),
                        ],
                      ],
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        QuantityField(
                          key: ValueKey(widget.cartItem.skuId),
                          value: widget.cartItem.quantity,
                          quantityIncrement: sku.quantityIncrement,
                          quantityMinimum: getMinimum() ?? sku.quantityMinimum,
                          quantityMaximum: sku.quantityMaximum,
                          checkMinimum: true,
                          onChanged: (newQuantity) => widget.onUpdateQuantity?.call(newQuantity),
                        ),
                        //                         // QuantityDropdown(
                        //                         //   isActive: true,
                        //                         //   withLabel: false,
                        //                         //   isExpanded: false,
                        //                         //   isDense: true,
                        //                         //   value: widget.cartItem.quantity,
                        //                         //   incrementQty: widget.cartItem.sku.quantityIncrement,
                        //                         //   minQty: widget.cartItem.sku.quantityMinimum,
                        //                         //   maxQty: widget.cartItem.sku.quantityMaximum,
                        //   onChanged: (newValue) => widget.onUpdateQuantity?.call(newValue),
                        // ),
                        SizedBox(height: 8),
                        Row(mainAxisSize: MainAxisSize.min, children: [
                          IconButton(
                            onPressed: widget.onDelete,
                            icon: const Icon(Icons.delete_outline),
                          ),
                          if (widget.onSaveForLater != null) ...[
                            SizedBox(width: 8),
                            UnderlinedTextButton(
                              fontSize: 12,
                              text: 'Save for later',
                              onPressed: widget.onSaveForLater!,
                            ),
                          ]
                        ]),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          widget.cartItem.total.toCurrency(),
                          style: textTheme.titleLarge,
                        ),
                        if (widget.cartItem.itemTaxTotalAsInteger != 0)
                          Text(
                            'Tax: ${widget.cartItem.itemTaxTotalAsInteger.toCurrency()}',
                            style: TextStyle(fontSize: 13.33),
                          ),
                        if (MerzSyringePromotion.productIds.contains(widget.cartItem.productId))
                          RadiesseUnitInfo(
                            cartItem: widget.cartItem,
                            freeItem: freeItem,
                          ),

                        // if (widget.cartItem.brandId == MerzSyringePromotion.brandId) ...[
                        //   Text(
                        //     '${widget.cartItem.quantity * 2} syringes',
                        //     style: TextStyle(fontSize: 11.11, color: Colors.grey),
                        //   ),
                        //   Text(
                        //     '${(widget.cartItem.total / (widget.cartItem.quantity * 2)).toCurrency()} / syringe',
                        //     style: TextStyle(fontSize: 11.11, color: Colors.grey),
                        //   ),
                        //   if (freeItem != null)
                        //     Text(
                        //       '${(widget.cartItem.total / ((widget.cartItem.quantity + freeItem!.quantity) * 2)).toCurrency()} / syringe (free syringes included)',
                        //       style: TextStyle(fontSize: 11.11, color: Colors.green),
                        //     ),
                        // ],
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                // _buildEvolysseMessage(),
                if (widget.cartItem.promotion?.hasActivePromotion ?? false)
                  PromotionChip(
                    isQualified: widget.cartItem.promotion?.isPromotionApplied ?? false,
                    message: widget.cartItem.promotion?.promotionCartMessage,
                  ),
                if (widget.cartItem.cartNote != null)
                  Text(
                    widget.cartItem.cartNote!,
                    style: TextStyle(color: YLiftColor.orange, fontSize: 13.33),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildEvolysseMessage() {
  //   final currentDate = DateTime.now();
  //   if(currentDate.isAfter(EvolyssePromotion.expirationDate)) return SizedBox.shrink();
  //   if(!EvolyssePromotion.isEvolysseProduct(widget.cartItem)) return SizedBox.shrink();
  //   final discount = widget.cartItem.quantity * 4500;
  //   final min = EvolyssePromotion.minimumQuantity;
  //   final max = EvolyssePromotion.maximumQuantity;
  //
  //   return PromotionChip(
  //     isQualified: EvolyssePromotion.isQualified(global.simpleCart.value.cartItems),
  //     message: 'Buy $min to $max units get exclusive pricing of \$150 each!',
  //     qualifiedMessage: 'Promotion applied. You just saved ${discount.toCurrency()}!',
  //   );
  // }
}

class PromotionChip extends StatelessWidget {
  final String? message;
  final String? qualifiedMessage;
  final bool isQualified;
  final EdgeInsets padding;
  final void Function()? onPressed;

  const PromotionChip({
    super.key,
    this.isQualified = false,
    this.message,
    this.qualifiedMessage,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.onPressed,
  });

  String get _message {
    if (isQualified) return qualifiedMessage ?? 'Promotion Qualified';
    if (message != null) return message!;
    return 'Qualification Incomplete';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: isQualified ? YLiftColor.promotionQualified : Color(0xFFFFF7F4),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        padding: padding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _message,
              style: TextStyle(
                color: isQualified ? Colors.white : YLiftColor.orange,
                fontSize: 11.11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            if (isQualified) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 11.11,
              ),
            ]
          ],
        ),
      ),
    );
  }
}

class RadiesseUnitInfo extends StatelessWidget {
  final CartItemSimple cartItem;
  final FreeCartItem? freeItem;

  const RadiesseUnitInfo({
    super.key,
    required this.cartItem,
    this.freeItem,
  });

  static final _global = Get.find<GlobalController>();

  int get allSyringes {
    int syringes = _global.simpleCart.value.merzTotalSyringes;
    int freeSyringes = _global.simpleCart.value.merzTotalFreeSyringes;
    return syringes + freeSyringes;
  }

  int get allTotal {
    int total = _global.simpleCart.value.merzItems.fold(0, (previousValue, element) => previousValue + element.total);
    return total;
  }

  bool get hasFreeItem => freeItem != null;

  int get totalSyringes => cartItem.quantity * 2;
  double get unitPrice => cartItem.total / totalSyringes;
  // double get unitPriceWithFree => cartItem.total / (totalSyringes + freeItem!.quantity * 2);
  double get unitPriceWithFree => allTotal / allSyringes;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '${unitPrice.toCurrency()} / syringe',
          style: TextStyle(
            fontSize: 11.11,
            color: Colors.grey,
            decoration: hasFreeItem ? TextDecoration.lineThrough : null,
          ),
        ),
        if (freeItem != null)
          Text(
            '${unitPriceWithFree.toCurrency()} / syringe (Save ${(unitPrice - unitPriceWithFree).toCurrency()})',
            style: TextStyle(fontSize: 11.11, color: Colors.grey),
          ),
      ],
    );
  }
}
