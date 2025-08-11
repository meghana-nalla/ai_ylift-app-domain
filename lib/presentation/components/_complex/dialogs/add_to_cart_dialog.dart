import 'dart:async';

import 'package:YLift/core/controllers/carts/cart_validator.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/models/_clean/product.dart';
import 'package:YLift/presentation/components/_complex/dialogs/error_tile.dart';
import 'package:YLift/presentation/components/_simple/product_image_view.dart';
import 'package:YLift/presentation/components/npi_required_text.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:YLift/presentation/pages/desktop/cart/components/merz_promotion_dialog.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:get/get.dart';
import '../dropdowns/sku_dropdown_menu.dart';
import 'package:galaxy_models/galaxy_models.dart';

class AddToCartDialog extends StatefulWidget {
  final ProductSimple product;
  final FutureOr<void> Function() onSeeProduct;
  final FutureOr<void> Function(SkuSimple sku, int quantity) onAddToCart;

  const AddToCartDialog({
    super.key,
    required this.product,
    required this.onSeeProduct,
    required this.onAddToCart,
  });

  @override
  State<AddToCartDialog> createState() => _AddToCartDialogState();
}

class _AddToCartDialogState extends State<AddToCartDialog> {
  SkuSimple? selectedSku;
  int quantity = 1;

  bool isAdding = false;
  String? errorMessage;

  bool get allowPurchase {
    return !isAdding && allowPeptidePurchase;
  }

  bool get allowPeptidePurchase {
    final medicalLicense = global.user.value.medicalLicense;
    final isPeptide = widget.product.categoryId?.contains(136) ?? false;
    if (isPeptide) {
      return medicalLicense?.npiNumber != null &&
          medicalLicense!.npiNumber!.isNotEmpty;
    } else {
      return true;
    }
  }

  // see if any variant sku of this product is in cart
  bool _isSkuInCart(SkuSimple sku) {
    final global = Get.find<GlobalController>();
    return global.simpleCart.value.cartItems.any(
      (item) => '${item.productId}-${item.skuId}' == '${sku.productId}-${sku.skuId}',
    );
  }

  void addToCart() async {
    if (selectedSku == null) return;
    try {
      setState(() {
        isAdding = true;
        errorMessage = null;
      });

      await widget.onAddToCart(selectedSku!, quantity);
      if (!mounted) return;
      print('Added to cart: ${selectedSku!.attributeName} x $quantity');

      Navigator.pop(context);
    } on CartItemError catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    } catch (e, s) {
      print('$e\n$s');
      setState(() {
        errorMessage = '$e';
      });
    } finally {
      setState(() {
        isAdding = false;
      });
    }
  }

  @override
  void initState() {
    if (widget.product.skus!.isNotEmpty) {
      selectedSku = widget.product.skus!.first;
      quantity = selectedSku!.quantityMinimum;
    }
    super.initState();
  }

  bool get hasPromotion =>
      MerzSyringePromotion.productIds.contains(widget.product.productId);

  @override
  Widget build(BuildContext context) {
    final global = Get.find<GlobalController>();
    final textTheme = Theme.of(context).textTheme;

    // Make the dialog reactive to cart changes
    return Obx(
      () => Dialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: SizedBox(
          height: 540,
          width: 960,
          child: Row(
            children: [
              // LEFT SIDE
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ProductImageView(
                        imageUrl: widget.product.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const Divider(height: 2),
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          widget.onSeeProduct();
                        },
                        child: const Center(
                          child: Text('SEE THE PRODUCT'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const VerticalDivider(width: 2),

              // RIGHT SIDE
              Expanded(
                flex: 5,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 24,
                              right: 24,
                              top: 24,
                              bottom: 16,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.product.name,
                                  style: textTheme.titleLarge,
                                ),
                                const SizedBox(height: 8),
                                StrikethroughPrice(
                                  firstValue: selectedSku!.listPrice ?? 0,
                                  secondValue: selectedSku!.tieredPrice,
                                ),
                                if (widget.product.hasActivePromotion &&
                                    widget.product.promotionMessage !=
                                        null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.product.promotionMessage!.trim(),
                                    style: TextStyle(
                                      fontSize: 13.33,
                                      color: YLiftColor.orange,
                                    ),
                                  ),
                                  // const SizedBox(height: 4),
                                  Text(
                                    widget.product.promotionMessageForCart!
                                        .trim(),
                                    style: TextStyle(
                                      fontSize: 13.33,
                                      color: YLiftColor.orange,
                                    ),
                                  ),
                                ],
                                const Divider(height: 32),
                                Expanded(
                                  child:
                                      hasPromotion
                                          ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // If promotions is not null
                                              const Text(
                                                'Promotions for this product:',
                                              ),
                                              Expanded(
                                                child: Image.network(
                                                  MerzSyringePromotion
                                                      .bannerImageUrl,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    flex: 3,
                                                    child:
                                                        GalaxySKUDropdownMenu(
                                                          isActive: true,
                                                          value: selectedSku,
                                                          skus:
                                                              widget
                                                                  .product
                                                                  .skus!,
                                                          onSelected: (sku) {
                                                            if (sku == null)
                                                              return;
                                                            setState(() {
                                                              selectedSku = sku;
                                                            });
                                                          },
                                                        ),
                                                  ),
                                                  const SizedBox(width: 16),
                                                  Expanded(
                                                    flex: 2,
                                                    child: QuantityDropdown(
                                                      isActive: true,
                                                      value: quantity,
                                                      incrementQty:
                                                          selectedSku
                                                              ?.quantityIncrement,
                                                      minQty:
                                                          selectedSku
                                                              ?.quantityMinimum,
                                                      maxQty:
                                                          selectedSku
                                                              ?.quantityMaximum,
                                                      onChanged: (newQuantity) {
                                                        setState(() {
                                                          quantity =
                                                              newQuantity;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                          : SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('Choose a variety:'),
                                                const SizedBox(height: 16),
                                                Wrap(
                                                  spacing: 16,
                                                  runSpacing: 16,
                                                  children:
                                                      widget.product.skus!.map(
                                                        (sku) {
                                                          final isSelected =
                                                              sku.attributeName ==
                                                              selectedSku
                                                                  ?.attributeName;
                                                          final bool isInCart =
                                                              _isSkuInCart(sku);
                                                          return GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                selectedSku =
                                                                    sku;
                                                              });
                                                            },
                                                            child: Stack(
                                                              children: [
                                                                Container(
                                                                  decoration: BoxDecoration(
                                                                    border:
                                                                        isSelected
                                                                            ? Border.all(
                                                                              width:
                                                                                  2,
                                                                              color:
                                                                                  isInCart
                                                                                      ? Colors.green
                                                                                      : Colors.black,
                                                                            )
                                                                            : Border.all(
                                                                              color:
                                                                                  isInCart
                                                                                      ? Colors.green
                                                                                      : YLiftColor.grey3,
                                                                            ),
                                                                  ),
                                                                  padding:
                                                                      const EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            16,
                                                                        vertical:
                                                                            8,
                                                                      ),
                                                                  child: Text(
                                                                    sku.attributeName ??
                                                                        widget
                                                                            .product
                                                                            .name,
                                                                    style: TextStyle(
                                                                      fontSize:
                                                                          13.33,
                                                                      color:
                                                                          isInCart
                                                                              ? Colors.green
                                                                              : null,
                                                                    ),
                                                                  ),
                                                                ),
                                                                if (isInCart)
                                                                  Positioned(
                                                                    right: 4,
                                                                    top: 4,
                                                                    child: Icon(
                                                                      Icons
                                                                          .check_circle,
                                                                      color:
                                                                          Colors
                                                                              .green,
                                                                      size: 14,
                                                                    ),
                                                                  ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      ).toList(),
                                                ),
                                                const SizedBox(height: 24),
                                                QuantityDropdown(
                                                  isActive: true,
                                                  value: quantity,
                                                  minQty:
                                                      selectedSku
                                                          ?.quantityMinimum,
                                                  incrementQty:
                                                      selectedSku
                                                          ?.quantityIncrement,
                                                  maxQty:
                                                      selectedSku
                                                          ?.quantityMaximum,
                                                  onChanged: (newQuantity) {
                                                    setState(() {
                                                      quantity = newQuantity;
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                ),
                                const SizedBox(height: 16),
                                if (!allowPeptidePurchase && global.isAuthenticated.value) ...const [
                                  NPIRequiredText(),
                                  SizedBox(height: 16),
                                ],
                                if (errorMessage != null) ...[
                                  ErrorTile(title: errorMessage),
                                  const SizedBox(height: 16),
                                ],
                                SizedBox(
                                  width: double.infinity,
                                  child:
                                      selectedSku != null &&
                                              _isSkuInCart(selectedSku!)
                                          ? OutlinedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              final global =
                                                  Get.find<GlobalController>();
                                              global.vroute.goToCartPage();
                                            },
                                            style: OutlinedButton.styleFrom(
                                              foregroundColor: Colors.green,
                                              side: BorderSide(
                                                color: Colors.green,
                                              ),
                                              padding: const EdgeInsets.all(16),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.check_circle,
                                                  color: Colors.green,
                                                  size: 16,
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  'ALREADY IN CART - VIEW CART',
                                                  style: TextStyle(
                                                    letterSpacing: 1.4,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                          : RoundedFilledButton(
                                            onPressed:
                                                allowPurchase ? addToCart : null,
                                            child: const Text(
                                              'ADD TO CART',
                                              style: TextStyle(
                                                letterSpacing: 1.4,
                                              ),
                                            ),
                                          ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // TextButton(
                          //   onPressed: () {
                          //     setState(() {
                          //       hasPromotion = !hasPromotion;
                          //     });
                          //   },
                          //   child: const Text('toggle promotion'),
                          // ),
                          const CloseIconButton(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StrikethroughPrice extends StatelessWidget {
  final int firstValue;

  /// The discounted price
  final int? secondValue;

  const StrikethroughPrice({
    super.key,
    required this.firstValue,
    this.secondValue,
  });

  @override
  Widget build(BuildContext context) {
    if (secondValue == null || secondValue == firstValue) {
      return Text(
        firstValue.toCurrency(),
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      );
    }
    return Row(
      children: [
        Text(
          secondValue!.toCurrency(),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 16),
        Text(
          firstValue.toCurrency(),
          style: TextStyle(
            decoration: TextDecoration.lineThrough,
          ),
        ),
      ],
    );
  }
}
