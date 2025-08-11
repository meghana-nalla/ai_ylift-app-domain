import 'package:YLift/core/controllers/carts/index.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:galaxy_models/galaxy_models.dart';

import 'package:YLift/models/z-index_export.dart';
import 'package:YLift/presentation/pages/desktop/__primary_courses/components/simple_quantity_dropdown.dart';
import 'package:YLift/presentation/pages/desktop/__primary_courses/components/video_checkout/blue_rounded_button.dart';
import 'package:YLift/presentation/pages/desktop/__primary_courses/components/video_checkout/bottom_step_bar.dart';
import 'package:YLift/presentation/pages/desktop/__primary_courses/components/video_checkout/video_checkout_cost_breakdown.dart';
import 'package:YLift/presentation/pages/desktop/__primary_courses/components/video_checkout/video_product_list_view.dart';
import 'package:YLift/presentation/pages/desktop/cart/components/merz_promotion_dialog.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:get/get.dart';

class VideoProductItem {
  final int productId;
  final int skuId;
  final String name;
  final String skuAttributes;
  final String imageUrl;
  final int price;

  int quantity = 0;

  String get combinedId => '$productId-$skuId';

  VideoProductItem({
    required this.productId,
    required this.skuId,
    required this.name,
    required this.skuAttributes,
    required this.imageUrl,
    required this.price,
  });

  factory VideoProductItem.fromProduct(ProductSimple product, int skuId) {
    final sku = product.skus!.firstWhere((sku) => sku.skuId == '$skuId');
    return VideoProductItem(
      productId: product.productId!,
      skuId: int.parse(sku.skuId),
      name: product.name,
      skuAttributes: sku.attributeName ?? '',
      imageUrl: product.imageUrl,
      price: sku.tieredPrice,
    );
  }
}

class DynamicVideoCheckoutDialog extends StatefulWidget {
  final VirtualProduct product;

  const DynamicVideoCheckoutDialog({super.key, required this.product});

  @override
  State<DynamicVideoCheckoutDialog> createState() =>
      _DynamicVideoCheckoutDialogState();
}

class _DynamicVideoCheckoutDialogState
    extends State<DynamicVideoCheckoutDialog> {
  final global = Get.find<GlobalController>();

  AddressSimple? get shippingAddress => global.simpleCart.value.shippingAddress;
  CartSimple get cart => global.simpleCart.value;

  final products = <VideoProductItem>[];
  int get totalQuantity => products.fold(0, (sum, item) => sum + item.quantity);

  bool isAddingToCart = false;
  bool isSuccessful = false;
  String? errorMessage;

  void addToCart() async {
    try {
      setState(() {
        isAddingToCart = true;
      });

      // Step 1
      final profileId = global.user.value.profileId;
      final lastMinuteItems =
          products.map((e) {
            return LastMinuteItem(
              '${e.productId}-${e.skuId}',
              e.quantity,
            );
          }).toList();

      await global.basket.addVirtualItemToCart(
        virtualProductId: widget.product.id,
        lastMinuteItems: lastMinuteItems,
      );

      // Update the success state first to show feedback to the user
      setState(() {
        isSuccessful = true;
      });

      // Show success message with a short delay before navigating
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Course and products added to cart successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Refresh cart state to trigger UI updates in other parts of the app
      global.simpleCart.refresh();

      // Navigate to cart page after a short delay for better UX
      Future.delayed(Duration(milliseconds: 1000), () {
        global.vroute.navigateTo('/order/cart');
      });
    } catch (e) {
      errorMessage = '$e';
    } finally {
      setState(() {
        isAddingToCart = false;
      });
    }
  }

  void getPricesForItems() async {
    try {
      final requestItems =
          products
              .map(
                (element) => Item(
                  product: '${element.productId}-${element.skuId}',
                  quantity: element.quantity,
                ),
              )
              .toList();
      requestItems.removeWhere((item) => item.quantity <= 0);
      final request = BundleProductsPricesRequest(
        items: requestItems,
        addressId: shippingAddress?.addressId ?? '',
      );
      await global.products.getTradingProductsPrices(request);

      setState(() {});
    } catch (e, s) {
      print('$e\n$s');
    }
  }

  bool get allowNextStep => totalQuantity >= widget.product.requirementQuantity;

  @override
  void initState() {
    final productIds = widget.product.tradingMetadata!.products;
    final items =
        productIds.map((ids) {
          final product = global.allProducts.value.getById(ids.productId);
          return VideoProductItem.fromProduct(product!, ids.skuId);
        }).toList();
    products.addAll(items);
    super.initState();
    global.bundleProductPrices.value = BundleProductPrices();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: SizedBox(
        width: 1000,
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    'Unlock Your Course & Rewards',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.clear),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                padding: const EdgeInsets.all(16),
                child: CartVirtualItemTile(
                  imageUrl: widget.product.imageUrl,
                  name: widget.product.name,
                  doctorName: widget.product.description,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 360,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (products.length > 2)
                      Expanded(
                        child: VideoProductListView(
                          items: products,
                          onQuantityChanged: (item, newQuantity) {
                            final productIndex = products.indexWhere(
                              (product) =>
                                  product.combinedId == item.combinedId,
                            );
                            setState(() {
                              if (productIndex >= 0) {
                                products[productIndex].quantity = newQuantity;
                              }
                            });
                            getPricesForItems();
                          },
                        ),
                      )
                    else
                      ...products.map(
                        (product) {
                          return VideoCheckoutProductView(
                            name: product.name,
                            skuAttributes: product.skuAttributes,
                            imageUrl: product.imageUrl,
                            price: product.price.toCurrency(),
                            quantity: product.quantity,
                            onQuantityChanged: (quantity) {
                              setState(() {
                                product.quantity = quantity;
                              });
                              getPricesForItems();
                            },
                          );
                        },
                      ),
                    SizedBox(
                      width: 360,
                      child: VideoCheckoutCostBreakdown(
                        address: shippingAddress?.display,
                        subtotal: global.bundleProductPrices.value.subTotal,
                        tax: global.bundleProductPrices.value.totalTax,
                        shippingCost:
                            global.bundleProductPrices.value.totalShipping,
                        total: global.bundleProductPrices.value.total,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              if (errorMessage != null)
                Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.red, fontSize: 13.33),
                ),

              VideoCheckoutBottomBar(
                message:
                    'Add minimum of ${widget.product.requirementQuantity} items to unlock video course',
                actions: [
                  RoundedBlueButton(
                    label: 'Add to Cart',
                    onPressed:
                        allowNextStep && !isAddingToCart ? addToCart : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VideoCheckoutProductView extends StatelessWidget {
  final String name;
  final String? skuAttributes;
  final String imageUrl;
  final String price;

  final int quantity;
  final int maxQuantity;
  final void Function(int quantity) onQuantityChanged;

  final bool isReward;

  const VideoCheckoutProductView({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.skuAttributes,
    required this.quantity,
    this.maxQuantity = 200,
    required this.onQuantityChanged,
    this.isReward = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox.square(
            dimension: 240,
            child: Stack(
              children: [
                Image.network(imageUrl),
                if (isReward)
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.redeem_outlined,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
          if (skuAttributes != null)
            Text(
              skuAttributes!,
              style: TextStyle(fontSize: 13.33),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),

            child: Row(
              children: [
                const SizedBox(width: 12),
                Text(price, style: TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                Text(
                  'Quantity:',
                  style: TextStyle(
                    fontSize: 11.11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                SimpleQuantityDropdown(
                  value: quantity,
                  maxQuantity: maxQuantity,
                  onChanged: onQuantityChanged,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
