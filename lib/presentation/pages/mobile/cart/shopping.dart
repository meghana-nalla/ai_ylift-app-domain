import 'package:YLift/hardcodes/promotions/dysport_promotion_june_9/dysport_promotion_side_panel.dart';
import 'package:YLift/hardcodes/promotions/evolysse/evolysse_side_panel.dart';
import 'package:YLift/hardcodes/promotions/restylane_promotion_june_9/restylane_promotion_side_panel.dart';
import 'package:YLift/hardcodes/promotions/sculptra_promotion_june_9/sculptra_promotion_side_panel.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:YLift/presentation/components/_complex/dialogs/saved_address_dialog_mobile.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:YLift/presentation/pages/desktop/cart/components/mobile_address_tile.dart';
import 'package:YLift/presentation/pages/mobile/cart/components/mobile_cart_item_tile.dart';
import 'package:YLift/presentation/pages/mobile/cart/components/mobile_shipping_options.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:YLift/core/controllers/global.dart';

import 'dart:async';
import 'package:YLift/core/constants/index.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import '../cart/components/mobile_order_requirements.dart';
import 'package:YLift/presentation/pages/desktop/cart/components/black_order_requirements/black_order_requirements_view.dart';
import 'package:YLift/presentation/pages/desktop/cart/components/merz_promotion_side_panel.dart';
import 'package:YLift/presentation/pages/desktop/cart/components/on_demand_trainings_section.dart';
import 'package:YLift/presentation/pages/desktop/cart/components/promotion_requirements_side_panel.dart';
import 'package:YLift/hardcodes/promotions/dysport_promotion_june_9/dysport_promotion.dart';
import 'package:YLift/hardcodes/promotions/evolysse/evolysse_promotion.dart';
import 'package:YLift/hardcodes/promotions/restylane_promotion_june_9/restylane_promotion.dart';
import 'package:YLift/hardcodes/promotions/sculptra_promotion_june_9/sculptra_promotion.dart';

class ShoppingReviewCartScreen extends StatefulWidget {
  final VoidCallback onCheckout;

  const ShoppingReviewCartScreen({super.key, required this.onCheckout});

  @override
  _ShoppingReviewCartScreenState createState() =>
      _ShoppingReviewCartScreenState();
}

class _ShoppingReviewCartScreenState extends State<ShoppingReviewCartScreen> {
  final GlobalController global = Get.find<GlobalController>();
  final NumberFormat currencyFormat = NumberFormat.currency(symbol: '\$');
  final ScrollController _scrollController = ScrollController();

  bool isLoading = false;

  List<CartItemsByVendor> cartItemsByVendor = [];
  bool _showSections = true;
  double _lastScrollPosition = 0;
  Timer? _debounceTimer;

  Map<String, bool> expandedBrands = {};

  void loadData() async {
    await global.basket.refreshCart();
    _scrollController.addListener(_scrollListener);
    cartItemsByVendor = groupCartItemsByVendor(
      global.simpleCart.value.cartItems,
    );
    // Initialize expandedBrands map
    for (var item in global.simpleCart.value.cartItems) {
      expandedBrands[item.brandName] = true;
    }
  }

  void _onDelete(CartItemSimple item, CartItemsByVendor shop) async {
    setState(() => isLoading = true);
    await global.basket.deleteCartItem(
      productId: item.combinedId,
      profileId: global.user.value.profileId.toString(),
    );
    setState(() {
      cartItemsByVendor = groupCartItemsByVendor(
        global.simpleCart.value.cartItems,
      );
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _scrollListener() {
    final currentPosition = _scrollController.position.pixels;
    if ((currentPosition - _lastScrollPosition).abs() > 10) {
      setState(() {
        if (currentPosition > 0) {
          _showSections = currentPosition < _lastScrollPosition;
        } else {
          _showSections = true;
        }
      });
      _lastScrollPosition = currentPosition;
    }
  }

  void _toggleBrandExpansion(String brand) {
    setState(() {
      expandedBrands[brand] = !(expandedBrands[brand] ?? true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child:
            global.simpleCart.value.cartItems.isEmpty
                ? _buildEmptyCart()
                : _buildCartView(),
      ),
    );
  }

  Widget _buildCartView() {
    if (isLoading) return Center(child: CircularProgressIndicator());
    return Stack(
      children: [
        CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(height: 16),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Shipping Address',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    MobileAddressTile(
                      address: global.simpleCart.value.shippingAddress,
                      onTap: () {
                        if (global.simpleCart.value.cartItems.isNotEmpty) {
                          showDialog(
                            context: context,
                            builder:
                                (context) => SavedAddressesDialogMobile(
                                  update: () {},
                                  onSelectedAddress: (address) async {
                                    await global.basket.setCartAddress(
                                      profileId:
                                          global.user.value.profileId
                                              .toString(),
                                      addressId: address.addressId,
                                    );
                                    await global.basket.refreshCart();
                                    global.basket.hasAdditionalAddresses.value =
                                        false;
                                  },
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

                    // ShippingAddressTile(
                    //   padding: EdgeInsets.zero,
                    //   address: global.simpleCart.value.shippingAddress,
                    //   onTap: () {
                    //     if (global.simpleCart.value.cartItems.isNotEmpty) {
                    //       showDialog(
                    //         context: context,
                    //         builder: (context) => SavedAddressesDialogMobile(
                    //           update: () {},
                    //           onSelectedAddress: (address) async {
                    //             await global.basket.setCartAddress(
                    //                 profileId: global.user.value.profileId.toString(), addressId: address.addressId);
                    //             await global.basket.refreshCart();
                    //             global.basket.hasAdditionalAddresses.value = false;
                    //           },
                    //         ),
                    //       );
                    //     } else {
                    //       ScaffoldMessenger.of(context).showSnackBar(
                    //         const SnackBar(
                    //           content: Text('You must add an item to the cart to select an address.'),
                    //           duration: Duration(seconds: 3),
                    //         ),
                    //       );
                    //     }
                    //   },
                    // ),
                  ],
                ),
              ), // top section
            ),
            // SliverToBoxAdapter(
            //   child: Column(
            //     children: [
            //       Text('Shipping Address'),
            //       // Text(global.simpleCart.value.shippingAddress),
            //     ],
            //   ),
            // ),
            // SliverList(
            //   delegate: SliverChildBuilderDelegate(
            //     (context, index) {
            //       return _buildBrandGroup(cartItemsByVendor[index]);
            //     },
            //     childCount: cartItemsByVendor.length,
            //   ),
            // ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildBrandGroup(cartItemsByVendor[index]);
                },
                childCount: cartItemsByVendor.length,
              ),
            ),

            SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildContinueShoppingSection(),
                  const SizedBox(height: 20),
                  _buildBottomSection(), // Move it here
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBrandGroup(CartItemsByVendor shop) {
    final String brand = shop.vendorName;
    final List<CartItemSimple> items = shop.items;
    final bool isExpanded = expandedBrands[brand] ?? true;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      decoration:
          !isExpanded
              ? BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              )
              : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand Header
          GestureDetector(
            onTap: () => _toggleBrandExpansion(brand),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    brand,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF343434),
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(Icons.keyboard_arrow_down),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Items
          if (isExpanded)
            ...items.map((item) {
              final data = MobileProductData.fromCartItem(item);
              return MobileCartItemTile(
                item: data,
                onRemove: () => _onDelete(item, shop),
                onQuantityChanged: (value) async {
                  print(
                    'Quantity changed: $value for item ${item.productName}',
                  );
                  await global.basket.updateCartItemQuantity(
                    profileId: global.user.value.profileId.toString(),
                    quantity: value,
                    product: '${item.productId}-${item.sku.skuId}',
                  );
                  await global.basket.refreshCart(); // ensures totals update
                  setState(() {});
                },
              );
              // return Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 4),
              //   child: ProductDetailComponent(
              //     item: item,
              //     onQuantityChanged: (newQty) {
              //       if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
              //
              //       setState(() {
              //         // update cost manually, but only if you need UI feedback instantly
              //         if (item.quantity < newQty) {
              //           shop.totalCostOfVendor += item.total;
              //         } else if (item.quantity > newQty) {
              //           shop.totalCostOfVendor -= item.total;
              //         }
              //
              //         item.quantity = newQty;
              //       });
              //
              //       _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
              //         await global.basket.updateCartItemQuantity(
              //           profileId: global.user.value.profileId.toString(),
              //           quantity: newQty,
              //           product: '${item.productId}-${item.sku.skuId}',
              //         );
              //         await global.basket.refreshCart(); // ensures totals update
              //       });
              //     },
              //     onDelete: () => _onDelete(item, shop),
              //     onSaveForLater: () {}, // optional
              //   ),
              // );
            }),
        ],
      ),
    );
  }

  Widget _buildSubtotalSection() {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Subtotal:', style: TextStyle(fontSize: 18)),
                Obx(
                  () => Text(
                    currencyFormat.format(
                      global.simpleCart.value.subTotal / 100,
                    ),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Disabled for now
  Widget _buildPromoCodeSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter Promo Code',
            ),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            child: Text('APPLY'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Color(0xFF2C2C2C),
              minimumSize: Size(double.infinity, 50),
            ),
            onPressed: () {
              // TODO: Implement promo code logic
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContinueShoppingSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          ElevatedButton(
            child: Text('Continue to Shop'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Color(0xFF2C2C2C),
              backgroundColor: Colors.white,
              minimumSize: Size(double.infinity, 50),
              side: BorderSide(color: Color(0xFF2C2C2C)),
            ),
            onPressed: () {
              global.vroute.navigateTo('/shop');
            },
          ),
          if (_showSections == false) ...[
            // lets give the user a chance to checkout
            SizedBox(height: 16),
            //   ElevatedButton(
            //     child: Text('Checkout Now ( ${currencyFormat.format(global.simpleCart.value.orderTotal / 100)} )'),
            //     style: ElevatedButton.styleFrom(
            //       foregroundColor: Colors.white,
            //       backgroundColor: Color(0xFF2C2C2C),
            //       minimumSize: Size(double.infinity, 50),
            //       side: BorderSide(color: Color(0xFF2C2C2C)),
            //     ),
            //     onPressed: global.simpleCart.value.hasRestrictions ? null : widget.onCheckout,
            //   ),
            //   if (global.simpleCart.value.hasRestrictions) ...[
            //     const SizedBox(height: 8),
            //     Text(
            //       'Some items in your cart have restrictions. Please review your cart using desktop browser.\nSorry for the inconvenience.',
            //       style: TextStyle(color: YLiftColor.orange, fontSize: 11.11),
            //     ),
            //   ],
            // ]
          ],
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Promotion Requirements
            PromotionRequirementsSidePanel(
              cartItems:
                  global.simpleCart.value.cartItems
                      .where(
                        (cartItem) =>
                            cartItem.promotion?.hasActivePromotion ?? false,
                      )
                      .toList(),
              onQuantityUpdate: (sku, newQuantity) {
                global.basket.updateCartItemQuantity(
                  profileId: global.user.value.profileId.toString(),
                  quantity: newQuantity,
                  product: "${sku.productId}-${sku.skuId}",
                );
                global.basket.refreshCart();
              },
            ),

            // 2. Evolysse Promotion (if applicable)
            if (DateTime.now().isBefore(EvolyssePromotion.expirationDate) &&
                global.simpleCart.value.cartItems.any(
                  (e) => e.brandId == EvolyssePromotion.evolysseBrandId,
                ))
              EvolysseSidePanel(),

            // 3. Restylane Promotion (if applicable)
            if (RestylanePromotionData.isOngoing &&
                RestylanePromotionData.restylaneItems.isNotEmpty)
              RestylanePromotionSidePanel(),

            // 4. Sculptra Promotion (if applicable)
            if (SculptraPromotionData.isOngoing &&
                SculptraPromotionData.sculptraItems.isNotEmpty)
              SculptraPromotionSidePanel(),
            //
            // 5. Dysport Promotion (if applicable)
            if (DysportPromotionData.isOngoing &&
                DysportPromotionData.dysportItems.isNotEmpty)
              DysportPromotionSidePanel(),

            // 6. Merz Promotion (if applicable)
            if (global.simpleCart.value.merzItems.isNotEmpty)
              MerzPromotionSidePanel(),

            // 7. Restrictions (black order requirements)
            if (global.simpleCart.value.hasRestrictions)
              SafeArea(
                top: false,
                left: false,
                right: false,
                bottom: true,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: BlackOrderRequirementsView(
                    orderNotes: global.simpleCart.value.orderNotes,
                  ),
                ),
              ),

            // 8. Order total & checkout button
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Order Total:'),
                  Obx(
                    () => Text(
                      currencyFormat.format(
                        (global.simpleCart.value.orderTotal - (global.simpleCart.value.discountTotal ?? 0)) / 100,
                      ),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    child: Text('Checkout'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFF2C2C2C),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                    ),
                    onPressed:
                        !global.simpleCart.value.isCheckoutable
                            ? () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Some items in your cart have restrictions. Please use desktop browser to checkout.',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                            : () async {
                              await global.basket.refreshCart();
                              widget.onCheckout();
                            },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: PromotionButton(
                text: "Proceed to the Promo Page",
                onTap: () {
                  Navigator.pushNamed(context, '/cart/promotions');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey),
          SizedBox(height: 20),
          Text(
            'Your cart is empty',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            child: Text('Continue Shopping'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Color(0xFF2C2C2C),
              minimumSize: Size(200, 50),
            ),
            onPressed: () {
              // TODO: Implement continue shopping logic
              global.vroute.navigateTo('/shop');
            },
          ),
        ],
      ),
    );
  }
}

class ProductDetailComponent extends StatelessWidget {
  final CartItemSimple item;
  final Function(int) onQuantityChanged;
  final VoidCallback onDelete;
  final VoidCallback onSaveForLater;

  const ProductDetailComponent({
    Key? key,
    required this.item,
    required this.onQuantityChanged,
    required this.onDelete,
    required this.onSaveForLater,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final cartItem = global.simpleCart.value.cartItems.firstWhereOrNull(
        (e) => e.sku.skuId == item.sku.skuId,
      );
      if (cartItem == null) return const SizedBox.shrink();

      final currencyFormat = NumberFormat.currency(symbol: '\$');

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            SizedBox(
              width: 70,
              height: 70,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  item.imageUrl ?? PLACEHOLDER_IMAGE,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => Image.asset(
                        'msc/images/Placeholder_Image.png',
                        fit: BoxFit.cover,
                      ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    currencyFormat.format(cartItem.total / 100),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFFFF6A00), // Orange price
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Delete and Quantity
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  onPressed: onDelete,
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: 100,
                  height: 40,
                  child: QuantityField(
                    value: item.quantity,
                    quantityIncrement: item.sku.quantityIncrement,
                    quantityMinimum: item.sku.quantityMinimum,
                    quantityMaximum: item.sku.quantityMaximum,
                    checkMinimum: true,
                    onChanged: onQuantityChanged,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class CartItemsByVendor {
  final String vendorName;
  final RxList<CartItemSimple> items;
  int totalCostOfVendor = 0;

  CartItemsByVendor({
    required this.vendorName,
    required this.items,
    required this.totalCostOfVendor,
  });

  int get totalShipping => items
      .map((element) => element.shippingPrice)
      .fold(0, (value, element) => value + element);
  int get totalTax => items
      .map((element) => element.itemTaxTotalAsInteger)
      .fold(0, (value, element) => value + element);
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
RxList<CartItemsByVendor> groupCartItemsByVendor(
  List<CartItemSimple> cartItems,
) {
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

// class ProductDetailComponent extends StatelessWidget {
//   final CartItemSimple item;
//
//   final Function(int) onQuantityChanged;
//   final VoidCallback onDelete;
//   final VoidCallback onSaveForLater;
//
//   const ProductDetailComponent({
//     Key? key,
//     required this.item,
//     required this.onQuantityChanged,
//     required this.onDelete,
//     required this.onSaveForLater,
//   }) : super(key: key);
//
//   get currencyFormat => NumberFormat.currency(symbol: '\$');
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx((){
//       final cartItem =
//       global.simpleCart.value.cartItems.firstWhereOrNull((element) => element.sku.skuId == item.sku.skuId);
//       if (cartItem == null) return SizedBox.shrink();
//       return Card(
//         margin: const EdgeInsets.all(8),
//         elevation: 0,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   flex: 1,
//                   child: AspectRatio(
//                     aspectRatio: 1,
//                     child: Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Image.network(item.imageUrl ?? PLACEHOLDER_IMAGE,
//                           errorBuilder: (context, error, stackTrace) => Image.asset('msc/images/Placeholder_Image.png'),
//                         ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   flex: 2,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       if (item.productName.length > 20)
//                         Text(
//                           item.productName,
//                           style: TextStyle(
//                             fontSize: 13
//                           ),
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         )
//                       else
//                         Text(
//                           item.productName,
//                           // style: Theme.of(context).textTheme.headlineSmall,
//                         ),
//                       const SizedBox(height: 8),
//                       Text(
//                         currencyFormat.format(cartItem.total / 100),
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text('Sku: ${item.sku.skuId}'),
//                       if(item.sku.attributeName!= null)Text(item.sku.attributeName!, style: TextStyle(color: Colors.grey, fontSize: 11),),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Expanded(
//                   flex: 1,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                     child: Center(
//                       // child: Placeholder(),
//                       // TODO uncomment this
//                       child: CartCounterStepper(
//                         quantityIncrement: item.sku.quantityIncrement,
//                         quantityMax: item.sku.quantityMaximum,
//                         quantityMin: item.sku.quantityMinimum,
//                         currentValue: item.quantity,
//                         onQuantityChanged: onQuantityChanged,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(
//                   onPressed: onDelete,
//                   child: const Text('Delete'),
//                 ),
//                 // TODO: Implement save for later action | Disabled for now
//                 // ElevatedButton(
//                 //   onPressed: onSaveForLater,
//                 //   child: const Text('Save for later'),
//                 // ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Obx((){
//               return MobileShippingOptions(
//                 sku: cartItem.sku,
//                 options: cartItem.shippingSettings,
//                 total: cartItem.shippingPrice,
//                 shippingType: cartItem.shippingType,
//                 address: global.simpleCart.value.optionalAddress?[cartItem.shippingAddress] ??
//                     global.simpleCart.value.shippingAddress,
//                 onSelectedShippingType: (type) async {
//                   final cart = global.simpleCart.value;
//                   for(final item in cart.cartItems){
//                     if(cartItem.vendorId != item.vendorId) continue;
//                     final shippingAddress = cart.getCustomShippingAddress(item.shippingAddress);
//                     if(shippingAddress?.id != cart.shippingAddress?.id) continue;
//                     await global.basket.setCartShippingType(
//                       profileId: global.user.value.profileId.toString(),
//                       skuId: item.sku.skuId,
//                       type: type,
//                     );
//                   }
//                 },
//               );
//             })
//           ],
//         ),
//       );
//     });
//
//
//   }
// }

// sigh... I guess this would make more sense as its own model
// for now, it's a copy-pa
//
// ste and that is fine
// Widget _buildBrandGroup(CartItemsByVendor shop) {
//   final String brand = shop.vendorName;
//   final List<CartItemSimple> items = shop.items;
//
//   final bool isExpanded = expandedBrands[brand] ?? true;
//
//   // final bool rulesApply = controller.simpleCart.value.info
//   //         ?.vendorOrderDifferenceTotalByVendorId![shop.vendorId!] !=
//   //     null;
//   // TODO reimplement vendor rules later
//   final bool rulesApply = false;
//
//   final int itemCount = items.length;
//
//   if (rulesApply == true) {
//     // TODO: we can worry about this after we get some actual items to show
//
//     // lets see if the galderma rules apply
//     // TODO: This is a temporary solution, we need to move this to the backend
//     // if (shop.vendorId == 19) {
//     //   int galdermaCount = GaldermaRule.checkGaldermaRule(items);
//     //   if (galdermaCount > 0 && galdermaCount < 6) {
//     //     shop.vendorQuantityMissingInOrder = true;
//     //     shop.vendorQuantityMissing = 6 - galdermaCount;
//     //   } else if (galdermaCount >= 6) {
//     //     // print('Galderma rule satisfied.');
//     //     shop.vendorQuantityMissingInOrder = false;
//     //     shop.vendorQuantityMissing = 0;
//     //   }
//     // }
//   }
//
//   final total =global.simpleCart.value.cartItems.where((element) => element.vendorName == shop.vendorName).fold(0, (previousValue, element) => previousValue + element.total);
//   final tax = global.simpleCart.value.cartItems.where((element) => element.vendorName == shop.vendorName).fold(0, (previousValue, element) => previousValue + element.itemTaxTotalAsInteger);
//   //final taxRate = global.simpleCart.value.cartItems.where((element) => element.vendorName == shop.vendorName).fold(0, (previousValue, element) => previousValue + element.taxRate);
//   return Card(
//     margin: EdgeInsets.all(8),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         ListTile(
//           title: Text(brand, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//           subtitle: Text('Items: $itemCount | Tax: ${ tax.toCurrency() } | Total: ${total.toCurrency()}',
//           style: TextStyle(fontSize: 13)),
//           trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
//           onTap: () => _toggleBrandExpansion(brand),
//         ),
//         if (isExpanded)
//           ...items.map(
//             (item) => Container(
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               // margin: EdgeInsets.symmetric(vertical: 4),
//               // padding: EdgeInsets.all(16),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: ProductDetailComponent(
//                       item: item,
//                       onQuantityChanged: (int newQuantity) {
//                         if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
//                         setState(() {
//                           // update the brand total
//                           if (item.quantity < newQuantity) {
//                             shop.totalCostOfVendor += item.total;
//                           } else if (item.quantity > newQuantity) {
//                             shop.totalCostOfVendor -= item.total;
//                           }
//
//                           item.quantity = newQuantity;
//                         });
//
//                         _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
//                           await global.basket.updateCartItemQuantity(
//                             profileId: global.user.value.profileId.toString(),
//                             quantity: item.quantity,
//                             product: '${item.productId}-${item.sku.skuId}',
//                           );
//                         });
//                       },
//                       // Delete the cart item by `brandName`
//                       onDelete: () async {
//                         // setState(() {
//                         //   final cartItemList = global.simpleCart.value.cartItems;
//                         //   cartItemList.removeWhere((element) {
//                         //     if (element.brandName == brand) {
//                         //       global.api.delete(ApiUrl.cartItems.withId(item.sku.productId.toString()));
//                         //       return true;
//                         //     }
//                         //     return false;
//                         //   });
//                         // });
//                         // global.basket.resetCart();
//
//                         try {
//                           setState(() {
//                             isLoading = true;
//                           });
//                           final profileId = '${global.user.value.profileId}';
//                           await global.basket.deleteCartItem(
//                             profileId: profileId,
//                             productId: item.combinedId,
//                           );

//                           setState(() {
//                             cartItemsByVendor = groupCartItemsByVendor(global.simpleCart.value.cartItems);
//                           });
//                         } catch (e) {
//                           ScaffoldMessenger.of(context)
//                               .showSnackBar(SnackBar(content: Text('Failed to delete item')));
//                         } finally {
//                           setState(() {
//                             isLoading = false;
//                           });
//                         }
//                       },
//                       onSaveForLater: () {
//                         // TODO: Implement save for later functionality
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//       ],
//     ),
//   );
// }
