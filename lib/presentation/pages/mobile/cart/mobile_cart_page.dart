import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/hardcodes/promotions/summer_glow_july_15/summer_glow_promotion.dart';
import 'package:YLift/models/simple/CartSimple.dart';
import 'package:YLift/models/simple/home_promotion_banner_data.dart';
import 'package:YLift/presentation/components/mobile_scaffold.dart';
import 'package:YLift/presentation/components/buttons/immediate_purchase_btn.dart';
import 'package:YLift/presentation/pages/desktop/cart/components/merz_promotion_dialog.dart';
import 'package:YLift/presentation/pages/mobile/cart/components/mobile_cart_item_tile.dart';
import 'package:YLift/presentation/pages/mobile/cart/components/mobile_virtual_item_tile.dart';
import 'package:YLift/presentation/pages/mobile/courses/delete_bundle_dialog.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:get/get.dart';

class CartItemsByVendor {
  final int vendorId;
  final String vendorName;
  final List<CartItemSimple> items;

  const CartItemsByVendor({
    required this.vendorId,
    required this.vendorName,
    required this.items,
  });
}

class MobileCartPage extends StatefulWidget {
  const MobileCartPage({super.key});

  @override
  State<MobileCartPage> createState() => _MobileCartPageState();
}

class _MobileCartPageState extends State<MobileCartPage> {
  final global = Get.find<GlobalController>();

  CartSimple get cart => global.simpleCart.value;

  List<CartItemsByVendor> get cartItemsByVendor {
    final cart = global.simpleCart.value;

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

  int get dissatisfiedOrderRules {
    return global.simpleCart.value.orderNotes.where((element) => !element.isSatisfied).length;
  }

  @override
  void initState() {
    fetchCart();
    super.initState();
  }

  void fetchCart() async {
    await global.basket.refreshCart();
    setState(() {});
  }

  bool get hasPromotions {
    final merzPromotion = MerzSyringePromotion.getPromotion(
      cart.merzTotalBoxes,
    );
   // final hasGaldermaPromotion = SummerGlowPromotion.isOngoing && SummerGlowPromotion.galdermaItems.isNotEmpty;
    return merzPromotion != null ;
  }

  bool get hasCardId {
    final userWallet = global.user.value.wallet ?? <CardPayment>[];
    final hasWalletCard = userWallet.isNotEmpty && userWallet.any((card) => card.isDefault == true && !card.isExpired);
    final hasCardId =
        global.simpleCart.value.paymentHistory?.any((history) => history.paymentStatus == 'PENDING') ?? false;
    return (hasCardId || hasWalletCard);
  }

  void removeVirtualProduct(VirtualItem item) async {
    final tradeGood = global.simpleCart.value.tradeGoods.firstWhereOrNull((
      tradeGood,
    ) {
      final ids = tradeGood.productIds.map((e) => e.keys).reduce((value, element) => value.toList() + element.toList());
      return ids.contains(item.virtualId);
    });
    if (tradeGood == null) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text('Unable to remove ${item.productName}'),
              content: const Text(
                'Please contact ${YLiftConstant.yliftEmail} or ${YLiftConstant.yliftPhoneNumber} for assistance.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
      );
      return;
    }
    showDialog(
      context: context,
      builder:
          (context) => MobileDeleteBundleDialog(
            tradeGoodId: tradeGood.goodsTradingId,
            title: tradeGood.goodsTradingName,
            cart: cart,
            skuNumber: tradeGood.goodsTradingId.substring(
              tradeGood.goodsTradingId.length - 5,
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MobileScaffold(
      title: 'Cart',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cart Items
            Column(
              spacing: 16,
              children: List.generate(
                cartItemsByVendor.length,
                (index) {
                  final vendorItems = cartItemsByVendor[index];
                  final items = vendorItems.items;

                  final vendorNote = cart.vendorOrderNotes.firstWhereOrNull(
                    (element) => element.knownId == vendorItems.vendorId,
                  );

                  final brandIds = global.brands
                      .where(
                        (element) => element.vendorIds.contains(vendorItems.vendorId),
                      )
                      .map((e) => e.brandId!);

                  final brandNotes =
                      cart.brandOrderNotes
                          .where(
                            (element) => brandIds.contains(element.knownId),
                          )
                          .toList();
                  final isSatisfied =
                      (vendorNote?.isSatisfied ?? true) && brandNotes.every((element) => element.isSatisfied);

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      border: isSatisfied ? null : Border.all(color: Colors.red, width: 2),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vendorItems.vendorName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        if (vendorNote != null)
                          for (final e in vendorNote.orderRules)
                            if (!e.isRuleSatisfied)
                              Text(
                                e.ruleMessage,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.red,
                                ),
                              ),
                        if (brandNotes.isNotEmpty)
                          for (final note in brandNotes)
                            for (final rule in note.orderRules)
                              if (!rule.isRuleSatisfied)
                                Text(
                                  rule.ruleMessage,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.red,
                                  ),
                                ),
                        const SizedBox(height: 8),
                        Column(
                          spacing: 16,
                          children: items
                              .map(
                                (item) {
                                  final productNote = cart.productOrderNotes.firstWhereOrNull(
                                    (element) => element.knownId == item.productId,
                                  );

                                  final data = MobileProductData.fromCartItem(
                                    item,
                                  );

                                  return MobileCartItemTile(
                                    item: data,
                                    onQuantityChanged: (value) async {
                                      await global.basket.updateCartItemQuantity(
                                        profileId: global.user.value.profileId.toString(),
                                        quantity: value,
                                        product: '${item.productId}-${item.sku.skuId}',
                                      );
                                      await global.basket.refreshCart();
                                      setState(() {});
                                    },
                                    onRemove: () async {
                                      await global.basket.deleteCartItem(
                                        profileId: global.user.value.profileId.toString(),
                                        productId: '${item.productId}-${item.sku.skuId}',
                                      );
                                      setState(() {});
                                    },
                                    message: productNote?.orderRules.firstOrNull?.ruleMessage,
                                  );
                                },
                              )
                              .toList(growable: false),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            if (cart.virtualItems.isNotEmpty)
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
                      children: cart.virtualItems
                          .map(
                            (e) => MobileVirtualItemTile(
                              item: e,
                              onRemove: () => removeVirtualProduct(e),
                            ),
                          )
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (dissatisfiedOrderRules > 0)
              Text(
                '$dissatisfiedOrderRules order rules are not satisfied',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red,
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Subtotal'),
                Text(
                  global.simpleCart.value.subTotal.toCurrency(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // immediate purchase button if cardId is available
            Obx(() {
              if (hasCardId && cart.cartItems.isNotEmpty && dissatisfiedOrderRules == 0) {
                return Column(
                  children: [
                    const ImmediatePurchaseButton(),
                    const SizedBox(height: 12),
                    Center(
                      child: Text(
                        'or',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),
            _proceedToPromotionsButton(),
          ],
        ),
      ),
    );
  }

  Widget _proceedToPromotionsButton() {
    return GalaxyFilledButton(
      backgroundColor: YLiftColor.orange,
      isExpanded: true,
      onPressed:
          hasPromotions
              ? () {
                global.vroute.navigateTo('/cart/promotions');
              }
              : () {
                global.vroute.navigateTo('/checkout');
              },
      child: hasPromotions ? const Text('Proceed to Promotions') : const Text('Checkout'),
    );
  }
}
