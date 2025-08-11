import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:YLift/models/z-index_export.dart';

import 'package:flutter/material.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:galaxy_ui/galaxy_ui.dart';

class ProductQuantitySelector extends StatefulWidget {
  final ProductSimple product;
  final int quantity;
  final Function(int) onQuantityChanged;

  const ProductQuantitySelector({
    Key? key,
    required this.product,
    required this.quantity,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  State<ProductQuantitySelector> createState() => _ProductQuantitySelectorState();
}

class _ProductQuantitySelectorState extends State<ProductQuantitySelector> {
  final global = Get.find<GlobalController>();
  late int quantity;
  late int quantityIncrement;
  late int quantityMin;
  late int quantityMax;

  @override
  void initState() {
    super.initState();
    quantity = widget.quantity;
    quantityIncrement = widget.product.skus!.first.quantityIncrement;
    quantityMin = widget.product.skus!.first.quantityMinimum;
    quantityMax = widget.product.skus!.first.quantityMaximum;
  }

  void _handleQuantityChange(int newQty) async {
    setState(() {
      quantity = newQty;
    });
    widget.onQuantityChanged(newQty);
  }

  @override
  Widget build(BuildContext context) {
    final price = widget.product.skus!.first.tieredPrice.toCurrency();
    final attribute = widget.product.skus!.first.attributeName;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              widget.product.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                if (attribute != null)
                  Text(attribute, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    SizedBox(
                      width: 100,
                      height: 40,
                      child: QuantityField(
                        value: quantity,
                        quantityIncrement: quantityIncrement,
                        quantityMinimum: quantityMin,
                        quantityMaximum: quantityMax,
                        checkMinimum: true,
                        onChanged: _handleQuantityChange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
