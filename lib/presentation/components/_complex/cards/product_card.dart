import 'package:YLift/core/constants/color.dart';
import 'package:YLift/core/extensions/price_extension.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:YLift/presentation/components/_complex/dialogs/network_benefits_dialog.dart';
import 'package:YLift/presentation/components/_simple/lock_pricing_chip.dart';
import 'package:YLift/presentation/components/_simple/product_image_view.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:YLift/core/controllers/global.dart';



class ProductCard extends StatefulWidget {
  final ProductSimple product;
  final void Function()? onTap;
  final void Function()? onAddToCart;
  final void Function()? onLiked;
  final bool hidePrice;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onAddToCart,
    this.onLiked,
    this.hidePrice = false,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final controller = Get.find<GlobalController>();

  bool _isProductActive() {
    if (controller.isAuthenticated.isFalse) {
      return true;
    }
    if (widget.product.skus == null) {
      return false;
    }
    if (widget.product.skus!.isEmpty) {
      return false;
    }
    return widget.product.skus![0].tieredPrice > 0;
  }

  bool _isInCart() {
    if (controller.isAuthenticated.isFalse ||
        widget.product.productId == null) {
      return false;
    }

    // is product already in cart?
    return controller.simpleCart.value.cartItems.any(
      (item) => item.productId == widget.product.productId,
    );
  }

  Widget _getLabelText() {
    if (controller.isAuthenticated.isFalse) {
      return const Text('Log in to See Prices');
    }

    if (_isInCart()) {
      return const Text(
        'Already in Cart'
      );
    }

    return _isProductActive() ? Text('Add to Cart') : Text('Learn More');
  }

  void _handleButtonPress() {
    if (_isInCart()) {
      // nav to cart if product is already in cart
      controller.vroute.goToCartPage();
    } else if (!_isProductActive()) {
      UnlockPricingDialog.show(context, widget.product);
    } else {
      widget.onAddToCart!.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        width: controller.isMobile.isTrue ? 128 : 256,
        child:
            (widget.product.skus == null || widget.product.skus!.isEmpty)
                ? Center(
                  child: Text(
                    'Product ${widget.product.productId} has no skus',
                  ),
                )
                : ProductHover(
                  isActive: _isProductActive() || _isInCart(),
                  label: _getLabelText(),
                  onTap: _handleButtonPress,
                  child: Stack(
                    children: [
                      // Show "In Cart" badge if product is already in cart
                      Tooltip(
                        verticalOffset: -96,
                        message: widget.product.name,
                        waitDuration: const Duration(milliseconds: 500),
                        child: GestureDetector(
                          onTap: widget.onTap,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: ProductImageView(
                                    imageUrl: widget.product.imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  widget.product.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (widget.product.caption != null)
                                  Text(
                                    widget.product.caption!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 13.33,
                                      color: Color(0xFF343434),
                                    ),
                                  ),
                                if (widget.hidePrice ||
                                    widget.product.skus?.first.tieredPrice ==
                                        0) ...[
                                  const SizedBox(height: 8),
                                  LockPricingChip(
                                    vendorId: widget.product.vendorId,
                                  ),
                                ] else if (widget
                                            .product
                                            .skus
                                            ?.first
                                            .tieredPrice ==
                                        0 &&
                                    widget.product.skus?.first.listPrice ==
                                        0) ...[
                                  const SizedBox(height: 8),
                                  LockPricingChip(
                                    vendorId: widget.product.vendorId,
                                  ),
                                ] else if (widget
                                            .product
                                            .skus
                                            ?.first
                                            .tieredPrice !=
                                        null &&
                                    (widget.product.skus?.first.listPrice !=
                                            null &&
                                        widget.product.skus?.first.listPrice !=
                                            0) &&
                                    widget.product.skus?.first.listPrice !=
                                        widget
                                            .product
                                            .skus
                                            ?.first
                                            .tieredPrice) ...[
                                  const SizedBox(height: 4),
                                  Wrap(
                                    spacing: 16,
                                    children: [
                                      Text(
                                        widget.product.skus!.first.tieredPrice
                                            .toCurrency(),
                                        style: TextStyle(
                                          color: YLiftColor.orange,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      // const SizedBox(width: 16),
                                      if (widget
                                                  .product
                                                  .skus
                                                  ?.first
                                                  .listPrice !=
                                              null &&
                                          widget
                                                  .product
                                                  .skus
                                                  ?.first
                                                  .listPrice !=
                                              0)
                                        Text(
                                          widget.product.skus!.first.listPrice!
                                              .toCurrency(),
                                          style: TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            fontSize: 13.33,
                                            color: Colors.grey,
                                          ),
                                        ),
                                    ],
                                  ),
                                ] else if ((widget
                                            .product
                                            .skus
                                            ?.first
                                            .tieredPrice ??
                                        0) >
                                    0) ...[
                                  Text(
                                    (widget.product.skus?.first.tieredPrice ??
                                            0)
                                        .toCurrency(),
                                    style: TextStyle(fontSize: 13.33),
                                  ),
                                ] else
                                  LockPricingChip(
                                    vendorId: widget.product.vendorId,
                                  ),
                                if (widget.product.hasActivePromotion &&
                                    !widget.hidePrice)
                                  Text(
                                    widget.product.promotionMessage!,
                                    style: TextStyle(
                                      fontSize: 11.11,
                                      color: YLiftColor.orange,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (controller.isAuthenticated.isTrue &&
                          widget.product.skus != null &&
                          widget.product.skus!.first.listPrice != null &&
                          controller.isMobile.isFalse)
                        Positioned(
                          top: 16,
                          right: 16,
                          child: Obx(
                            () => FavoriteIcon(
                              isLiked:
                                  controller.user.value.likedProductsNotEmpty()
                                      ? controller.user.value.likedProducts!
                                          .contains(widget.product.productId)
                                      : false,
                              onTap: widget.onLiked,
                            ),
                          ),
                        ),

                      if (_isInCart())
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(4),
                                bottomLeft: Radius.circular(4),
                              ),
                            ),
                            child: Text(
                              'In Cart',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
      ),
    );
  }
}

class UnlockNetworkPricing extends StatelessWidget {
  final bool isGalderma;
  const UnlockNetworkPricing({super.key, this.isGalderma = false});

  @override
  Widget build(BuildContext context) {
    final global = Get.find<GlobalController>();

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap:
            (isGalderma)
                ? () {
                  if (global.isMobile.isTrue) return;
                  showDialog(
                    context: context,
                    builder: (context) {
                      return NetworkBenefitsDialog();
                    },
                  );
                }
                : () => global.vroute.navigateTo('/login'),
        child: Container(
          width: 165,
          decoration: const BoxDecoration(
            color: Color(0xFFF3F4F3),
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock, size: 12, color: Color(0xFFBBBBBB)),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  (isGalderma) ? 'Unlock Network Pricing' : 'Login for Pricing',
                  style: const TextStyle(fontSize: 11.11),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
