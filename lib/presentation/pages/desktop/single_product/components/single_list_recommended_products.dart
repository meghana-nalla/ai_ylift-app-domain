import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/core/extensions/price_extension.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:galaxy_ui/galaxy_ui.dart';

class RecommendedProductsView extends StatelessWidget {
  const RecommendedProductsView({
    super.key,
    required this.relatedProducts,
  });

  final List<ProductSimple> relatedProducts;
  static const String PLACEHOLDER_IMAGE = 'assets/images/placeholder.png'; // Adjust as needed

  @override
  Widget build(BuildContext context) {
    /// global controller
    GlobalController global = Get.find<GlobalController>();

    /// category heading
    return SizedBox(
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Best sellers text
          const SectionTitle(labelText: 'You Might Also Like'),
          const SizedBox(height: 25),

          /// dynamic scroll view
          Expanded(
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: relatedProducts.length,
                separatorBuilder: (context, index) => const SizedBox(width: 25),
                itemBuilder: (context, index) {
                  final product = relatedProducts[index];
                  // product price display
                  final priceDisplay = (global.isAuthenticated.isTrue) ? product.firstPrice?.toCurrency() ?? 'No price' : "Log In To See Prices";
                  return ProductCardHeart(
                    productId: product.productId ?? -1,
                    name: product.name,
                    price: priceDisplay,
                    addToCart: () async {
                      final defaultSku = product.skus?.first;
                      if (defaultSku == null) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('No default SKU'),
                              content: const Text(
                                  'Please go to the product page instead of using quick add to cart action.'),
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
                        return;
                      }
                      await global.basket.addToCart(
                          customerId: global.user.value.profileId.toString(),
                          quantity: defaultSku.quantityMinimum,
                          product: "${product.productId}-${defaultSku.skuId}"
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Product has been added to cart'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    placeholderImage: PLACEHOLDER_IMAGE,
                    defaultTextStyle: Theme.of(context).textTheme.bodyLarge!,
                    hotIcon: const HotIcon(),
                    brownButton: ({required Widget child}) => BrownButton(child: child),
                    favoriteIcon: ({required bool isLiked, required VoidCallback onTap}) =>
                        FavoriteIcon(isLiked: isLiked, onTap: onTap),
                    navigateToProductCallback: (id) {
                      global.products.setDisplayProduct(id);
                      global.vroute.navigateToProduct(id);
                    },
                    hasNetworkPricing: true,
                    productImageUrl: product.imageUrl,
                    isLiked: global.products.likedProducts.contains(product.productId),
                    onToggleLike: global.isAuthenticated.isTrue
                        ? (value) => global.products.likeProduct(product.productId!)
                        : null,
                    width: 240,
                    imageHeight: 240,
                    hoverAnimationDuration: const Duration(milliseconds: 150),
                    hoverScale: 1.1,
                  );
                }),
          ),
        ],
      ),
    );
  }
}