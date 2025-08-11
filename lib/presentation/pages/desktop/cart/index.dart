import 'package:YLift/core/constants/text_style.dart';
import 'package:YLift/core/controllers/galderma_promotion/index.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/hardcodes/promotions/evolysse/evolysse_promotion.dart';
import 'package:YLift/hardcodes/promotions/summer_glow_july_15/summer_glow_promotion.dart';
import 'package:YLift/hardcodes/promotions/summer_glow_july_15/summer_glow_promotion_side_panel.dart';
import 'package:YLift/hardcodes/promotions/summer_glow_july_15/vef_diffuser_promotion_side_panel.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:YLift/presentation/pages/desktop/cart/components/black_order_requirements/black_order_requirements_view.dart';
import 'package:YLift/hardcodes/promotions/evolysse/evolysse_side_panel.dart';
import 'package:YLift/presentation/pages/desktop/cart/components/merz_promotion_side_panel.dart';
import 'package:YLift/presentation/pages/desktop/cart/components/on_demand_trainings_section.dart';
import 'package:YLift/presentation/pages/desktop/cart/components/promotion_requirements_side_panel.dart';
import 'package:YLift/presentation/pages/desktop/cart/components/trade_goods_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'components/cart_list_view.dart';
import 'components/cart_summary/cart_summary.dart';
import 'components/shipping_address_tile.dart';

enum CartProcess { address, shipping }

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final global = Get.find<GlobalController>();
  final scrollController = ScrollController();

  bool isLoading = true;
  String? error;
  bool isCartAccessible = false;
  bool isCheckoutAccessible = false;

  AddressSimple? selectedAddress;

  Future<void> setCartUp() async {
    if (mounted) {
      await global.basket.refreshCart();
      setState(() {
        if (global.simpleCart.value.shippingAddress != null) {
          selectedAddress = global.simpleCart.value.shippingAddress;
        }
        isCartAccessible =
            global.simpleCart.value.cartItems.isNotEmpty &&
            (selectedAddress?.isValid ?? false);
        // isCheckoutAccessible = isCartAccessible && global.simpleCart.value.shippingAddress != null;
        isCheckoutAccessible = !global.simpleCart.value.hasRestrictions;
        isLoading = false;
      });
      // if (selectedAddress?.isValid == false) {
      //   showErrorSnackBar('Invalid address, please add or select another address');
      // }
    }
  }

  Future<void> setCartAddress(AddressSimple address) async {
    await global.basket.setCartAddress(
      profileId: global.user.value.profileId.toString(),
      addressId: address.addressId,
    );
    setState(() {
      selectedAddress = address;
    });
    await global.basket.refreshCart();
    global.basket.hasAdditionalAddresses.value = false;
    // if (selectedAddress?.isValid == false) {
    //   showErrorSnackBar('Invalid address, please add or select another address');
    // }
  }

  @override
  void initState() {
    super.initState();
    if (!global.isAuthenticated.value) {
      global.vroute.navigateTo('/login', redirectPath: '/order/cart');
    } else {
      setCartUp();
    }
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        content: Text(message, style: TextStyle(color: Colors.white)),
        dismissDirection: DismissDirection.up,
        action: SnackBarAction(
          label: 'Info',
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Shopping Cart'),
                  content: Text(message),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Close'),
                    ),
                  ],
                );
              },
            );
          },
        ),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 240,
          right: 20,
          left: 20,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GalaxyPageScaffold(
      scrollController: scrollController,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('My Cart', style: YLiftTextStyle.title),
              if (global.simpleCart.value.cartItems.isNotEmpty) ...[
                AnimatedRefreshButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await global.basket.refreshCart();
                    await setCartUp();
                  },
                ),
              ],
            ],
          ),
        ),
        const Divider(height: 50),
        LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 960;
            if (isCompact) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (global.simpleCart.value.cartItems.isNotEmpty) ...[
                      Text('Shipping address', style: YLiftTextStyle.bodyLarge),
                      const SizedBox(height: 25),
                      ShippingAddressTile(
                        address: selectedAddress,
                        onTap: () {
                          if (global.simpleCart.value.cartItems.isNotEmpty) {
                            showDialog(
                              context: context,
                              builder:
                                  (context) => SavedAddressesDialog(
                                    isFromProfile: true,
                                    update: () {
                                      setState(() {
                                        // isCartAccessible = controller.cart.value.checkout?.address != null;
                                      });
                                    },
                                    onSelectedAddress: (address) async {
                                      await setCartAddress(address);
                                      //await global.basket.refreshCart();
                                      await setCartUp();
                                      setState(() {
                                        isCheckoutAccessible = true;
                                      });
                                    },
                                    // onAddressCreated: onAddressCreated,
                                  ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'You must add an item to the cart to select an address.',
                                ),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 50),
                      Row(
                        children: [
                          Text(
                            'Cart & Shipping Options',
                            style: YLiftTextStyle.bodyLarge,
                          ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Clear Cart'),
                                    content: const Text(
                                      'Do you want to clear all cart items?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          setState(() {
                                            global.simpleCart.value.cartItems =
                                                [];
                                            isCheckoutAccessible = false;
                                            isCartAccessible = false;
                                          });
                                          await global.basket.clearCart(
                                            profileId:
                                                global.user.value.profileId
                                                    .toString(),
                                          );
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Clear'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.clear),
                            label: const Text('Clear Cart'),
                          ),
                        ],
                      ),
                    ],
                    if (global.simpleCart.value.tradeGoods.isNotEmpty)
                      TradeSkuSection(
                        tradeGoods: global.simpleCart.value.tradeGoods,
                      ),
                    CartListView(
                      isAccessible: isCartAccessible,
                      defaultShippingAddress:
                          global.simpleCart.value.shippingAddress,
                      optionalAddresses:
                          global.simpleCart.value.optionalAddress,
                      update: () {
                        print('update cart page');
                        setState(() {});
                      },
                    ),

                    SidePanel(
                      scrollController: scrollController,
                      isCartAccessible: isCartAccessible,
                      isCheckoutAccessible: isCheckoutAccessible,
                      isCompact: isCompact,
                    ),
                  ],
                ),
              );
            } else {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (global.simpleCart.value.cartItems.isNotEmpty) ...[
                          Text(
                            'Shipping address',
                            style: YLiftTextStyle.bodyLarge,
                          ),
                          const SizedBox(height: 25),
                          ShippingAddressTile(
                            address: selectedAddress,
                            onTap: () {
                              if (global
                                  .simpleCart
                                  .value
                                  .cartItems
                                  .isNotEmpty) {
                                showDialog(
                                  context: context,
                                  builder:
                                      (context) => SavedAddressesDialog(
                                        isFromProfile: true,
                                        update: () {
                                          setState(() {
                                            // isCartAccessible = controller.cart.value.checkout?.address != null;
                                          });
                                        },
                                        onSelectedAddress: (address) async {
                                          await setCartAddress(address);
                                          //await global.basket.refreshCart();
                                          await setCartUp();
                                          setState(() {
                                            isCheckoutAccessible = true;
                                          });
                                        },
                                        // onAddressCreated: onAddressCreated,
                                      ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'You must add an item to the cart to select an address.',
                                    ),
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 50),
                          Row(
                            children: [
                              Text(
                                'Cart & Shipping Options',
                                style: YLiftTextStyle.bodyLarge,
                              ),
                              const Spacer(),
                              TextButton.icon(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Clear Cart'),
                                        content: const Text(
                                          'Do you want to clear all cart items?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              setState(() {
                                                global
                                                    .simpleCart
                                                    .value
                                                    .cartItems = [];
                                                isCheckoutAccessible = false;
                                                isCartAccessible = false;
                                              });
                                              await global.basket.clearCart(
                                                profileId:
                                                    global.user.value.profileId
                                                        .toString(),
                                              );
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Clear'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.clear),
                                label: const Text('Clear Cart'),
                              ),
                            ],
                          ),
                        ],
                        if (global.simpleCart.value.tradeGoods.isNotEmpty) ...[
                          Obx(
                            () => TradeSkuSection(
                              tradeGoods: global.simpleCart.value.tradeGoods,
                            ),
                          ),
                        ],
                        CartListView(
                          isAccessible: isCartAccessible,
                          defaultShippingAddress:
                              global.simpleCart.value.shippingAddress,
                          optionalAddresses:
                              global.simpleCart.value.optionalAddress,
                          update: () {
                            print('update cart page');
                            setState(() {});
                          },
                        ),
                        if (global
                            .simpleCart
                            .value
                            .virtualItems
                            .isNotEmpty) ...[
                          Obx(
                            () => OnDemandTrainingsSection(
                              virtualItems:
                                  global.simpleCart.value.virtualItems,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 25),
                  SizedBox(
                    // flex: 1,
                    width: 320,
                    child: SidePanel(
                      scrollController: scrollController,
                      isCartAccessible: isCartAccessible,
                      isCheckoutAccessible: isCheckoutAccessible,
                      isCompact: isCompact,
                    ),
                  ),
                ],
              );
            }
          },
        ),
        const GapY(factor: 2),
      ],
    );
  }
}

class SidePanel extends StatefulWidget {
  final ScrollController? scrollController;
  final bool isCartAccessible;
  final bool isCheckoutAccessible;
  final bool isCompact;

  const SidePanel({
    super.key,
    this.scrollController,
    required this.isCartAccessible,
    required this.isCheckoutAccessible,
    this.isCompact = false,
  });

  @override
  State<SidePanel> createState() => _SidePanelState();
}

class _SidePanelState extends State<SidePanel> {
  final GlobalController controller = Get.find<GlobalController>();
  final galdermaController = Get.find<GaldermaController>();

  double height = 0.0;
  void scrollListener() {
    setState(() {
      height = widget.scrollController!.position.pixels - 100;
    });
  }

  @override
  void initState() {
    // enable this to allow sticky side panel
    // if (widget.scrollController != null) widget.scrollController!.addListener(scrollListener);
    super.initState();
  }

  List<CartItemSimple> get promotionsSideData {
    final cartItemsWithPromotion = controller.simpleCart.value.cartItems.where(
      (cartItem) => cartItem.promotion?.hasActivePromotion ?? false,
    );
    return cartItemsWithPromotion.toList();
  }

  bool hasEvolysseItems() {
    return controller.simpleCart.value.cartItems.any(
      (element) => element.brandId == EvolyssePromotion.evolysseBrandId,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isCompact) {
      return Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PromotionRequirementsSidePanel(
              cartItems: promotionsSideData,
              onQuantityUpdate: (sku, newQuantity) {
                controller.basket.updateCartItemQuantity(
                  profileId: controller.user.value.profileId.toString(),
                  quantity: newQuantity,
                  product: "${sku.productId}-${sku.skuId}",
                );
              },
            ),

            // if (DateTime.now().isBefore(
            //       SpringIntoRewardsPromotion.expirationDate,
            //     ) &&
            //     galdermaController.galdermaItems.isNotEmpty) ...[
            //   const SizedBox(height: 16),
            //   const SpringIntoRewardsSidePanel(),
            // ],
            if (DateTime.now().isBefore(EvolyssePromotion.expirationDate) &&
                hasEvolysseItems()) ...[
              const SizedBox(height: 16),
              const EvolysseSidePanel(),
            ],

            if (global.simpleCart.value.merzItems.isNotEmpty) ...[
              const SizedBox(height: 16),
              MerzPromotionSidePanel(),
            ],
            if (global.simpleCart.value.hasRestrictions) ...[
              const SizedBox(height: 16),

              Obx(() {
                return BlackOrderRequirementsView(
                  orderNotes: global.simpleCart.value.orderNotes,
                );
              }),
            ],

            const SizedBox(height: 16),
            CartSummary(
              // scrollController: scrollController,
              isCartAccessible: widget.isCartAccessible,
              isCheckoutAccessible: global.simpleCart.value.isCheckoutable,
            ),
          ],
        );
      });
    } else {
      return Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height < 0 ? 0 : height),
            CartSummary(
              // scrollController: scrollController,
              isCartAccessible: widget.isCartAccessible,
              isCheckoutAccessible: global.simpleCart.value.isCheckoutable,
            ),
            const SizedBox(height: 16),
            if (global.simpleCart.value.hasRestrictions)
              Obx(() {
                return BlackOrderRequirementsView(
                  orderNotes: global.simpleCart.value.orderNotes,
                );
              }),
            // const SizedBox(height: 16),
            // if (global.simpleCart.value.hasRestrictions)
            //   Obx(() {
            //     return OrderRequirements(
            //       vendorNotes: global.simpleCart.value.vendorOrderNotes,
            //       brandNotes: global.simpleCart.value.brandOrderNotes,
            //       productNotes: global.simpleCart.value.productOrderNotes,
            //       skuNotes: global.simpleCart.value.skuOrderNotes,
            //       merzPromotion: global.simpleCart.value.merzPromotion,
            //     );
            //   }),
            const SizedBox(height: 16),
            PromotionRequirementsSidePanel(
              cartItems: promotionsSideData,
              onQuantityUpdate: (sku, newQuantity) {
                controller.basket.updateCartItemQuantity(
                  profileId: controller.user.value.profileId.toString(),
                  quantity: newQuantity,
                  product: "${sku.productId}-${sku.skuId}",
                );
              },
            ),

            // if (galdermaController.galdermaItems.isNotEmpty) ...[
            //   const SizedBox(height: 16),
            //   GaldermaPromotionSidePanel(),
            // ],
            // if (DateTime.now().isBefore(
            //       SpringIntoRewardsPromotion.expirationDate,
            //     ) &&
            //     galdermaController.galdermaItems.isNotEmpty) ...[
            //   const SizedBox(height: 16),
            //   const SpringIntoRewardsSidePanel(),
            // ],
            // if (DateTime.now().isBefore(EvolyssePromotion.expirationDate) &&
            //     hasEvolysseItems()) ...[
            //   const SizedBox(height: 16),
            //   const EvolysseSidePanel(),
            // ],
            // if (RestylanePromotionData.isOngoing &&
            //     RestylanePromotionData.restylaneItems.isNotEmpty) ...[
            //   const SizedBox(height: 16),
            //   const RestylanePromotionSidePanel(),
            // ],
            //
            // if (SculptraPromotionData.isOngoing &&
            //     SculptraPromotionData.sculptraItems.isNotEmpty) ...[
            //   const SizedBox(height: 16),
            //   const SculptraPromotionSidePanel(),
            // ],
            //
            // if (DysportPromotionData.isOngoing &&
            //     DysportPromotionData.dysportItems.isNotEmpty) ...[
            //   const SizedBox(height: 16),
            //   const DysportPromotionSidePanel(),
            // ],

            // if (SummerGlowPromotion.isOngoing &&
            //     SummerGlowPromotion.galdermaItems.isNotEmpty) ...[
            //   const SizedBox(height: 16),
            //   const SummerGlowPromotionSidePanel(),
            // ],
            //
            // if (SummerGlowPromotion.isOngoing &&
            //     SummerGlowPromotion.galdermaItems.isNotEmpty) ...[
            //   const SizedBox(height: 16),
            //   const VEFDiffuserPromotionSidePanel(),
            // ],

            if (global.simpleCart.value.merzItems.isNotEmpty) ...[
              const SizedBox(height: 16),
              MerzPromotionSidePanel(),
            ],
          ],
        );
      });
    }
  }
}
