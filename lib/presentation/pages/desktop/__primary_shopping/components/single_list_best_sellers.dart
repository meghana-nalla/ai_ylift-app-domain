import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/core/extensions/price_extension.dart';
import 'package:YLift/core/repositories/image_repository.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/models/_clean/product.dart';
import 'package:http/http.dart' as http;
import 'package:galaxy_ui/galaxy_ui.dart';

class BestSellersView extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  const BestSellersView({
    super.key,
    this.scaffoldKey,
  });

  @override
  State<BestSellersView> createState() => _BestSellersViewState();
}

class _BestSellersViewState extends State<BestSellersView> {
  /// global controller
  GlobalController controller = Get.find<GlobalController>();
  static const nextProduct = 240 + YLiftConstant.gap;
  static const nextProducts = nextProduct * 3;

  final scrollController = ScrollController();
  void scrollLeft() {
    var nextPosition = scrollController.position.pixels - nextProducts;
    if (nextPosition < 0 || nextPosition < nextProducts) nextPosition = 0;
    scrollController.animateTo(
      nextPosition,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void scrollRight() {
    var nextPosition = scrollController.position.pixels + nextProducts;
    final max = scrollController.position.maxScrollExtent;
    if (nextPosition > max) nextPosition = max;
    scrollController.animateTo(
      nextPosition,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  /// check to see if an image url is valid
  Future<bool> isImageUrlValid(String imageUrl) async {
    if (imageUrl.isEmpty) {
      return false;
    }

    try {
      final response = await http.head(Uri.parse(imageUrl));
      if (response.statusCode < 400) {
        // final contentType = response.headers['content-type'];
        // return contentType?.startsWith('image/') ?? false;
        return true;
      }

      return false;
    } catch (e) {
      print('Error validating image URL: $e');
      return false;
    }
  }

  /// return a list of products only if they have valid images
  Future<void> getProductsWithImages() async {
    bestSellersWithImages = [];
    for (ProductSimple product in bestSellers) {
      if (await isImageUrlValid(product.imageUrl!)) {
        bestSellersWithImages.add(product);
      }
    }

    setState(() {
      productsToDisplay = bestSellersWithImages;
      isLoading = false;
    });
  }

  late List<ProductSimple> bestSellersWithImages;
  late List<ProductSimple> bestSellers;
  late List<ProductSimple> productsToDisplay;
  late bool isAuthenticated;
  bool isLoading = true;
  final bool imagesOnly = false;

  @override
  void initState() {
    super.initState();
    bestSellers = controller.allProducts.value.products;
    isAuthenticated = controller.isAuthenticated.isTrue;
    if (imagesOnly) {
      getProductsWithImages();
    } else {
      productsToDisplay = bestSellers;
      isLoading = false;
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  static const _imageRepository = ImageRepository();
  static const String PLACEHOLDER_IMAGE = 'assets/images/placeholder.png';

  @override
  Widget build(BuildContext context) {
    /// category heading
    return !isLoading
        ? SizedBox(
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Best sellers text
              const SectionTitle(labelText: 'Best Sellers'),
              const Spacer(),
              IconButton(
                onPressed: () => scrollLeft(),
                icon: const Icon(Icons.chevron_left),
                style: IconButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
              ),
              const SizedBox(width: 18),
              IconButton(
                onPressed: () => scrollRight(),
                icon: const Icon(Icons.chevron_right),
                style: IconButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
              ),
            ],
          ),
          const GapY(),

          /// dynamic scroll view
          Expanded(
            child: ListView.separated(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: productsToDisplay.length,
              separatorBuilder: (context, index) => const GapX(),
              itemBuilder: (context, index) {
                final product = productsToDisplay[index];
                final productId = product.productId ?? 638;
                //  product price display
                final priceDisplay = (controller.isAuthenticated.isTrue) ? product.firstPrice?.display() ?? 'No price' : "Log In To See Prices";

                return ProductCardHeart(
                  productId: productId,
                  name: product.name,
                  price: priceDisplay,
                  addToCart: () async {
                    showDialog(
                      context: context,
                      builder: (context) => AddToCartDialog(
                          product: product,
                          onSeeProduct: () {
                            global.vroute.navigateToProduct(product.productId!);
                          },
                          onAddToCart: (sku, quantity) async {
                            global.drawerController.openEndDrawer();
                            await controller.basket.addToCart(
                                customerId: controller.user.value.profileId.toString(),
                                quantity: quantity,
                                product: "${product.productId}-${sku.skuId}"
                            );
                          }
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
                    controller.products.setDisplayProduct(id);
                    controller.vroute.navigateToProduct(id);
                  },
                  // optional properties
                  hasNetworkPricing: true,
                  productImageUrl: _imageRepository.getProductImageUrl('$productId'),
                  isLiked: controller.products.likedProducts.contains(productId),
                  onToggleLike: isAuthenticated ? (value) => controller.products.likeProduct(productId) : null,
                  width: 240,
                  imageHeight: 240,
                  hoverAnimationDuration: const Duration(milliseconds: 150),
                  hoverScale: 1.1,
                );
              },
            ),
          ),
        ],
      ),
    )
        : const CircularProgressIndicator();
  }
}