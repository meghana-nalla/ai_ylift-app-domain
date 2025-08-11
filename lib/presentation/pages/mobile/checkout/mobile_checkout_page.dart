import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/hardcodes/promotions/summer_glow_july_15/summer_glow_promotion.dart';
import 'package:YLift/presentation/components/buttons/line_text_button.dart';
import 'package:YLift/presentation/components/dialogs/mobile_dialog.dart';
import 'package:YLift/presentation/components/mobile_panel.dart';
import 'package:YLift/presentation/components/mobile_scaffold.dart';
import 'package:YLift/presentation/pages/mobile/cart/components/mobile_virtual_item_tile.dart';
import 'package:YLift/presentation/pages/mobile/cart/mobile_cart_page.dart';
import 'package:YLift/presentation/pages/mobile/cart/mobile_select_address_page.dart';
import 'package:YLift/presentation/pages/mobile/checkout/components/payment_method_panel.dart';
import 'package:YLift/presentation/pages/mobile/checkout/components/store_credit_panel.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_models/galaxy_models.dart' hide VirtualItem;
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:get/get.dart';

class MobileCheckoutPage extends StatefulWidget {
  const MobileCheckoutPage({super.key});

  @override
  State<MobileCheckoutPage> createState() => _MobileCheckoutPageState();
}

class _MobileCheckoutPageState extends State<MobileCheckoutPage> {
  final global = Get.find<GlobalController>();

  List<CartItemsByVendor> get cartItemsByVendor {
    final cart = global.simpleCart.value;
    if (cart.cartItems.isEmpty) return [];

    final cartItemsByVendor = <CartItemsByVendor>[];
    for (final cartItem in cart.cartItems) {
      if (cartItemsByVendor.any((e) => e.vendorId == cartItem.vendorId)) {
        final index = cartItemsByVendor.indexWhere(
          (e) => e.vendorId == cartItem.vendorId,
        );
        cartItemsByVendor[index].items.add(cartItem);
      } else {
        cartItemsByVendor.add(
          CartItemsByVendor(
            vendorId: cartItem.vendorId,
            vendorName: cartItem.vendorName,
            items: [cartItem],
          ),
        );
      }
    }
    return cartItemsByVendor;
  }

  CardPayment? cardPayment;
  void selectCardPayment(CardPayment value) {
    setState(() {
      cardPayment = value;
    });
    debugPrint(
      'User selected card: ${value.id} - ${value.cardType} ${value.last4}',
    );
  }

  int? storeCreditBalance;
  bool get useStoreCredit =>
      storeCreditBalance != null && storeCreditBalance! > 0;
  void setStoreCredit(int? value) {
    setState(() {
      storeCreditBalance = value;
    });
    debugPrint('User selected use store credit: $value');
  }

  bool get isCheckoutable {
    final cart = global.simpleCart.value;
    return cart.isCheckoutable && cart.cartItems.isNotEmpty;
  }

  bool isPlacingOrder = false;
  String? errorMessage;

  bool get canPlaceOrder {
    return isCheckoutable &&
        cardPayment != null &&
        !isPlacingOrder &&
        (cardPayment?.isExpired ?? false) == false;
  }

  Future<void> _applyStoreCreditAutomatically() async {
    final global = Get.find<GlobalController>();
    final balance = await global.userController.getStoreCreditBalance();

    if (balance != null && balance > 0) {
      setState(() {
        // Convert to cents if needed
        storeCreditBalance = balance * 100;
      });
    }
  }


  @override
  void initState() {
    final defaultCard = global.user.value.wallet?.firstWhereOrNull(
      (e) => e.isDefault,
    );
    cardPayment = defaultCard ?? global.user.value.wallet?.firstOrNull;
    _applyStoreCreditAutomatically();
    super.initState();
  }

  void placeOrder() async {
    if (cardPayment == null) {
      setState(() {
        errorMessage = 'Please select a payment method.';
      });
      return;
    }

    try {
      setState(() {
        isPlacingOrder = true;
        errorMessage = null;
      });

      final order = await global.basket.createOrder(cardId: cardPayment!.id);

      debugPrint('Navigating to MobileOrderConfirmationPage');
      await global.vroute.navigateTo('/order/confirm?orderId=${order.orderId}');
      // if (SummerGlowPromotion.isEligibleForVEFDiffuser) {
      //   await global.galdermaController.setReward('Venus et Fleur');
      //   debugPrint('User is eligible for Venus et Fleur Diffuser');
      // }
      // final profileId = global.user.value.profileId;
      //
      // final response = await global.basket.createOrder(
      //   profileId: profileId,
      //   cardId: cardPayment!.id,
      // );
      // if (response.isSuccess) {
      //   final data = response.data?['cart'];
      //   final order = OrderSimple.fromJson(data);
      //   await global.blowOutCarts();
      //   await global.auth.performRefreshToken();
      //   await global.vroute.navigateTo(
      //     '/order/confirm?orderId=${order.orderId}',
      //   );
      // } else {
      //   if (!mounted) return;
      //   showPlaceOrderErrorDialog(response.errorMessage);
      //   await global.galdermaController.setReward('');
      // }
    } catch (e, s) {
      if (!mounted) return;
      showPlaceOrderErrorDialog('$e');
    } finally {
      setState(() {
        isPlacingOrder = false;
      });
    }
  }

  int get orderTotal {
    var total = global.simpleCart.value.orderTotal -
        (global.simpleCart.value.discountTotal ?? 0);
    if (useStoreCredit) total -= storeCreditBalance ?? 0;
    return total;
  }

  void showPlaceOrderErrorDialog([String? errorMessage]) {
    showDialog(
      context: context,
      builder:
          (context) => MobileDialog(
            title: Text('Failed to Place Order'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Something went wrong while placing your order, please try again later.\n'
                  'If the problem persists, please contact ${YLiftConstant.yliftPhoneNumber} or ${YLiftConstant.yliftEmail}',
                  style: TextStyle(fontSize: 14),
                ),
                if (errorMessage != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    errorMessage,
                    style: TextStyle(fontSize: 12, color: YLiftColor.orange),
                  ),
                ],
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MobileScaffold(
      title: 'Checkout',
      onBackPressed:
          isPlacingOrder
              ? null
              : () {
                global.vroute.navigateTo('/cart');
              },
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MobilePaymentMethodPanel(
              cardPayment: cardPayment,
              cards: global.user.value.wallet ?? <CardPayment>[],
              onCardChanged: selectCardPayment,
            ),
            MobileStoreCreditPanel(
              useStoreCredit: useStoreCredit,
              onChanged: setStoreCredit,
            ),
            const SizedBox(height: 16),
            MobilePanel(
              children: [
                if (global.simpleCart.value.shippingAddress != null) ...[
                  Text(
                    'Delivering to ${global.simpleCart.value.shippingAddress!.name}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    global.simpleCart.value.shippingAddress!.display,
                    style: TextStyle(fontSize: 12),
                  ),
                ] else
                  Text(
                    'Select a shipping address',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                const SizedBox(height: 4),
                LineTextButton(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MobileSelectAddressPage(),
                      ),
                    );
                  },
                  text: 'Change address',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              spacing: 16,
              children: cartItemsByVendor
                  .map((e) {
                    return Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        color: Colors.white,
                      ),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                e.vendorName,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Shipping Options',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (e.items.first.shippingSettings != null)
                            MobileShippingOptions(
                              type: e.items.first.shippingType,
                              shippingSettings: e.items.first.shippingSettings!,
                              onSelected: (type) async {
                                for (final item in e.items) {
                                  if (item.shippingSettings == null) {
                                    continue;
                                  }
                                  await global.basket.setCartShippingType(
                                    profileId:
                                        global.user.value.profileId.toString(),
                                    skuId: item.sku.skuId,
                                    type: type,
                                  );
                                }
                              },
                            ),
                          const Divider(
                            height: 32,
                            color: YLiftColor.grey3,
                          ),
                          Column(
                            spacing: 24,
                            children: e.items
                                .map((item) {
                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox.square(
                                        dimension: 64,
                                        child: Image.network(
                                          item.imageUrl!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.productName,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              item.sku.attributeName ?? '',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Color(
                                                  0xFF343434,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            IntrinsicHeight(
                                              child: Row(
                                                children: [
                                                  Text(
                                                    item.total.toCurrency(),
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    'Quantity: ${item.quantity}',
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  const VerticalDivider(
                                                    color: Colors.black,
                                                    indent: 4,
                                                    endIndent: 4,
                                                  ),
                                                  LineTextButton(
                                                    onPressed: () {
                                                      global.vroute.navigateTo(
                                                        '/cart',
                                                      );
                                                    },
                                                    text: 'Back to edit',
                                                    textColor: Colors.black,
                                                    isUnderlined: true,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                })
                                .toList(growable: false),
                          ),
                        ],
                      ),
                    );
                  })
                  .toList(growable: false),
            ),
            const SizedBox(height: 16),
            if (global.simpleCart.value.virtualItems.isNotEmpty)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Video / Training Bundle',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      spacing: 16,
                      children: global.simpleCart.value.virtualItems
                          .map((e) => MobileVirtualItemTile(item: e))
                          .toList(growable: false),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      bottomBar: MobileBar(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CostRow(
              'Subtotal',
              global.simpleCart.value.subTotal,
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            CostRow(
              'Tax',
              global.simpleCart.value.taxTotalAsInteger,
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            CostRow(
              'Shipping',
              global.simpleCart.value.shippingTotal,
              style: TextStyle(fontSize: 14),
            ),
            if (useStoreCredit) ...[
              const SizedBox(height: 8),
              CostRow(
                'Store Credit',
                -storeCreditBalance!,
                style: TextStyle(fontSize: 14, color: Colors.green),
              ),
            ],

            const SizedBox(height: 8),
            CostRow(
              'Order Total',
              orderTotal,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            GalaxyFilledButton(
              isExpanded: true,
              backgroundColor: YLiftColor.orange,
              onPressed: canPlaceOrder ? placeOrder : null,
              child: const Text('Place Your Order'),
            ),
          ],
        ),
      ),
    );
  }
}

class MobileShippingOptions extends StatelessWidget {
  final ShippingType type;
  final ShippingSettingsSimple shippingSettings;
  final void Function(ShippingType value) onSelected;

  const MobileShippingOptions({
    super.key,
    required this.type,
    required this.shippingSettings,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (shippingSettings.isFree) {
      return _buildOption('Free Shipping', null, true);
    }
    if (shippingSettings.isFlatRate) {
      return _buildOption('Flat Rate', shippingSettings.regularRate, true);
    }
    return Column(
      spacing: 8,
      children: [
        GestureDetector(
          onTap: () => onSelected(ShippingType.regular),
          child: _buildOption(
            'Regular Ground',
            shippingSettings.regularRate,
            type == ShippingType.regular,
          ),
        ),
        GestureDetector(
          onTap: () => onSelected(ShippingType.express),
          child: _buildOption(
            'Express 2-Days',
            shippingSettings.expressRate,
            type == ShippingType.express,
          ),
        ),
        GestureDetector(
          onTap: () => onSelected(ShippingType.overnight),
          child: _buildOption(
            'Overnight',
            shippingSettings.overnightRate,
            type == ShippingType.overnight,
          ),
        ),
      ],
    );
  }

  Widget _buildOption(
    String title,
    int? rate,
    bool isSelected,
  ) {
    if (rate != null && rate == 0) {
      return const SizedBox.shrink();
    }
    return Row(
      children: [
        Icon(
          isSelected
              ? Icons.radio_button_checked
              : Icons.radio_button_unchecked,
          size: 16,
          color: isSelected ? YLiftColor.orange : const Color(0xFF787878),
        ),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: const Color(0xFF343434),
            fontWeight: isSelected ? FontWeight.bold : null,
          ),
        ),
        if (rate != null) ...[
          const Spacer(),
          Text(
            rate.toCurrency(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : null,
            ),
          ),
        ],
      ],
    );
  }
}
