import 'package:YLift/core/constants/text_style.dart';
import 'package:YLift/core/controllers/z-index_export.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/presentation/components/z-index_export.dart' hide UnderlinedTextButton;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:galaxy_ui/galaxy_ui.dart';



class CartItemsPanel extends StatefulWidget {
  final List<CartItemSimple>? cartItems;
  final void Function() update;

  const CartItemsPanel({
    super.key,
    this.cartItems,
    required this.update,
  });

  @override
  State<CartItemsPanel> createState() => _CartItemsPanelState();
}

class _CartItemsPanelState extends State<CartItemsPanel> {
  late final List<bool> expandeds;

  @override
  void initState() {
    if (widget.cartItems != null) {
      expandeds = List.filled(widget.cartItems!.length, true);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Cart & Shipping Options', style: YLiftTextStyle.bodyLarge),
            const Spacer(),
            TextButton.icon(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Clear Cart'),
                        content: const Text('Do you want to clear all cart items?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              final global = Get.find<GlobalController>();
                              global.basket.clearCart(profileId: global.user.value.profileId.toString());
                            },
                            child: const Text('Clear'),
                          ),
                        ],
                      );
                    });
              },
              icon: const Icon(Icons.clear),
              label: const Text('Clear Cart'),
            ),
          ],
        ),
        const GapY(),
        if (widget.cartItems == null || widget.cartItems!.isEmpty)
          const _EmptyCart()
        else
          Column(
            children: List.generate(
              widget.cartItems!.length,
              (index) {
                final cartItem = widget.cartItems![index];
                return Column(
                  children: [
                    GalaxyPanel(
                      child: ExpansionTile(
                        onExpansionChanged: (expanded) {
                          setState(() {
                            expandeds[index] = expanded;
                          });
                        },
                        initiallyExpanded: true,
                        title: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(cartItem.brandName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                // Text('Items: ${controller.cart.value.shoppingItems[index].items?.length ?? 0}',
                                //     style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                            const Spacer(),
                            CurrencyText(cartItem.total),
                            Text(cartItem.total.display()),
                          ],
                        ),
                        shape: const RoundedRectangleBorder(),
                        backgroundColor: Colors.white,
                        collapsedBackgroundColor: Colors.white,
                        children: [
                          SizedBox(
                            height: 240,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    if (cartItem.imageUrl != null)
                                      Image.network(cartItem.imageUrl!)
                                    else
                                      SizedBox(
                                        height: 240.0,
                                        child: const Placeholder(),
                                      ),
                                    const GapX(),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(cartItem.productName),
                                        Text('SKU: ${cartItem.skuId}'),
                                        CartCounterStepper(
                                          currentValue: cartItem.quantity,
                                          quantityIncrement: 1,
                                          quantityMax: 200,
                                          quantityMin: 1,
                                        ),
                                        UnderlinedTextButton(
                                          text: 'Delete',
                                          onPressed: () async {
                                            final global = Get.find<GlobalController>();
                                            await global.basket.deleteCartItem(
                                              profileId: global.user.value.profileId.toString(),
                                              productId: cartItem.combinedId,
                                            );
                                            setState(() {});
                                            widget.update();
                                          },
                                        ),
                                      ],
                                    )
                                    // Image.network(cart)
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const GapY(),
                  ],
                );
              },
            ),
          ),
      ],
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey),
          const SizedBox(height: 20),
          const Text(
            'Your cart is empty',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF2C2C2C),
              minimumSize: const Size(200, 50),
            ),
            onPressed: () {
              final controller = Get.find<GlobalController>();
              controller.vroute.navigateTo('/shop');
            },
            child: const Text('Continue Shopping'),
          ),
        ],
      ),
    );
  }
}