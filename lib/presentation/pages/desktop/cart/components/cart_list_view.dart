import 'dart:ui';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:YLift/presentation/pages/desktop/cart/components/product_radio_tile.dart';
import 'package:YLift/presentation/pages/desktop/cart/components/shipping_options.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:galaxy_models/galaxy_models.dart';


class CartListView extends StatelessWidget {
  final bool isAccessible;
  final AddressSimple? defaultShippingAddress;
  final Map<String, AddressSimple>? optionalAddresses;
  final void Function() update;

  CartListView({
    super.key,
    this.isAccessible = false,
    this.defaultShippingAddress,
    this.optionalAddresses,
    required this.update,
  });

  final GlobalController global = Get.find<GlobalController>();
  final NumberFormat currencyFormat = NumberFormat.currency(symbol: '\$');
  late List<bool> expandeds;
  late List<CartItemsByVendor> cartItemsByVendor;

  bool? get isSelectAll {
    final checks = global.simpleCart.value.cartItems.map((e) => e.moveToCheckOut);
    if (checks.every((checked) => checked)) {
      return true;
    } else if (checks.every((element) => !element)) {
      return false;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        cartItemsByVendor = groupCartItemsByVendor(global.simpleCart.value.cartItems);

        // TODO figure out how this is actually calculated
        expandeds = List.generate(cartItemsByVendor.length, (index) {
          return true;
        });

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (global.simpleCart.value.cartItems.isNotEmpty) ...[
              if (false) ...[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      tristate: true,
                      value: isSelectAll,
                      onChanged: (value) {
                        // TODO: Dany / Aiden this should check all or uncheck all
                      },
                    ),
                    Text('Select All'),
                  ],
                )
              ],
            ],
            const GapY(),
            global.simpleCart.value.products.isEmpty
                ? _buildEmptyCart()
                : IgnorePointer(
                    ignoring: !isAccessible,
                    child: Opacity(
                      opacity: isAccessible ? 1.0 : 0.4,
                      child: _buildCartList(cartItemsByVendor, context),
                    ),
                  ),
          ],
        );
      },
    );
  }

  /// functions for build cart list
  void _handleUpdateQuantity(CartItemSimple cartItem, int newQuantity) {
    final skuId = cartItem.skuId;
    final productId = cartItem.productId!;
    final product = '$productId-$skuId';
    final rules = global.simpleCart.value.tradeGoods.expand((tradeGood) => tradeGood.productIds).toList();
    int? getValueByKey(List<Map<String, int>> dataList, String keyToFind) {
      for (var map in dataList) {
        if (map.containsKey(keyToFind)) {
          return map[keyToFind];
        }
      }
      return null; // Return null if the key is not found in any map
    }

    final minimum = getValueByKey(rules, product);
    if (minimum != null && newQuantity < minimum) {
      print('cannot reduce minimum quantity of ${cartItem.productName}');
      return;
    }

    global.basket.updateCartItemQuantity(
      profileId: global.user.value.profileId.toString(),
      quantity: newQuantity,
      product: '${cartItem.productId}-${cartItem.skuId}',
    );
  }

  Future<void> _handleDelete(CartItemSimple cartItem, int index, int itemIndex) async {
    global.simpleCart.value.cartItems.removeAt(itemIndex);
    cartItemsByVendor[index].items.value = global.simpleCart.value.cartItems;
    await global.basket.deleteCartItem(profileId: global.user.value.profileId.toString(), productId: cartItem.combinedId);
  }

  Future<void> _handleCheckout(CartItemSimple cartItem, bool isChecked) async {
    await global.basket.toggleCheckOut(
      profileId: global.user.value.profileId.toString(),
      skuId: cartItem.sku.skuId,
      isChecked: isChecked,
    );
  }

  Future<void> _addItemBackToCart(CartItemSimple cartItem, int index) async {
    global.simpleCart.value.cartItems.add(cartItem);
    cartItemsByVendor[index].items.value = global.simpleCart.value.cartItems;
    await global.basket.addToCart(
        customerId: global.user.value.profileId.toString(),
        quantity: cartItem.quantity,
        product: "${cartItem.productId}-${cartItem.skuId}",
    );
  }

  Future<void> _handleSaveForLater(CartItemSimple cartItem, BuildContext context, int index, int itemIndex) async {
    await _handleDelete(cartItem, index, itemIndex);

    int? statusCode = await global.userProfile.saveProductForLater(
      '${cartItem.productId}-${cartItem.skuId}',
      cartItem.quantity,
    );

    if (statusCode == null || statusCode > 299) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error: could not save item for later.', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.redAccent,
      ));
      await _addItemBackToCart(cartItem, index);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item saved for later.')));
  }

  Widget _buildCartList(List<CartItemsByVendor> cartItemsByVendor, BuildContext context) {
    return Column(
      children: List.generate(
        cartItemsByVendor.length,
        (index) {
          final totalPrice = cartItemsByVendor[index].items.fold(0, (sum, item) => sum + (item.total * item.quantity));

          return Column(
            children: [
              GalaxyPanel(
                child: ExpansionTile(
                  onExpansionChanged: (expanded) {
                    expandeds[index] = expanded;
                  },
                  initiallyExpanded: true,
                  title: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cartItemsByVendor[index].vendorName ?? '',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Text(
                                'Products : ${cartItemsByVendor[index].items.length} | ',
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              Text(
                                'Total Tax: ${cartItemsByVendor[index].totalTax.toCurrency()} | ',
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              if(false) ...[
                                // hiding this for now.. till shipping service is completely ironed out (dany)
                                Text(
                                  'Total Shipping: ${global.simpleCart.value.shippingTotal.toCurrency()} | ',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                              Text(
                                'SubTotal: ${currencyFormat.format(cartItemsByVendor[index].totalCostOfVendor / 100)}',
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (expandeds.isNotEmpty && !expandeds[index]) ...[
                            const Text('Total', style: TextStyle(fontSize: 12)),
                            Text(
                              totalPrice.display(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  shape: const RoundedRectangleBorder(),
                  backgroundColor: Colors.white,
                  collapsedBackgroundColor: Colors.white,
                  leading: false
                      ? Radio(
                          value: 1,
                          groupValue: 1,
                          onChanged: (value) {},
                        )
                      : null,
                  // Existing configuration...
                  children: [
                    if (cartItemsByVendor[index].items.isNotEmpty) ...[
                      Column(
                        children: List.generate(
                          cartItemsByVendor[index].items.length,
                          (itemIndex) {
                            final cartItem = cartItemsByVendor[index].items[itemIndex];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (index == 0) ...[
                                  SizedBox(height: 10),
                                ],
                                CartItemTile(
                                  cartItem: cartItem,
                                  onUpdateQuantity: (int newQuantity) => _handleUpdateQuantity(cartItem, newQuantity),
                                  onDelete: () async => await _handleDelete(cartItem, index, itemIndex),
                                  isChecked: cartItem.moveToCheckOut,
                                  onCheck: (isChecked) async => await _handleCheckout(cartItem, isChecked),
                                  onSaveForLater: () async =>
                                      await _handleSaveForLater(cartItem, context, index, itemIndex),
                                ),
                                const SizedBox(height: 16),
                                if(cartItem.shippingSettings == null)
                                  Text('This item has an issue, please remove it from your cart or try changing the quantity of the item to see if the issue resolves.', style: TextStyle(color: YLiftColor.orange),)
                                else
                                  ShippingOptions(
                                    allowChangeAddress: false,
                                    sku: cartItem.sku,
                                    options: cartItem.shippingSettings,
                                    total: cartItem.shippingPrice,
                                    shippingType: cartItem.shippingType,
                                    address: optionalAddresses?[cartItem.shippingAddress] ??
                                        global.simpleCart.value.shippingAddress,
                                    update: update,
                                    onSelectedShippingType: (type) async {
                                      final cart = global.simpleCart.value;
                                      for(final item in cart.cartItems){
                                        if(cartItem.vendorId != item.vendorId) continue;
                                        final shippingAddress = cart.getCustomShippingAddress(item.shippingAddress);
                                        if(shippingAddress?.id != cart.shippingAddress?.id) continue;
                                        await global.basket.setCartShippingType(
                                          profileId: global.user.value.profileId.toString(),
                                          skuId: item.sku.skuId,
                                          type: type,
                                        );
                                      }
                                      // await global.basket.setCartShippingType(
                                      //   profileId: global.user.value.profileId.toString(),
                                      //   skuId: cartItem.sku.skuId,
                                      //   type: type,
                                      // );
                                    },
                                  ),
                                const SizedBox(height: 32),
                              ],
                            );
                          },
                        ),
                      ),
                    ] else ...[
                      const SizedBox(height: 25),
                      const Text('No items found in cart..', style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 25),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 15),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyCart() {
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
              global.vroute.navigateTo('/shop');
            },
            child: const Text('Continue Shopping'),
          ),
        ],
      ),
    );
  }
}

/// NEW CART BY BRAND

// model relating a brandName to a list of CartItemSimple objects
class CartItemsByVendor {
  final String vendorName;
  final RxList<CartItemSimple> items;
  int totalCostOfVendor = 0; // TODO Richie use this value for the total cost of the brand

  CartItemsByVendor({
    required this.vendorName,
    required this.items,
    required this.totalCostOfVendor,
  });

  int get totalShipping => items.map((element) => element.shippingPrice).fold(0, (value, element) => value + element);
  int get totalTax => items.map((element) => element.itemTaxTotalAsInteger).fold(0, (value, element) => value + element);
}

// function to extract a list of unique brands from the cartItems
List<String> getUniqueVendorNames(List<CartItemSimple> cartItems) {
  final Set<String> uniqueVendorNames = <String>{};

  for (CartItemSimple item in cartItems) {
    uniqueVendorNames.add(item.vendorName);
  }
  return uniqueVendorNames.toList();
}

// link brands to a list of items currently in the cart
RxList<CartItemsByVendor> groupCartItemsByVendor(List<CartItemSimple> cartItems) {
  List<CartItemsByVendor> itemsByVendor = [];

  List<String> vendorNames = getUniqueVendorNames(cartItems);

  for (String vendorName in vendorNames) {
    CartItemsByVendor vendorToItemsLink = CartItemsByVendor(
      vendorName: vendorName,
      items: <CartItemSimple>[].obs,
      totalCostOfVendor: 0,
    );

    for (CartItemSimple item in cartItems) {
      if (vendorName == item.vendorName) {
        vendorToItemsLink.items.add(item);
        vendorToItemsLink.totalCostOfVendor += item.total;
      }
    }

    itemsByVendor.add(vendorToItemsLink);
  }

  return RxList<CartItemsByVendor>.from(itemsByVendor);
}
