import 'package:YLift/models/_clean/product.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_models/carts/CartItemSimple.dart';
import 'package:galaxy_models/core/core.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:get/get.dart';

class MobileProductData {
  final int productId;
  final int skuId;
  final String productName;
  final String imageUrl;
  final int price;
  final String? skuAttributes;
  final int quantity;
  final int? minimumQuantity;
  final int? maximumQuantity;
  final int incrementQuantity;

  const MobileProductData({
    required this.productId,
    required this.skuId,
    required this.productName,
    required this.imageUrl,
    required this.price,
    this.skuAttributes,
    required this.quantity,
    this.minimumQuantity,
    this.maximumQuantity,
    this.incrementQuantity = 1,
  });

  factory MobileProductData.fromProduct(
    ProductSimple product, {
    int? skuId,
    int quantity = 0,
  }) {
    final sku =
        product.skus!.firstWhereOrNull(
          (sku) => int.parse(sku.skuId) == skuId,
        ) ??
        product.skus!.first;
    return MobileProductData(
      productId: product.productId!,
      skuId: int.parse(sku.skuId),
      productName: product.name,
      imageUrl: product.imageUrl,
      price: sku.tieredPrice,
      skuAttributes: sku.attributeName,
      quantity: quantity,
      minimumQuantity: sku.quantityMinimum,
      maximumQuantity: sku.quantityMaximum,
      incrementQuantity: sku.quantityIncrement,
    );
  }

  factory MobileProductData.fromCartItem(CartItemSimple item) {
    return MobileProductData(
      productId: item.productId!,
      skuId: item.skuId,
      productName: item.productName,
      imageUrl: item.imageUrl!,
      price: item.total,
      skuAttributes: item.sku.attributeName,
      quantity: item.quantity,
      minimumQuantity: item.sku.quantityMinimum,
      maximumQuantity: item.sku.quantityMaximum,
      incrementQuantity: item.sku.quantityIncrement,
    );
  }
}

class MobileCartItemTile extends StatelessWidget {
  final MobileProductData item;
  final void Function()? onRemove;
  final void Function(int value)? onQuantityChanged;
  final String? message;

  final bool hidePrice;

  const MobileCartItemTile({
    super.key,
    required this.item,
    this.onQuantityChanged,
    this.onRemove,
    this.message,
    this.hidePrice = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox.square(
              dimension: 64,
              child: Image.network(item.imageUrl, fit: BoxFit.cover),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (item.skuAttributes != null)
                    Text(
                      item.skuAttributes!,
                      style: const TextStyle(fontSize: 12),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (!hidePrice)
                        Text(
                          item.price.toCurrency(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      const Spacer(),
                      if (onRemove != null)
                        IconButton(
                          onPressed: onRemove,
                          padding: EdgeInsets.zero,
                          iconSize: 24,
                          icon: const Icon(Icons.delete_outline),
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                          color: Colors.red.shade200,
                        ),
                      if (onQuantityChanged != null)
                        MobileCartItemQuantityField(
                          value: item.quantity,
                          onChanged: onQuantityChanged!,
                          minimumQuantity: item.minimumQuantity,
                          maximumQuantity: item.maximumQuantity,
                          incrementQuantity: item.incrementQuantity,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        if (message != null && message!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            message!,
            style: const TextStyle(fontSize: 12, color: Colors.red),
          ),
        ],
      ],
    );
  }
}
