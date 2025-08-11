import 'dart:async';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/presentation/components/_complex/dropdowns/quantity_dropdown.dart';
import 'package:YLift/presentation/components/_simple/product_image_view.dart';
import 'package:flutter/material.dart';

class DrawerCartItemTile extends StatefulWidget {
  final CartItemSimple cartItem;
  final void Function(int newQuantity) onUpdateQuantity;
  final void Function() onDelete;

  const DrawerCartItemTile({
    super.key,
    required this.cartItem,
    required this.onUpdateQuantity,
    required this.onDelete,
  });

  @override
  State<DrawerCartItemTile> createState() => _DrawerCartItemTileState();
}

class _DrawerCartItemTileState extends State<DrawerCartItemTile> {
  int quantity = 1;

  @override
  void initState() {
    quantity = widget.cartItem.quantity;
    super.initState();
  }

  Timer? debounceTimer;

  void updateQuantity(int newQuantity) {
    debounceTimer?.cancel();
    debounceTimer = Timer(
      const Duration(milliseconds: 400),
          () {
        widget.onUpdateQuantity(newQuantity);
      },
    );
  }

  @override
  void didUpdateWidget(covariant DrawerCartItemTile oldWidget) {
    if (widget.cartItem.quantity != oldWidget.cartItem.quantity) {
      quantity = widget.cartItem.quantity;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 640,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 80,
                child: ProductImageView(imageUrl: widget.cartItem.imageUrl),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.cartItem.productName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    if (widget.cartItem.sku.attributeName != null) ...[
                      Text(
                        widget.cartItem.sku.attributeName!,
                        style: TextStyle(fontSize: 13.33),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Text(
                widget.cartItem.total.toCurrency(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 80 + 16),
              SizedBox(
                height: 32,
                width: 120,
                child: QuantityDropdown(
                  isActive: true,
                  isExpanded: true,
                  value: quantity,
                  withLabel: false,
                  isDense: true,
                  contentPadding: const EdgeInsets.only(left: 16, right: 8),
                  onChanged: updateQuantity,
                  incrementQty: widget.cartItem.sku.quantityIncrement,
                  minQty: widget.cartItem.sku.quantityMinimum,
                  maxQty: widget.cartItem.sku.quantityMaximum,
                ),
              ),
              const SizedBox(width: 16),
              TextButton(
                onPressed: widget.onDelete,
                child: const Text(
                  'DELETE',
                  style: TextStyle(fontSize: 13.33),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}