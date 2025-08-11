import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:YLift/presentation/components/mobile_scaffold.dart';
import 'package:YLift/presentation/pages/mobile/cart/components/mobile_cart_item_tile.dart';
import 'package:YLift/presentation/pages/mobile/promotion/mobile_free_radiesse_page.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_models/core/constants/y_lift_color.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:get/get.dart';

class MobilePromotionData {
  final String imageUrl;
  final String title;
  final String description;
  final List<String> productSkuIds;

  final int? minimumQuantity;
  bool get hasMinimumQuantity =>
      minimumQuantity != null && minimumQuantity! > 0;

  final bool hasFreeRewards;
  final List<String>? freeProductSkuIds;

  const MobilePromotionData({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.productSkuIds,
    this.minimumQuantity,
    this.hasFreeRewards = false,
    this.freeProductSkuIds,
  }) : assert(
         !hasFreeRewards ||
             (freeProductSkuIds != null && freeProductSkuIds.length > 0),
         'If hasFreeRewards is true, freeProductSkuIds must be provided and contain at least one value',
       );
}

class PromotionProductSelectionScreen extends StatefulWidget {
  final MobilePromotionData promotionData;
  final void Function(Map<String, int> selectedQuantities) onComplete;
  final bool isLoading;

  const PromotionProductSelectionScreen({
    super.key,
    required this.promotionData,
    required this.onComplete,
    this.isLoading = false,
  });

  @override
  State<PromotionProductSelectionScreen> createState() =>
      _PromotionProductSelectionScreenState();
}

class _PromotionProductSelectionScreenState
    extends State<PromotionProductSelectionScreen> {
  final global = Get.find<GlobalController>();
  final selectedQuantities = <String, int>{};

  int get totalSelected =>
      selectedQuantities.values.fold(0, (sum, qty) => sum + qty);

  @override
  void initState() {
    super.initState();

    for (final productSkuId in widget.promotionData.productSkuIds) {
      final productId = productSkuId.split('-').first;
      final quantity =
          global.simpleCart.value.cartItems
              .firstWhereOrNull(
                (item) => item.productId == int.parse(productId),
              )
              ?.quantity;
      selectedQuantities[productSkuId] = quantity ?? 0;
    }
    // for (var product in widget.products) {
    //   final existingQty = global.simpleCart.value.cartItems
    //       .where((e) => e.productId == product.productId)
    //       .fold<int>(0, (sum, item) => sum + item.quantity);
    //   selectedQuantities[product] = existingQty;
    // }
  }

  @override
  Widget build(BuildContext context) {
    final remaining =
        (widget.promotionData.minimumQuantity ?? 0) - totalSelected;
    final requirementMet = remaining <= 0;

    return MobileScaffold(
      title: widget.promotionData.title,
      onBackPressed: () {
        Navigator.pop(context);
      },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  widget.promotionData.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.promotionData.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF343434),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Choose your products',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),

          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: widget.promotionData.productSkuIds.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (_, index) {
                final productSkuId = widget.promotionData.productSkuIds[index];
                final productId = productSkuId.split('-').first;
                final skuId = productSkuId.split('-').last;
                final product = global.allProducts.value.getById(
                  int.parse(productId),
                );
                final sku = product!.skus!.firstWhere(
                  (e) => e.skuId == skuId,
                );
                final quantity = selectedQuantities[productSkuId] ?? 0;

                final item = MobileProductData(
                  productId: int.parse(productId),
                  skuId: int.parse(skuId),
                  productName: product.name,
                  imageUrl: product.imageUrl,
                  price: sku.tieredPrice,
                  skuAttributes: sku.attributeName,
                  quantity: quantity,
                );
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(16),
                  child: MobileCartItemTile(
                    item: item,
                    onQuantityChanged: (value) {
                      setState(() {
                        selectedQuantities[productSkuId] = value;
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomBar: MobileBar(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            if (!requirementMet)
              Text(
                'Add ${remaining > 0 ? remaining : 0} more product(s) to qualify for this promotion.',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.red,
                ),
              ),
            GalaxyFilledButton(
              isExpanded: true,
              backgroundColor: YLiftColor.orange,
              onPressed:
                  requirementMet && !widget.isLoading
                      ? () {
                        widget.onComplete(selectedQuantities);
                      }
                      : null,
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
