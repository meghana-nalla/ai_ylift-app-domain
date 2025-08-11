import 'package:YLift/core/constants/color.dart';
import 'package:YLift/core/constants/index.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:YLift/presentation/components/_complex/dialogs/add_to_cart_dialog.dart';
import 'package:YLift/presentation/components/_complex/cards/product_card.dart';
import 'package:YLift/presentation/pages/desktop/grid_shopping/shop_all_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const _sections = <String>['Featured', 'Best Sellers', 'New Arrivals'];

class ProductsSection extends StatefulWidget {
  const ProductsSection({super.key});

  @override
  State<ProductsSection> createState() => _ProductsSectionState();
}

class _ProductsSectionState extends State<ProductsSection> {
  final global = Get.find<GlobalController>();
  final sections = _sections.toList();

  String selectedSection = _sections.first;
  void setSection(String value) async {
    setState(() {
      selectedSection = value;
    });
    switch (selectedSection) {
      case 'Featured':
        products = global.allProducts.value.getFeatured(limit: 10);
        break;
      case 'Best Sellers':
        products = global.allProducts.value.getBestSellers(limit: 10);
        break;
      case 'New Arrivals':
        products = global.allProducts.value.getNewArrivals(limit: 10);
        break;
    }

    setState(() {});
  }

  List<ProductSimple> products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    });
    init();
  }
  Future<void> init() async {
    products = global.allProducts.value.getFeatured(limit: 10);
    if (products.length < 5) {
      sections.removeAt(0);
      setSection('Featured');
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$selectedSection Products', style: textTheme.titleLarge),
                    const SizedBox(height: 16),
                    OverflowBar(
                      spacing: 32,
                      children: List.generate(
                        sections.length,
                        (index) {
                          final section = sections[index];
                          final isSelected = section == selectedSection;
                          const selectedStyle = TextStyle(fontWeight: FontWeight.bold);

                          return GestureDetector(
                            onTap: () => setSection(section),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(bottom: isSelected ? BorderSide() : BorderSide.none),
                              ),
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Text(
                                section,
                                style: isSelected ? selectedStyle : null,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    ShopAllSortBy? sortBy;
                    switch (selectedSection) {
                      case 'Best Sellers':
                        sortBy = ShopAllSortBy.bestSeller;
                        break;
                      case 'New Arrivals':
                        sortBy = ShopAllSortBy.newArrivals;
                        break;
                    }
                    global.shopAllSortBy.value = sortBy ?? ShopAllSortBy.bestSeller;
                    global.vroute.navigateTo('/shop/all', extra: 'query=ALL_PRODUCTS');
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: AnimatedContainerWidth(
                      title: selectedSection,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            if (products.isEmpty)
              const Center(
                child: LinearProgressIndicator(),
              )
            else
              Wrap(
                spacing: 24,
                runSpacing: 16,
                children: products.map(
                  (product) {
                    if (product.productId == null) return const SizedBox.shrink();
                    final productId = product.productId ?? 638;
                    return ProductCard(
                      product: product,
                      hidePrice: global.isAuthenticated.isFalse,
                      onTap: () {
                        global.vroute.navigateToProduct(productId);
                      },
                      onLiked: () async {
                        await global.products.likeProduct(productId);
                      },
                      onAddToCart: () async {
                        if (global.isAuthenticated.isFalse) {
                          global.vroute.navigateTo('/login');
                          return;
                        }
                        await showDialog(
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
                ).toList(),
              ),
          ],
        );
  }
}

class AnimatedContainerWidth extends StatefulWidget {
  final String title;
  const AnimatedContainerWidth({
    super.key,
    required this.title,
  });

  @override
  State<AnimatedContainerWidth> createState() => _AnimatedContainerWidthState();
}

class _AnimatedContainerWidthState extends State<AnimatedContainerWidth> {
  late String _text;
  double width = 0.0;

  double _calculateTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    return textPainter.width; // Add some padding
  }

  @override
  void initState() {
    _text = getText(widget.title);

    final textStyle = TextStyle(fontSize: 20);
    width = _calculateTextWidth(_text, textStyle);
    super.initState();
  }

  String getText(String value) {
    switch (value) {
      case 'Best Sellers':
        return 'Shop Best Sellers';
      case 'New Arrivals':
        return 'Explore New Arrivals';
      default:
        return 'Browse All Products';
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedContainerWidth oldWidget) {
    if (widget.title != oldWidget.title) {
      _text = getText(widget.title);

      final textStyle = TextStyle(fontSize: 20);
      width = _calculateTextWidth(_text, textStyle);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: width + 64,
      decoration: ShapeDecoration(
        shape: StadiumBorder(),
        color: YLiftColor.orange,
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(width: 8),
          Icon(Icons.arrow_right_alt, color: Colors.white),
        ],
      ),
    );
  }
}
