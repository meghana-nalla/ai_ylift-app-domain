
import 'package:YLift/models/z-index_export.dart';
import 'package:YLift/presentation/components/_complex/cart_drawer/drawer_cart_item_tile.dart';
import 'package:YLift/presentation/components/_simple/lock_pricing_chip.dart';
import 'package:YLift/presentation/components/_simple/product_image_view.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:galaxy_ui/galaxy_ui.dart';

class CartDrawer extends StatelessWidget {
  final List<ProductSimple> similarProducts;
  final List<CartItemSimple> cartItems;
  final int subtotalCost;
  final void Function(ProductSimple product)? onSimilarProductSelected;
  final void Function(ProductSimple product)? onSimilarProductQuickAdd;
  final void Function(CartItemSimple cartItem, int newQuantity)? onUpdateQuantity;
  final void Function(CartItemSimple cartItem)? onDeleteCartItem;
  final void Function()? onProceedToCheckout;
  final void Function()? onViewCart;

  const CartDrawer({
    super.key,
    this.similarProducts = const <ProductSimple>[],
    this.cartItems = const <CartItemSimple>[],
    this.subtotalCost = 0,
    this.onSimilarProductSelected,
    this.onSimilarProductQuickAdd,
    this.onUpdateQuantity,
    this.onDeleteCartItem,
    this.onProceedToCheckout,
    this.onViewCart,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Drawer(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      width: 720,
      backgroundColor: Colors.white,
      child: Row(
        children: [
          SizedBox(
            width: 200,
            child: Column(
              children: [
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Trending Products You Might Like',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SimilarProductListView(
                    products: similarProducts,
                    onSelected: onSimilarProductSelected,
                    onQuickAdd: onSimilarProductQuickAdd,
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(width: 2),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // const SizedBox(height: YLiftConstant.topNavigationHeight),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CloseIconButton(),
                      Text('MY CART', style: textTheme.titleLarge),
                      Badge(
                        alignment: Alignment(0.1, 0.6),
                        label: Text('${cartItems.length}'),
                        backgroundColor: Color(0xFF343434),
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  if (cartItems.isEmpty)
                    const Expanded(
                      child: Text('No items in my cart.'),
                    )
                  else
                    Expanded(
                      child: ListView.separated(
                        itemCount: cartItems.length,
                        separatorBuilder: (context, index) => const Divider(height: 56),
                        itemBuilder: (context, index) {
                          final cartItem = cartItems[index];
                          return DrawerCartItemTile(
                            cartItem: cartItem,
                            onUpdateQuantity: (newQuantity) {
                              onUpdateQuantity?.call(cartItem, newQuantity);
                            },
                            onDelete: () {
                              onDeleteCartItem?.call(cartItem);
                            },
                          );
                        },
                      ),
                    ),
                  const Divider(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Subtotal',
                        style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(subtotalCost.toCurrency()),
                    ],
                  ),
                  const Divider(
                    height: 32,
                    thickness: 4,
                    color: Colors.black,
                  ),

                  SizedBox(
                    width: double.infinity,
                    child: RoundedFilledButton(
                      color: YLiftColor.orange,
                      onPressed: onViewCart,
                      child: const Text(
                        'PROCEED TO CART',
                        style: TextStyle(fontSize: 13.33, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: RoundedFilledButton(
                      onPressed: cartItems.isEmpty ? null : onProceedToCheckout,
                      child: const Text('GO TO CHECKOUT'),
                    ),
                  ),
                  const SizedBox(height: 64),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SimilarProductListView extends StatelessWidget {
  final Axis scrollDirection;
  final List<ProductSimple> products;
  final void Function(ProductSimple simple)? onSelected;
  final void Function(ProductSimple product)? onQuickAdd;

  const SimilarProductListView({
    super.key,
    required this.products,
    this.scrollDirection = Axis.vertical,
    this.onSelected,
    this.onQuickAdd,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: scrollDirection,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: products.length,
      separatorBuilder: (context, index) => const SizedBox(height: 32),
      itemBuilder: (context, index) {
        final product = products[index];
        return Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
                onSelected?.call(product);
              },
              child: Column(
                children: [
                  SizedBox.square(
                    dimension: 120,
                    child: ProductImageView(imageUrl: product.imageUrl),
                  ),
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 11.11,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            if (product.skus != null && product.skus!.first.tieredPrice > 0) ...[
              InkWell(
                onTap: onQuickAdd != null ? () => onQuickAdd!(product) : null,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: YLiftColor.grey3),
                  ),
                  height: 32,
                  width: 120,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Expanded(
                        child: Center(
                          child: Text(
                            'ADD',
                            style: TextStyle(
                              fontSize: 11.11,
                              letterSpacing: 1.4,
                            ),
                          ),
                        ),
                      ),
                      const VerticalDivider(width: 2, indent: 8, endIndent: 8),
                      Expanded(
                        child: Center(
                          // child: Text('\$${product.firstPrice ~/ 100}'),
                          child: CurrencyText(
                            (product.firstPrice ?? 0) ~/ 100,
                            style: TextStyle(fontSize: 11.11),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              LockPricingChip(vendorId: product.vendorId)
            ],
          ],
        );
      },
    );
  }
}
