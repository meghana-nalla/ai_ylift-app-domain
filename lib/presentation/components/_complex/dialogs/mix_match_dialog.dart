
import 'package:YLift/models/_clean/product.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/models/simple/CartSimple.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/presentation/components/_complex/dropdowns/sku_dropdown_menu.dart';
import 'package:YLift/presentation/components/_simple/product_image_view.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:galaxy_models/galaxy_models.dart';

class MixMatchDialog extends StatelessWidget {
  final String title;
  final String groupName;
  final CartSimple? cart;
  final Iterable<ProductSimple> products;
  final int quantityLeft;
  final int? spendingLeft;
  final void Function(SkuSimple sku, int newQuantity)? onProductQuantityChanged;
  final bool expandSkus;

  final bool? isQualified;
  final String? description;
  final String? qualifiedMessage;

  const MixMatchDialog({
    super.key,
    required this.title,
    required this.groupName,
    this.cart,
    required this.products,
    // required this.quantityRequirements,
    this.onProductQuantityChanged,
    this.quantityLeft = 0,
    this.spendingLeft,
    this.expandSkus = false,
    this.isQualified,
    this.description,
    this.qualifiedMessage,
  });

  // int get totalQuantity {
  //   final productIds = products.map((product) => product.productId);
  //   final selectedCartItems = cart.cartItems.where((cartItem) => productIds.contains(cartItem.productId));
  //   return selectedCartItems.map((e) => e.quantity).fold(0, (previousValue, element) => previousValue + element);
  // }

  String get message {
    if (spendingLeft != null && spendingLeft! > 0)
      return 'Add ${spendingLeft!.toCurrency()} more of $groupName products to reach the minimum checkout amount';
    if (quantityLeft > 0)
      return 'Add $quantityLeft more of $groupName products to reach the minimum checkout quantity';
    return 'You are qualified for checkout!';
  }

  List<ProductSimple> get _products {
    if (!expandSkus) return products.toList();
    return expandProductsWithSkus(products.toList());
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
                    title,
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
            if(isQualified != null)
              Container(
                color:
                isQualified!
                    ? YLiftColor.green
                    : YLiftColor.orange,
                width: double.infinity,
                height: 36,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  isQualified! ? qualifiedMessage! : description!,
                  style: TextStyle(color: Colors.white, fontSize: 13.33),
                ),
              )
              else
            Container(
              color:
                  message.contains('qualified')
                      ? YLiftColor.green
                      : YLiftColor.orange,
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
                        final cartItem = cart?.cartItems.firstWhereOrNull(
                          (cartItem) =>
                              cartItem.productId == product.productId &&
                              product.skuIds.contains(cartItem.skuId),
                        );

                        return MixMaxProductTile(
                          cartItem: cartItem,
                          product: product,
                          showSkuLabel: expandSkus,
                          onQuantityChanged: (sku, newQuantity) {
                            onProductQuantityChanged?.call(sku, newQuantity);
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

class MixMaxProductTile extends StatefulWidget {
  final ProductSimple product;
  final void Function(SkuSimple sku, int newQuantity) onQuantityChanged;
  final CartItemSimple? cartItem;
  final bool showSkuLabel;

  final int? skuId;

  const MixMaxProductTile({
    super.key,
    required this.product,
    required this.onQuantityChanged,
    this.cartItem,
    this.showSkuLabel = false,
    this.skuId,
  });

  @override
  State<MixMaxProductTile> createState() => _MixMaxProductTileState();
}

class _MixMaxProductTileState extends State<MixMaxProductTile> {
  SkuSimple? sku;
  bool skuSelected = false;

  int quantity = 0;

  void updateQuantity(int newQuantity) {
    if (sku == null) return;
    setState(() {
      quantity = newQuantity;
    });
  }

  void addToCart() {
    widget.onQuantityChanged(sku!, quantity);
  }

  @override
  void initState() {
    if (widget.product.skus?.isNotEmpty ?? false) {
      sku = widget.product.skus?.first;
    }
    if (widget.cartItem != null) {
      quantity = widget.cartItem!.quantity;
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (sku != null)
                  Text(
                    sku!.tieredPrice.toCurrency(),
                    style: TextStyle(color: YLiftColor.orange),
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
                  skuSelected = true;
                });
              },
            ),
          ],
          if ((widget.product.skus!.length == 1) ||
              (widget.product.skus!.length > 1 && skuSelected)) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: QuantityDropdown(
                contentPadding: EdgeInsets.only(left: 24, right: 16),
                value: quantity,
                minQty: sku?.quantityMinimum,
                incrementQty: sku?.quantityIncrement,
                maxQty: sku?.quantityMaximum,
                onChanged: updateQuantity,
                withLabel: false,
                isDense: true,
              ),
            ),
          ],
          const SizedBox(height: 8),
          SizedBox(
            width: 150,
            height: 40,
            child: RoundedFilledButton(
              padding: EdgeInsets.zero,
              onPressed: () => addToCart(),
              child: const Text('Set Quantity'),
            ),
          ),
        ],
      ),
    );
  }
}
