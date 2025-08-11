import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/models/_clean/product.dart';
import 'package:YLift/models/simple/CartSimple.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/presentation/components/_complex/dropdowns/sku_dropdown_menu.dart';
import 'package:YLift/presentation/components/_simple/product_image_view.dart';
import 'package:YLift/presentation/pages/desktop/cart/components/merz_promotion_dialog.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_ui/galaxy_ui.dart';

class SelectMerzDialog extends StatefulWidget {
  final MerzSyringePromotion merzPromotion;
  final String title;
  final CartSimple? cart;
  final Iterable<FreeCartItem>? freeItems;
  final Iterable<ProductSimple> products;
  // final int quantityLeft;
  final int maxQuantity;
  final void Function(SkuSimple sku, int newQuantity)? onProductQuantityChanged;
  final bool expandSkus;

  const SelectMerzDialog({
    super.key,
    required this.merzPromotion,
    required this.title,
    this.cart,
    required this.products,
    this.onProductQuantityChanged,
    // this.quantityLeft = 0,
    this.expandSkus = false,
    this.freeItems,
    required this.maxQuantity,
  });

  @override
  State<SelectMerzDialog> createState() => _SelectMerzDialogState();
}

class _SelectMerzDialogState extends State<SelectMerzDialog> {
  late Map<String, int> quantityMap;
  int get totalQuantity => quantityMap.values.fold(
    0,
    (previousValue, element) => previousValue + element,
  );
  int get quantityLeft => widget.merzPromotion.freeBoxes - totalQuantity;

  @override
  initState() {
    quantityMap = Map.fromEntries(
      widget.products.map((e) {
        final freeItem = widget.freeItems?.firstWhereOrNull(
          (item) => item.productId == e.productId,
        );
        return MapEntry(e.skus!.first.skuId, freeItem?.quantity ?? 0);
      }),
    );

    super.initState();
  }

  String get message {
    if (quantityLeft > 0) {
      return 'Add $quantityLeft more of Merz products to reach the minimum checkout quantity';
    }
    return 'You are qualified for checkout!';
  }

  List<ProductSimple> get _products {
    if (!widget.expandSkus) return widget.products.toList();
    return expandProductsWithSkus(widget.products.toList());
  }

  List<ProductSimple> expandProductsWithSkus(List<ProductSimple> products) {
    final expandedProducts = <ProductSimple>[];

    for (final product in products) {
      // If product has no SKUs, add the product as is
      if (product.skus == null || product.skus!.isEmpty) {
        expandedProducts.add(product);
        continue;
      }

      // Create a new product for each SKU
      for (final sku in product.skus!) {
        expandedProducts.add(
          ProductSimple(
            id: product.id,
            productId: product.productId,
            vendorId: product.vendorId,
            vendorName: product.vendorName,
            brandId: product.brandId,
            brandName: product.brandName,
            name: product.name,
            caption: product.caption,
            description: product.description,
            imageUrl: product.imageUrl,
            defaultSkuId: int.parse(sku.skuId), // Use current SKU ID as default
            skus: [sku], // Include only the current SKU
            isOutOfStock: product.isOutOfStock,
            price: sku.tieredPrice.toDouble(), // Use SKU's tiered price
            isActive: product.isActive,
            displayRetailPrice: sku.listPrice,
            displayPrice: sku.tieredPrice,
            productBrands: product.productBrands,
            categoryId: product.categoryId,
            categoryName: product.categoryName,
            featured: product.featured,
            featuredOrder: product.featuredOrder,
            isBestSeller: product.isBestSeller,
            bestSellerRank: product.bestSellerRank,
            createdAt: product.createdAt,
          ),
        );
      }
    }

    return expandedProducts;
  }

  // @override
  // void didUpdateWidget(covariant SelectMerzDialog oldWidget) {
  //   quantityMap = Map.fromEntries(widget.products.map((e) {
  //     final freeItem = widget.freeItems?.firstWhereOrNull((item) => item.productId == e.productId);
  //     return MapEntry(e.skus!.first.skuId, freeItem?.quantity ?? 0);
  //   }));
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 880,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
              child: Row(
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 19,
                      color: YLiftColor.orange,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.6,
                    ),
                  ),
                  const Spacer(),
                  const CloseIconButton(),
                ],
              ),
            ),
            Container(
              color: quantityLeft == 0 ? YLiftColor.green : YLiftColor.orange,
              width: double.infinity,
              height: 36,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                message,
                style: TextStyle(color: Colors.white, fontSize: 13.33),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 460,
              width: double.infinity,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 16,
                  children:
                      _products.map((product) {
                        final cartItem = widget.freeItems?.firstWhereOrNull(
                          (cartItem) =>
                              cartItem.productId == product.productId &&
                              product.skuIds.contains(cartItem.skuId),
                        );

                        final othersQuantity = quantityMap.entries.where((element) => element.key != product.skus!.first.skuId).fold(0, (previousValue, element) =>previousValue + element.value);
                        final setToMaxValue = widget.merzPromotion.freeBoxes - othersQuantity;

                        return _MixMaxProductTile(
                          product: product,
                          showSkuLabel: widget.expandSkus,
                          quantity: cartItem?.quantity,
                          maxQuantity: widget.maxQuantity,
                          quantityLeft: setToMaxValue,
                          canIncrease:
                              totalQuantity < widget.merzPromotion.freeBoxes,
                          onQuantityChanged: (sku, newQuantity) {
                            setState(() {
                              quantityMap[sku.skuId] = newQuantity;
                            });

                            widget.onProductQuantityChanged?.call(
                              sku,
                              newQuantity,
                            );
                          },
                          setToMax: (sku) {
                            // final newQuantity =
                            //     widget.merzPromotion.freeBoxes - totalQuantity;
                            // setState(() {
                            //   quantityMap[sku.skuId] = newQuantity;
                            // });
                            // widget.onProductQuantityChanged?.call(
                            //   product.skus!.first,
                            //   newQuantity,
                            // );
                          },
                        );
                      }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 32),
            OverflowBar(
              spacing: 32,
              children: [
                SizedBox(
                  width: 300,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Back To Cart'),
                  ),
                ),
                SizedBox(
                  width: 300,
                  height: 50,
                  child: RoundedFilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Done'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _MixMaxProductTile extends StatefulWidget {
  final ProductSimple product;
  final void Function(SkuSimple sku, int newQuantity) onQuantityChanged;
  final int? quantity;
  final int? maxQuantity;
  // final int quantityLeft;
  final bool canIncrease;

  final bool showSkuLabel;
  final int? skuId;

  final int quantityLeft;
  final void Function(SkuSimple sku)? setToMax;

  const _MixMaxProductTile({
    super.key,
    required this.product,
    required this.onQuantityChanged,
    this.quantity,
    this.showSkuLabel = false,
    this.skuId,
    this.maxQuantity,
    required this.canIncrease,
    required this.quantityLeft,
    this.setToMax,
  });

  @override
  State<_MixMaxProductTile> createState() => _MixMaxProductTileState();
}

class _MixMaxProductTileState extends State<_MixMaxProductTile> {
  SkuSimple? sku;
  int quantity = 0;

  void updateQuantity(int newQuantity) {
    if (sku == null) return;
    setState(() {
      quantity = newQuantity;
    });
    widget.onQuantityChanged(sku!, newQuantity);
  }

  void setToMax() {
    if (sku == null) return;
    setState(() {
      quantity = widget.quantityLeft;
    });
    widget.onQuantityChanged(sku!, widget.quantityLeft);
  }

  @override
  void initState() {
    if (widget.product.skus?.isNotEmpty ?? false) {
      sku = widget.product.skus?.first;
    }
    if (widget.quantity != null) {
      quantity = widget.quantity!;
    }
    if (widget.skuId != null) {
      sku = widget.product.skus?.firstWhereOrNull(
        (sku) => sku.skuId == widget.skuId.toString(),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Tooltip(
            message:
                widget.showSkuLabel && sku != null
                    ? '${widget.product.name}\n${sku!.attributeName ?? ''}'
                    : widget.product.name,
            waitDuration: const Duration(seconds: 1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    border: Border.all(color: YLiftColor.grey3),
                  ),
                  width: 150,
                  height: 150,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: ProductImageView(imageUrl: widget.product.imageUrl),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.product.name,
                  style: TextStyle(
                    fontSize: 13.33,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (widget.showSkuLabel &&
                    sku != null &&
                    sku!.attributeName != null)
                  Text(
                    sku!.attributeName!,
                    style: TextStyle(fontSize: 11.11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          if (widget.product.skus != null &&
              widget.product.skus!.length > 1 &&
              widget.skuId == null) ...[
            const SizedBox(height: 8),
            GalaxySKUDropdownMenu(
              withLabel: false,
              skus: widget.product.skus!,
              onSelected: (selectedSku) {
                setState(() {
                  sku = selectedSku;
                });
              },
            ),
          ],
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            // child: NewQuantityField(
            //   value: quantity,
            //   quantityMinimum: 0,
            //   quantityMaximum: widget.maxQuantity,
            //   quantityIncrement: 1,
            //   onChanged: updateQuantity,
            //   withDropdown: false,
            //   freeLeft: widget.quantityLeft,
            // ),
            child: SharedQuantityField(
              value: quantity,
              canIncrease: widget.canIncrease,
              onQuantityChanged: updateQuantity,
            ),
          ),
          if (widget.canIncrease && widget.setToMax != null) ...[
            const SizedBox(height: 2),
            GestureDetector(
              onTap: setToMax,
              child: const Text(
                'Set to Max',
                style: TextStyle(
                  fontSize: 11.11,
                  color: YLiftColor.orange,
                  decoration: TextDecoration.underline,
                  decorationColor: YLiftColor.orange,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
