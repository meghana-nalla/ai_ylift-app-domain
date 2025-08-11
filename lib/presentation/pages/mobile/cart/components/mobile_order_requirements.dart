

import 'package:YLift/models/_clean/product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:galaxy_models/galaxy_models.dart';

import 'package:YLift/presentation/components/_complex/dialogs/mix_match_dialog.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:galaxy_ui/galaxy_ui.dart';

class OrderRequirementsMobile extends StatelessWidget {
  final List<OrderNote> vendorNotes;
  final List<OrderNote> brandNotes;
  final List<OrderNote> productNotes;
  final List<OrderNote> skuNotes;

  const OrderRequirementsMobile({
    super.key,
    required this.vendorNotes,
    required this.brandNotes,
    required this.productNotes,
    required this.skuNotes,
  });

  static final global = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    // Combine all notes into one list to simplify
    final List<_NoteWithType> allNotes = [
      ...vendorNotes.map((n) => _NoteWithType('vendor', n)),
      ...brandNotes.map((n) => _NoteWithType('brand', n)),
      ...productNotes.map((n) => _NoteWithType('product', n)),
      ...skuNotes.map((n) => _NoteWithType('sku', n)),
    ];
    if (allNotes.isEmpty) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Requirements',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const Divider(height: 16),
            ...allNotes.expand((noteWithType) => _buildOrderNote(context, noteWithType)),
          ],
        ),
      ),
    );
  }

  // Helper to build all order rules for a note
  List<Widget> _buildOrderNote(BuildContext context, _NoteWithType noteWithType) {
    final OrderNote note = noteWithType.note;
    final String type = noteWithType.type;
    dynamic entity;
    Iterable<ProductSimple> products;
    String entityName;
    bool expandSkus = false;

    switch (type) {
      case 'vendor':
        entity = global.vendors.firstWhere((v) => v.vendorId == note.knownId);
        products = global.allProducts.value.getProductsByVendorIds(vendorIds: [note.knownId]);
        entityName = entity.name;
        break;
      case 'brand':
        entity = global.brands.firstWhere((b) => b.brandId == note.knownId);
        products = global.allProducts.value.getProductsByBrandIds(brandIds: [note.knownId]);
        entityName = entity.name;
        break;
      case 'product':
        entity = global.allProducts.value.products.firstWhere((p) => p.productId == note.knownId);
        products = global.allProducts.value.products.where((p) => p.productId == entity.productId);
        entityName = entity.name;
        expandSkus = true;
        break;
      case 'sku':
        entity = global.allProducts.value.products.firstWhere((p) => p.skuIds.contains(note.knownId));
        final sku = entity.skus!.firstWhere((s) => int.parse(s.skuId) == note.knownId);
        products = global.allProducts.value.products.where(
              (p) => p.productId == entity.productId && p.skuIds.contains(int.parse(sku.skuId)),
        ).toList();
        entityName = entity.name;
        break;
      default:
        return [];
    }

    return [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Text(entityName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      ),
      ...note.orderRules.map((orderRule) => _buildOrderRuleRow(context, type, note, orderRule, entityName, products, expandSkus)).toList(),
      const SizedBox(height: 8),
    ];
  }

  Widget _buildOrderRuleRow(
      BuildContext context,
      String noteType,
      OrderNote note,
      CartOrderRule orderRule,
      String entityName,
      Iterable<ProductSimple> products,
      bool expandSkus,
      ) {
    return Row(
      children: [
        Expanded(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            children: [
              Text(orderRule.ruleMessage, style: const TextStyle(fontSize: 12)),
              if (orderRule.ruleType == 'QUANTITY' && orderRule.requiredQuantity > 0)
                _buildAddMoreButton(context, orderRule, entityName, products, note.knownId, noteType, expandSkus),
              if (orderRule.spendingLeft != null)
                _buildSpendingLeftButton(context, orderRule, entityName, products, note.knownId, noteType, expandSkus),
            ],
          ),
        ),
        if (orderRule.isRuleSatisfied)
          const Icon(Icons.check_circle, color: Colors.green, size: 18)
        else
          const Icon(Icons.cancel, color: YLiftColor.orange, size: 18),
      ],
    );
  }

  Widget _buildAddMoreButton(
      BuildContext context,
      CartOrderRule orderRule,
      String entityName,
      Iterable<ProductSimple> products,
      int knownId,
      String noteType,
      bool expandSkus,
      ) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => Obx(() {
            // Get latest orderRuleX by type
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
              expandSkus: expandSkus,
              onProductQuantityChanged: (sku, newQuantity) async {
                await global.basket.addToCart(
                  customerId: global.user.value.profileId.toString(),
                  quantity: newQuantity,
                  product: "${sku.productId}-${sku.skuId}",
                );
              },
            );
          }),
        );
      },
      child: Text(
        'Add ${orderRule.requiredQuantity} more >>',
        style: const TextStyle(
          fontSize: 12,
          color: YLiftColor.orange,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget _buildSpendingLeftButton(
      BuildContext context,
      CartOrderRule orderRule,
      String entityName,
      Iterable<ProductSimple> products,
      int knownId,
      String noteType,
      bool expandSkus,
      ) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => Obx(() {
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
              spendingLeft: orderRuleX.spendingLeft,
              expandSkus: expandSkus,
              onProductQuantityChanged: (sku, newQuantity) async {
                await global.basket.addToCart(
                  customerId: global.user.value.profileId.toString(),
                  quantity: newQuantity,
                  product: "${sku.productId}-${sku.skuId}",
                );
              },
            );
          }),
        );
      },
      child: Text(
        '${orderRule.spendingLeft!.toCurrency} left.',
        style: const TextStyle(
          fontSize: 12,
          color: YLiftColor.orange,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}

class _NoteWithType {
  final String type;
  final OrderNote note;
  _NoteWithType(this.type, this.note);
}
