import 'package:YLift/presentation/components/products/mobile_product_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:galaxy_ui/galaxy_ui.dart';

class ProductsByCategoryListView extends StatefulWidget {
  final String title;
  final String categoryId;
  // final List<ProductSimple>? categoryProducts;

  const ProductsByCategoryListView({
    super.key,
    required this.title,
    required this.categoryId,
    // this.categoryProducts,
  });

  @override
  State<ProductsByCategoryListView> createState() => _ProductsByCategoryListViewState();
}

class _ProductsByCategoryListViewState extends State<ProductsByCategoryListView> {
  final global = Get.find<GlobalController>();
  bool isLoading = false;

  bool isAtStart = true;
  bool isAtEnd = false;

  void scrollListener() {
    final position = scrollController.position;
    setState(() {
      isAtStart = position.pixels <= position.minScrollExtent;
      isAtEnd = position.pixels >= position.maxScrollExtent;
    });
  }

  static const productWidth = 256.0 + 20;
  static const nextProducts = productWidth * 3;
  List<ProductSimple> _categoryProducts = [];
  final scrollController = ScrollController();

  void _getCategoryProducts() {
    _categoryProducts = global.allProducts.value.getProductsByCategoryIds(categoryIds: [int.parse(widget.categoryId)]);

    _categoryProducts = (_categoryProducts.length > 10) ? _categoryProducts.take(10).toList() : _categoryProducts;

    _categoryProducts.sort((a, b) {
      if (a.bestSellerRank != null && b.bestSellerRank != null) {
        return a.bestSellerRank!.compareTo(b.bestSellerRank!);
      }
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
  }

  void scrollLeft() async {
    var nextPosition = scrollController.position.pixels - nextProducts;
    if (nextPosition < 0) nextPosition = 0;
    await scrollController.animateTo(
      nextPosition,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void scrollRight() async {
    var nextPosition = scrollController.position.pixels + nextProducts;
    final max = scrollController.position.maxScrollExtent;
    if (nextPosition > max) nextPosition = max;
    await scrollController.animateTo(
      nextPosition,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    scrollController.addListener(scrollListener);

    super.initState();
    _getCategoryProducts();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const LinearProgressIndicator();
    }

    return (_categoryProducts.isEmpty)
        ? SizedBox.shrink()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: global.isMobile.isTrue ? const EdgeInsets.symmetric(horizontal: 8) : EdgeInsets.zero,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(fontSize: global.isMobile.isTrue ? 18 : 24, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    ArrowButton(
                      direction: ArrowDirection.left,
                      onPressed: isAtStart ? null : scrollLeft,
                    ),
                    const SizedBox(width: 18), // Spacing
                    ArrowButton(
                      direction: ArrowDirection.right,
                      onPressed: isAtEnd ? null : scrollRight,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    _categoryProducts.length * 2 - 1,
                    (index) {
                      if (index.isOdd) return SizedBox(width: 20);

                      final product = _categoryProducts[index ~/ 2];
                      final isMobile = global.isMobile.value;
                      if(isMobile) {
                        return ProductCardFeatured(
                          product: product,
                            onProductSelected: () => global.vroute.navigateToProduct(product.productId!),
                            hidePrice: global.isAuthenticated.isFalse
                        );
                        // return MobileProductTile(
                        //   product: product,
                        //   onProductTap: () {
                        //     global.vroute.navigateToProduct(product.productId!);
                        //   },
                        //   hidePrice: global.isAuthenticated.isFalse,
                        // );
                      }

                      return ProductCard(
                        product: product,
                        hidePrice: global.isAuthenticated.isFalse,
                        onTap: () {
                          global.vroute.navigateToProduct(product.productId!);
                        },
                        onLiked: () async {
                          await global.products.likeProduct(product.productId!);
                        },
                        onAddToCart: () {
                          if (global.isAuthenticated.isFalse) {
                            global.vroute.navigateTo('/login');
                            return;
                          }
                          showDialog(
                            context: context,
                            builder: (context) => AddToCartDialog(
                              product: product,
                              onSeeProduct: () {
                                global.vroute.navigateToProduct(product.productId!);
                              },
                              onAddToCart: (sku, quantity) async {
                                await global.basket.addToCart(
                                  customerId: global.user.value.profileId.toString(),
                                  quantity: quantity,
                                  product: "${product.productId}-${sku.skuId}"
                                );
                                global.drawerController.openEndDrawer();
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          );
  }
}
