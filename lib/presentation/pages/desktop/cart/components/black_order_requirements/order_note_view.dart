import 'package:YLift/core/controllers/global.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/presentation/pages/desktop/cart/components/black_order_requirements/order_rule_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderNoteView extends StatelessWidget {
  final OrderNote orderNote;
  final void Function(CartOrderRule orderRule)? onSelectedOrderRule;
  const OrderNoteView({
    super.key,
    required this.orderNote,
    required this.onSelectedOrderRule,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                _getName(orderNote.type, orderNote.knownId),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.33,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              orderNote.isSatisfied
                  ? Icon(Icons.check, color: Colors.green, size: 13.33)
                  : const Icon(
                    Icons.info_outline,
                    color: YLiftColor.orange,
                    size: 13.33,
                  ),
            ],
          ),
        ),
        ...orderNote.orderRules.map((rule) {
          return OrderRuleTile(
            orderRule: rule,
            onTap:
                onSelectedOrderRule != null
                    ? () => onSelectedOrderRule!(rule)
                    : null,
          );
        }),
      ],
    );
  }
}

String _getName(OrderNoteType type, int knownId) {
  final global = Get.find<GlobalController>();
  switch (type) {
    case OrderNoteType.vendor:
      return global.vendors
              .firstWhereOrNull((element) => element.vendorId == knownId)
              ?.name ??
          'Vendor $knownId';
    case OrderNoteType.brand:
      return global.brands
              .firstWhereOrNull((element) => element.brandId == knownId)
              ?.name ??
          'Brand $knownId';
    case OrderNoteType.product:
      return global.allProducts.value.products
              .firstWhereOrNull((element) => element.productId == knownId)
              ?.name ??
          'Product $knownId';
    case OrderNoteType.sku:
      return global.allProducts.value.products
              .firstWhereOrNull(
                (product) => product.skus!.any(
                  (sku) => int.tryParse(sku.skuId) == knownId,
                ),
              )
              ?.skus!
              .first
              .skuId ??
          'SKU $knownId';
  }
}
