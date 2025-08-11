import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/core/constants/text_style.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/components/_complex/dialogs/mix_match_dialog.dart';
import 'package:YLift/presentation/components/z-index_export.dart' hide RoundedFilledButton;
import 'package:YLift/hardcodes/promotions/practice_luxury/practice_luxury_order_rule.dart';
import 'package:YLift/presentation/pages/desktop/cart/components/merz_order_rule.dart';
import 'package:YLift/presentation/pages/desktop/cart/components/merz_promotion_dialog.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/_clean/product.dart';

class CartSummary extends StatefulWidget {
  final ScrollController? scrollController;

  final bool isCartAccessible;
  final bool isCheckoutAccessible;

  CartSummary({
    Key? key,
    this.scrollController,
    this.isCartAccessible = false,
    this.isCheckoutAccessible = false,
  }) : super(key: key);

  static final TextStyle costStyle = GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500);

  @override
  State<CartSummary> createState() => _CartSummaryState();
}

class _CartSummaryState extends State<CartSummary> {
  final GlobalController controller = Get.find<GlobalController>();
  double height = 0.0;
  @override
  void initState() {
    if (widget.scrollController != null) widget.scrollController!.addListener(scrollListener);
    super.initState();
  }

  void scrollListener() {
    setState(() {
      height = widget.scrollController!.position.pixels - 100;
    });
  }

  void onCheckout(BuildContext context) {
    if (!widget.isCartAccessible || !widget.isCheckoutAccessible) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Missing information'),
            content: const Text('Missing some information, please make sure everything is filled'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
      return;
    }

    controller.vroute.navigateTo('/order/checkout');
  }

  @override
  void dispose() {
    if (widget.scrollController != null) widget.scrollController!.removeListener(scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !widget.isCartAccessible,
      child: Opacity(
        opacity: widget.isCartAccessible && widget.isCheckoutAccessible ? 1.0 : 0.4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height < 0 ? 0 : height),
            Text('Summary', style: YLiftTextStyle.bodyLarge),
            const SizedBox(height: 25),
            GalaxyPanel(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Obx(
                        () => CartCostBreakdown(
                      subtotal: controller.simpleCart.value.subTotal,
                      salesTax: controller.simpleCart.value.taxTotalAsInteger,
                      shippingCost: controller.simpleCart.value.shippingTotal,
                      discount: controller.simpleCart.value.discountTotal,
                      total: controller.simpleCart.value.orderTotal,
                    ),
                  ),
                  const SizedBox(height: 25),
                  RoundedFilledButton(
                    onPressed: () => onCheckout(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.lock, color: Colors.white, size: 16),
                        const SizedBox(width: 8),
                        if (!widget.isCartAccessible)
                          const Text('Please add items to cart...')
                        else if (!widget.isCheckoutAccessible)
                          const Text('Complete order requirements...')
                        else
                          const Text('Checkout'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderRequirements extends StatelessWidget {
  final List<OrderNote> vendorNotes;
  final List<OrderNote> brandNotes;
  final List<OrderNote> productNotes;
  final List<OrderNote> skuNotes;
  final MerzSyringePromotion? merzPromotion;

  const OrderRequirements({
    super.key,
    this.vendorNotes = const <OrderNote>[],
    this.brandNotes = const <OrderNote>[],
    this.productNotes = const <OrderNote>[],
    this.skuNotes = const <OrderNote>[],
    this.merzPromotion,
  });

  static final global = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    // final allNotes = [...vendorNotes, ...brandNotes, ...productNotes, ...skuNotes];
    //
    // if (allNotes.isEmpty) return SizedBox.shrink();

    return GalaxyPanel(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Requirements',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const Divider(height: 16),
          // VENDOR REQUIREMENTS
          buildOrderNotes(context, vendorNotes, 'vendor'),
          // ...vendorNotes.map((orderNote) {
          //   final vendor = global.vendors.firstWhere((vendor) => vendor.vendorId == orderNote.knownId);
          //   return Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text(vendor.name, style: TextStyle(fontSize: 13.33)),
          //       ...orderNote.orderRules.map((orderRule) {
          //         return Wrap(
          //           alignment: WrapAlignment.spaceBetween,
          //           children: [
          //             Text(
          //               orderRule.ruleMessage,
          //               style: TextStyle(fontSize: 11.11),
          //             ),
          //             if (orderRule.isRuleSatisfied) ...[
          //               Icon(Icons.check_circle, color: Colors.green, size: 13.33),
          //             ],
          //             Row(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 // const SizedBox(width: 4),
          //                 if (orderRule.ruleType == 'QUANTITY' && orderRule.requiredQuantity > 0)
          //                   GestureDetector(
          //                     onTap: () {
          //                       showDialog(
          //                         context: context,
          //                         builder: (context) => Obx(() {
          //                           final orderRuleX = global.simpleCart.value.vendorOrderNotes
          //                               .firstWhere((element) => element.knownId == vendor.vendorId)
          //                               .orderRules
          //                               .firstWhere((element) => element.id == orderRule.id);
          //                           return MixMatchDialog(
          //                             title: orderRule.ruleMessage,
          //                             groupName: vendor.name,
          //                             cart: global.simpleCart.value,
          //                             // Get restylane products: brandId: 81
          //                             products: global.allProducts.value
          //                                 .getProductsByVendorIds(vendorIds: [orderNote.knownId]),
          //                             quantityLeft: orderRuleX.requiredQuantity,
          //                             onProductQuantityChanged: (sku, newQuantity) async {
          //                               await global.basket.addToCart(
          //                                 customerId: global.user.value.profileId.toString(),
          //                                 skuId: sku.skuId,
          //                                 quantity: newQuantity,
          //                               );
          //                             },
          //                           );
          //                         }),
          //                       );
          //                     },
          //                     child: Text(
          //                       'Add ${orderRule.requiredQuantity} more >>',
          //                       style: TextStyle(
          //                         fontSize: 11.11,
          //                         color: YLiftColor.orange,
          //                         decoration: TextDecoration.underline,
          //                         decorationColor: YLiftColor.orange,
          //                       ),
          //                     ),
          //                   ),
          //                 if (orderRule.spendingLeft != null)
          //                   GestureDetector(
          //                     onTap: () {
          //                       showDialog(
          //                         context: context,
          //                         builder: (context) => Obx(() {
          //                           final orderRuleX = global.simpleCart.value.vendorOrderNotes
          //                               .firstWhere((element) => element.knownId == vendor.vendorId)
          //                               .orderRules
          //                               .firstWhere((element) => element.id == orderRule.id);
          //                           return MixMatchDialog(
          //                             title: orderRule.ruleMessage,
          //                             groupName: vendor.name,
          //                             cart: global.simpleCart.value,
          //                             // Get restylane products: brandId: 81
          //                             products: global.allProducts.value
          //                                 .getProductsByVendorIds(vendorIds: [orderNote.knownId]),
          //                             quantityLeft: orderRuleX.requiredQuantity,
          //                             onProductQuantityChanged: (sku, newQuantity) async {
          //                               await global.basket.addToCart(
          //                                 customerId: global.user.value.profileId.toString(),
          //                                 skuId: sku.skuId,
          //                                 quantity: newQuantity,
          //                               );
          //                             },
          //                           );
          //                         }),
          //                       );
          //                     },
          //                     child: Text(
          //                       '${orderRule.spendingLeft!.toCurrency()} left.',
          //                       style: TextStyle(
          //                         fontSize: 11.11,
          //                         color: YLiftColor.orange,
          //                         decoration: TextDecoration.underline,
          //                         decorationColor: YLiftColor.orange,
          //                       ),
          //                     ),
          //                   ),
          //                 if (!orderRule.isRuleSatisfied) Icon(Icons.cancel, color: YLiftColor.orange, size: 13.33)
          //               ],
          //             ),
          //           ],
          //         );
          //       }),
          //       const SizedBox(height: 8),
          //     ],
          //   );
          // }),

          // BRAND REQUIREMENTS
          buildOrderNotes(context, brandNotes, 'brand'),
          // ...brandNotes.map((orderNote) {
          //   final brand = global.brands.firstWhere((brand) => brand.brandId == orderNote.knownId);
          //   return Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text(brand.name, style: TextStyle(fontSize: 13.33)),
          //       ...orderNote.orderRules.map((orderRule) {
          //         return Wrap(
          //           alignment: WrapAlignment.spaceBetween,
          //           children: [
          //             Text(
          //               orderRule.ruleMessage,
          //               style: TextStyle(fontSize: 11.11),
          //             ),
          //             if (orderRule.isRuleSatisfied) ...[Icon(Icons.check_circle, color: Colors.green, size: 13.33)],
          //             Row(
          //               children: [
          //                 if (orderRule.ruleType == 'QUANTITY' && orderRule.requiredQuantity > 0)
          //                   GestureDetector(
          //                     onTap: () {
          //                       showDialog(
          //                         context: context,
          //                         builder: (context) => Obx(() {
          //                           final orderRuleX = global.simpleCart.value.brandOrderNotes
          //                               .firstWhere((element) => element.knownId == brand.brandId)
          //                               .orderRules
          //                               .firstWhere((element) => element.id == orderRule.id);
          //                           return MixMatchDialog(
          //                             title: orderRule.ruleMessage,
          //                             groupName: brand.name,
          //                             cart: global.simpleCart.value,
          //                             // Get restylane products: brandId: 81
          //                             products:
          //                                 global.allProducts.value.getProductsByBrandIds(brandIds: [orderNote.knownId]),
          //                             quantityLeft: orderRuleX.requiredQuantity,
          //                             onProductQuantityChanged: (sku, newQuantity) async {
          //                               await global.basket.addToCart(
          //                                 customerId: global.user.value.profileId.toString(),
          //                                 skuId: sku.skuId,
          //                                 quantity: newQuantity,
          //                               );
          //                             },
          //                           );
          //                         }),
          //                       );
          //                     },
          //                     child: Row(
          //                       children: [
          //                         Text(
          //                           'Add ${orderRule.requiredQuantity} more >>',
          //                           style: TextStyle(
          //                             fontSize: 11.11,
          //                             color: YLiftColor.orange,
          //                             decoration: TextDecoration.underline,
          //                             decorationColor: YLiftColor.orange,
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 if (orderRule.spendingLeft != null)
          //                   GestureDetector(
          //                     onTap: () {
          //                       showDialog(
          //                         context: context,
          //                         builder: (context) => Obx(() {
          //                           final orderRuleX = global.simpleCart.value.brandOrderNotes
          //                               .firstWhere((element) => element.knownId == brand.brandId)
          //                               .orderRules
          //                               .firstWhere((element) => element.id == orderRule.id);
          //                           return MixMatchDialog(
          //                             title: orderRule.ruleMessage,
          //                             groupName: brand.name,
          //                             cart: global.simpleCart.value,
          //                             // Get restylane products: brandId: 81
          //                             products:
          //                                 global.allProducts.value.getProductsByBrandIds(brandIds: [orderNote.knownId]),
          //                             quantityLeft: orderRuleX.requiredQuantity,
          //                             onProductQuantityChanged: (sku, newQuantity) async {
          //                               await global.basket.addToCart(
          //                                 customerId: global.user.value.profileId.toString(),
          //                                 skuId: sku.skuId,
          //                                 quantity: newQuantity,
          //                               );
          //                             },
          //                           );
          //                         }),
          //                       );
          //                     },
          //                     child: Row(
          //                       children: [
          //                         Text(
          //                           '${orderRule.spendingLeft!.toCurrency()} left.',
          //                           style: TextStyle(
          //                             fontSize: 11.11,
          //                             color: YLiftColor.orange,
          //                             decoration: TextDecoration.underline,
          //                             decorationColor: YLiftColor.orange,
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 if (!orderRule.isRuleSatisfied) Icon(Icons.cancel, color: YLiftColor.orange, size: 13.33)
          //               ],
          //             ),
          //           ],
          //         );
          //       }),
          //       const SizedBox(height: 8),
          //     ],
          //   );
          // }),

          // Product REQUIREMENTS
          buildOrderNotes(context, productNotes, 'product'),
          // ...productNotes.map((orderNote) {
          //   final product =
          //       global.allProducts.value.products.firstWhere((product) => product.productId == orderNote.knownId);
          //   return Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text(product.name, style: TextStyle(fontSize: 13.33)),
          //       ...orderNote.orderRules.map((orderRule) {
          //         return Wrap(
          //           alignment: WrapAlignment.spaceBetween,
          //           children: [
          //             Text(
          //               orderRule.ruleMessage,
          //               style: TextStyle(fontSize: 11.11),
          //             ),
          //             if (orderRule.isRuleSatisfied) ...[
          //               Icon(Icons.check_circle, color: Colors.green, size: 13.33),
          //             ],
          //             Row(
          //               children: [
          //                 if (orderRule.ruleType == 'QUANTITY' && orderRule.requiredQuantity > 0)
          //                   GestureDetector(
          //                     onTap: () {
          //                       showDialog(
          //                         context: context,
          //                         builder: (context) => Obx(() {
          //                           final orderRuleX = global.simpleCart.value.productOrderNotes
          //                               .firstWhere((element) => element.knownId == product.productId)
          //                               .orderRules
          //                               .firstWhere((element) => element.id == orderRule.id);
          //                           final products = global.allProducts.value.products
          //                               .where((p) => p.productId == product.productId);
          //
          //                           return MixMatchDialog(
          //                             title: orderRule.ruleMessage,
          //                             groupName: product.name,
          //                             cart: global.simpleCart.value,
          //                             // Get restylane products: brandId: 81
          //                             products: products,
          //                             quantityLeft: orderRuleX.requiredQuantity,
          //                             expandSkus: true,
          //                             onProductQuantityChanged: (sku, newQuantity) async {
          //                               await global.basket.addToCart(
          //                                 customerId: global.user.value.profileId.toString(),
          //                                 skuId: sku.skuId,
          //                                 quantity: newQuantity,
          //                               );
          //                             },
          //                           );
          //                         }),
          //                       );
          //                     },
          //                     child: Row(
          //                       children: [
          //                         Text(
          //                           'Add ${orderRule.requiredQuantity} more >>',
          //                           style: TextStyle(
          //                             fontSize: 11.11,
          //                             color: YLiftColor.orange,
          //                             decoration: TextDecoration.underline,
          //                             decorationColor: YLiftColor.orange,
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 if (orderRule.spendingLeft != null)
          //                   GestureDetector(
          //                     onTap: () {
          //                       showDialog(
          //                         context: context,
          //                         builder: (context) => Obx(() {
          //                           final orderRuleX = global.simpleCart.value.productOrderNotes
          //                               .firstWhere((element) => element.knownId == product.productId)
          //                               .orderRules
          //                               .firstWhere((element) => element.id == orderRule.id);
          //                           final products = global.allProducts.value.products
          //                               .where((p) => p.productId == product.productId);
          //
          //                           return MixMatchDialog(
          //                             title: orderRule.ruleMessage,
          //                             groupName: product.name,
          //                             cart: global.simpleCart.value,
          //                             // Get restylane products: brandId: 81
          //                             products: products,
          //                             quantityLeft: orderRuleX.requiredQuantity,
          //                             expandSkus: true,
          //                             onProductQuantityChanged: (sku, newQuantity) async {
          //                               await global.basket.addToCart(
          //                                 customerId: global.user.value.profileId.toString(),
          //                                 skuId: sku.skuId,
          //                                 quantity: newQuantity,
          //                               );
          //                             },
          //                           );
          //                         }),
          //                       );
          //                     },
          //                     child: Row(
          //                       children: [
          //                         Text(
          //                           '${orderRule.spendingLeft!.toCurrency()} left.',
          //                           style: TextStyle(
          //                             fontSize: 11.11,
          //                             color: YLiftColor.orange,
          //                             decoration: TextDecoration.underline,
          //                             decorationColor: YLiftColor.orange,
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 if (!orderRule.isRuleSatisfied) Icon(Icons.cancel, color: YLiftColor.orange, size: 13.33)
          //               ],
          //             ),
          //           ],
          //         );
          //       }),
          //       const SizedBox(height: 8),
          //     ],
          //   );
          // }),

          // SKU REQUIREMENTS
          buildOrderNotes(context, skuNotes, 'sku'),
          // ...skuNotes.map((orderNote) {
          //   final product =
          //       global.allProducts.value.products.firstWhere((product) => product.skuIds.contains(orderNote.knownId));
          //   final sku = product.skus!.firstWhere((sku) => int.parse(sku.skuId) == orderNote.knownId);
          // return Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     const SizedBox(height: 8),
          //     Text(product.name, style: TextStyle(fontSize: 13.33)),
          //     ...orderNote.orderRules.map((orderRule) {
          //       return Wrap(
          //         alignment: WrapAlignment.spaceBetween,
          //         children: [
          //           Text(
          //             orderRule.ruleMessage,
          //             style: TextStyle(fontSize: 11.11),
          //           ),
          //           if (orderRule.isRuleSatisfied) ...[Icon(Icons.check_circle, color: Colors.green, size: 13.33)],
          //           Row(
          //             children: [
          //               if (orderRule.ruleType == 'QUANTITY' && orderRule.requiredQuantity > 0)
          //                 GestureDetector(
          //                   onTap: () {
          //                     showDialog(
          //                       context: context,
          //                       builder: (context) => Obx(() {
          //                         final orderRuleX = global.simpleCart.value.skuOrderNotes
          //                             .firstWhere((element) => element.knownId == int.parse(sku.skuId))
          //                             .orderRules
          //                             .firstWhere((element) => element.id == orderRule.id);
          //                         final products = global.allProducts.value.products.where((p) =>
          //                             p.productId == product.productId && p.skuIds.contains(int.parse(sku.skuId)));
          //
          //                         return MixMatchDialog(
          //                           title: orderRule.ruleMessage,
          //                           groupName: product.name,
          //                           cart: global.simpleCart.value,
          //                           products: products,
          //                           quantityLeft: orderRuleX.requiredQuantity,
          //                           onProductQuantityChanged: (sku, newQuantity) async {
          //                             await global.basket.addToCart(
          //                               customerId: global.user.value.profileId.toString(),
          //                               skuId: sku.skuId,
          //                               quantity: newQuantity,
          //                             );
          //                           },
          //                         );
          //                       }),
          //                     );
          //                   },
          //                   child: Row(
          //                     children: [
          //                       Text(
          //                         'Add ${orderRule.requiredQuantity} more >>',
          //                         style: TextStyle(
          //                           fontSize: 11.11,
          //                           color: YLiftColor.orange,
          //                           decoration: TextDecoration.underline,
          //                           decorationColor: YLiftColor.orange,
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               if (orderRule.spendingLeft != null)
          //                 GestureDetector(
          //                   onTap: () {
          //                     showDialog(
          //                       context: context,
          //                       builder: (context) => Obx(() {
          //                         final orderRuleX = global.simpleCart.value.skuOrderNotes
          //                             .firstWhere((element) => element.knownId == int.parse(sku.skuId))
          //                             .orderRules
          //                             .firstWhere((element) => element.id == orderRule.id);
          //                         final products = global.allProducts.value.products.where((p) =>
          //                             p.productId == product.productId && p.skuIds.contains(int.parse(sku.skuId)));
          //
          //                         return MixMatchDialog(
          //                           title: orderRule.ruleMessage,
          //                           groupName: product.name,
          //                           cart: global.simpleCart.value,
          //                           products: products,
          //                           quantityLeft: orderRuleX.requiredQuantity,
          //                           onProductQuantityChanged: (sku, newQuantity) async {
          //                             await global.basket.addToCart(
          //                               customerId: global.user.value.profileId.toString(),
          //                               skuId: sku.skuId,
          //                               quantity: newQuantity,
          //                             );
          //                           },
          //                         );
          //                       }),
          //                     );
          //                   },
          //                   child: Row(
          //                     children: [
          //                       Text(
          //                         '${orderRule.spendingLeft!.toCurrency()} left.',
          //                         style: TextStyle(
          //                           fontSize: 11.11,
          //                           color: YLiftColor.orange,
          //                           decoration: TextDecoration.underline,
          //                           decorationColor: YLiftColor.orange,
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               if (!orderRule.isRuleSatisfied) Icon(Icons.cancel, color: YLiftColor.orange, size: 13.33),
          //             ],
          //           )
          //         ],
          //       );
          //     }),
          //     const SizedBox(height: 8),
          //   ],
          // );
          // }),
          if (global.galdermaController.currentTierPromotion != null) PracticeLuxuryOrderRule(promotion: global.galdermaController.currentTierPromotion!),
          if (merzPromotion != null) MerzOrderRule(merzPromotion: merzPromotion!),
        ],
      ),
    );
  }
}

Widget buildOrderNotes(BuildContext context, List<OrderNote> orderNotes, String noteType) {
  return Column(children: orderNotes.map((orderNote) {
    dynamic entity;
    Iterable<ProductSimple> products;
    String entityName;
    List<CartOrderRule> orderRules;
    int knownId;
    bool expandSkus = false;

    switch (noteType) {
      case 'vendor':
        entity =
            global.vendors.firstWhere((v) => v.vendorId == orderNote.knownId);
        products = global.allProducts.value.getProductsByVendorIds(
            vendorIds: [orderNote.knownId]);
        entityName = entity.name;
        orderRules = orderNote.orderRules;
        knownId = entity.vendorId;
        break;
      case 'brand':
        entity =
            global.brands.firstWhere((b) => b.brandId == orderNote.knownId);
        products = global.allProducts.value.getProductsByBrandIds(
            brandIds: [orderNote.knownId]);
        entityName = entity.name;
        orderRules = orderNote.orderRules;
        knownId = entity.brandId;
        break;
      case 'product':
        entity =
            global.allProducts.value.products.firstWhere((p) =>
            p.productId ==
                orderNote.knownId);
        products = global.allProducts.value.products.where((p) =>
        p.productId ==
            entity.productId);
        entityName = entity.name;
        orderRules = orderNote.orderRules;
        knownId = entity.productId;
        expandSkus = true;
        break;
      case 'sku':
        entity = global.allProducts.value.products.firstWhere((p) =>
            p.skuIds.contains(orderNote.knownId));
        final sku = entity.skus!.firstWhere((s) =>
        int.parse(s.skuId) == orderNote.knownId);
        products = global.allProducts.value.products.where((p) =>
        p.productId == entity.productId &&
            p.skuIds.contains(int.parse(sku.skuId))).toList();
        entityName = entity.name;
        orderRules = orderNote.orderRules;
        knownId = int.parse(sku.skuId);
        break;
      default:
        throw Exception('Invalid noteType: $noteType');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (noteType != 'sku') Text(
            entityName, style: TextStyle(fontSize: 13.33)),
        if (noteType == 'sku') const SizedBox(height: 8),
        // Add spacing only for SKU

        ...orderRules.map((orderRule) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Wrap(
                  children: [
                    Text(orderRule.ruleMessage, style: TextStyle(fontSize: 11.11)),
                    if (orderRule.ruleType == 'QUANTITY' &&
                        orderRule.requiredQuantity > 0)
                      _buildAddMoreButton(
                          context,
                          orderRule,
                          entityName,
                          products,
                          knownId,
                          noteType,
                          expandSkus),
                    if (orderRule.spendingLeft != null)
                      _buildSpendingLeftButton(
                          context,
                          orderRule,
                          entityName,
                          products,
                          knownId,
                          noteType,
                          expandSkus),
                  ],
                ),
              ),
              if (orderRule.isRuleSatisfied)
                Icon(Icons.check_circle, color: Colors.green, size: 13.33)
              else
                Icon(Icons.cancel, color: YLiftColor.orange, size: 13.33),
            ],
          );
        }),
        const SizedBox(height: 8),
      ],
    );
  }).toList(),
  );
}

Widget _buildAddMoreButton(BuildContext context, CartOrderRule orderRule, String entityName, Iterable<ProductSimple> products, int knownId, String noteType, bool expandSkus) {
  return GestureDetector(
    onTap: () {
      showDialog(
        context: context,
        builder: (context) => Obx(() {
          dynamic orderRuleX;
          switch (noteType) {
            case 'vendor': orderRuleX = global.simpleCart.value.vendorOrderNotes.firstWhere((element) => element.knownId == knownId).orderRules.firstWhere((element) => element.id == orderRule.id); break;
            case 'brand': orderRuleX = global.simpleCart.value.brandOrderNotes.firstWhere((element) => element.knownId == knownId).orderRules.firstWhere((element) => element.id == orderRule.id); break;
            case 'product': orderRuleX = global.simpleCart.value.productOrderNotes.firstWhere((element) => element.knownId == knownId).orderRules.firstWhere((element) => element.id == orderRule.id); break;
            case 'sku': orderRuleX = global.simpleCart.value.skuOrderNotes.firstWhere((element) => element.knownId == knownId).orderRules.firstWhere((element) => element.id == orderRule.id); break;
          }
          return MixMatchDialog(
            title: orderRule.ruleMessage,
            groupName: entityName,
            cart: global.simpleCart.value,
            products: products,
            quantityLeft: orderRuleX.requiredQuantity,
            expandSkus: expandSkus,
            onProductQuantityChanged: (sku, newQuantity) async {
              await global.basket.addToCart(
                customerId: global.user.value.profileId.toString(),
                quantity: newQuantity,
                product: "${sku.productId}-${sku.skuId}"
              );
            },
          );
        }),
      );
    },
    child: Text(
      'Add ${orderRule.requiredQuantity} more >>',
      style: TextStyle(
        fontSize: 11.11,
        color: YLiftColor.orange,
        decoration: TextDecoration.underline,
        decorationColor: YLiftColor.orange,
      ),
    ),
  );
}

Widget _buildSpendingLeftButton(BuildContext context, CartOrderRule orderRule, String entityName, Iterable<ProductSimple> products, int knownId, String noteType, bool expandSkus) {
  return GestureDetector(
    onTap: () {
      showDialog(
        context: context,
        builder: (context) =>
            Obx(() {
              dynamic orderRuleX;
              switch (noteType) {
                case 'vendor':
                  orderRuleX = global.simpleCart.value.vendorOrderNotes
                      .firstWhere((element) => element.knownId == knownId)
                      .orderRules
                      .firstWhere((element) => element.id == orderRule.id);
                  break;
                case 'brand':
                  orderRuleX = global.simpleCart.value.brandOrderNotes
                      .firstWhere((element) => element.knownId == knownId)
                      .orderRules
                      .firstWhere((element) => element.id == orderRule.id);
                  break;
                case 'product':
                  orderRuleX = global.simpleCart.value.productOrderNotes
                      .firstWhere((element) => element.knownId == knownId)
                      .orderRules
                      .firstWhere((element) => element.id == orderRule.id);
                  break;
                case 'sku':
                  orderRuleX = global.simpleCart.value.skuOrderNotes
                      .firstWhere((element) => element.knownId == knownId)
                      .orderRules
                      .firstWhere((element) => element.id == orderRule.id);
                  break;
              }
              return MixMatchDialog(
                title: orderRule.ruleMessage,
                groupName: entityName,
                cart: global.simpleCart.value,
                products: products,
                quantityLeft: orderRuleX.requiredQuantity,
                // Might need adjustment for spending
                spendingLeft: orderRuleX.spendingLeft,
                expandSkus: expandSkus,
                onProductQuantityChanged: (sku, newQuantity) async {
                  await global.basket.addToCart(
                    customerId: global.user.value.profileId.toString(),
                    quantity: newQuantity,
                    product: "${sku.productId}-${sku.skuId}"
                  );
                },
              );
            }),
      );
    },
    child: Text(
      '${orderRule.spendingLeft!.toCurrency()} left.',
      style: TextStyle(
        fontSize: 11.11,
        color: YLiftColor.orange,
        decoration: TextDecoration.underline,
        decorationColor: YLiftColor.orange,
      ),
    ),
  );
}