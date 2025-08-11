import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/core/constants/index.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:YLift/presentation/components/_simple/lock_pricing_chip.dart';
import 'package:YLift/presentation/components/_simple/stepper.dart';
import 'package:YLift/presentation/components/products/mobile_product_tile.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:YLift/presentation/pages/mobile/menu/product_menu.dart';
import 'package:YLift/presentation/pages/mobile/product/components/image_galery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:galaxy_ui/galaxy_ui.dart';

class SingleProductPage extends StatefulWidget {
  final VoidCallback returnToHome;
  final ProductSimple simpleProduct;
  final ValueSetter<ProductSimple> onSimilarProductSelected;
  final Future<void> Function(int skuId, int quantity, int productId) onAddToCart;

  SingleProductPage({
    required this.returnToHome,
    required this.simpleProduct,
    required this.onSimilarProductSelected,
    required this.onAddToCart,
  });

  @override
  _SingleProductPageState createState() => _SingleProductPageState();
}

class _SingleProductPageState extends State<SingleProductPage> {
  final GlobalController controller = Get.find<GlobalController>();

  final scrollController = ScrollController();

  final NumberFormat currencyFormat = NumberFormat.currency(symbol: '\$');
  final htmlUnescape = HtmlUnescape();
  late SkuSimple? selectedSku;
  late ProductSimple? selectedProduct;
  bool _expanded = false;
  bool _showDropdown = false;
  int _quantity = 1;
  String? errorMessage;

  void setSku(SkuSimple sku) {
    if (widget.simpleProduct.skus == null) {
      setState(() {
        errorMessage = 'Tried to parse a product that had no SKUS';
      });
    } else {
      setState(() {
        selectedSku = widget.simpleProduct.skus!.firstWhereOrNull(
              (x) => x.skuId == sku.skuId,
        );
      });
    }
  }

  String get _truncatedInfo {
    final unescapedInfo = htmlUnescape.convert(
      widget.simpleProduct.description ?? '',
    ); // replaced details
    final firstLine = unescapedInfo
        .split('\n')
        .first;
    return firstLine.length > 100
        ? firstLine.substring(0, 100) + '...'
        : firstLine;
  }

  void _addToCart() {
    widget.onAddToCart(int.parse(selectedSku!.skuId), _quantity, widget.simpleProduct.productId!);

    // give a SnackBar notification
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.simpleProduct.name} added to cart'),
        duration: Duration(seconds: 2),
        action: SnackBarAction(
          label: 'VIEW CART',
          onPressed: () async {
            final controller = Get.find<GlobalController>();
            if (controller.isAuthenticated.isTrue) await controller.basket.refreshCart();
            controller.vroute.navigateTo('/cart');
          },
        ),
      ),
    );
  }

  void _toggleDropdown() {
    setState(() {
      _showDropdown = !_showDropdown;
    });
  }

  void _copyLink() {
    Clipboard.setData(
      ClipboardData(
        text: DOMAIN + "/product/${widget.simpleProduct.productId}",
      ),
    ); // replaced details
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Link copied to clipboard!')));
    _toggleDropdown();
  }

  @override
  void initState() {
    selectedSku = widget.simpleProduct.skus!.first;
    super.initState();
  }

  List<ProductSimple>? get similarProducts {
    final tags = widget.simpleProduct.tags;
    if (tags == null) return null;
    final similarProducts = controller.allProducts.value.getProductsByTags(
      tags: tags,
      productId: widget.simpleProduct.productId,
    );
    return similarProducts;
  }

  @override
  Widget build(BuildContext context) {
    final skus = widget.simpleProduct.skus!;
    return Scaffold(
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox.square(
              dimension: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: ImageGalery(
                imageUrl: widget.simpleProduct.imageUrl,
                fit: BoxFit.cover,
                onBack: widget.returnToHome,
                onShare: () {
                  _copyLink();
                },
              ),
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.simpleProduct.name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  SizedBox(height: 8.0),
                  if (controller.isAuthenticated.value) ...[
                    // if the above is set to zero 0 then we use sku based pricing
                    if(selectedSku!.tieredPrice == 0) LockPricingChip(vendorId: widget.simpleProduct.vendorId)
                    else
                      _buildPricingInfo(
                      selectedSku!.listPrice,
                      selectedSku!.tieredPrice,
                      Theme
                          .of(context)
                          .textTheme,
                    ),
                  ] else
                    ...[
                      TextButton(
                        onPressed: () {
                          controller.vroute.navigateTo('/login');
                        },
                        child: Text(
                            'Please Sign In To View Pricing', style: TextStyle(
                          color: Theme
                              .of(context)
                              .primaryColor,
                          decoration: TextDecoration.underline,
                        )),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal:0)
                        ),
                      ),
                    ],

                  if (widget.simpleProduct.skus!.isNotEmpty &&
                      widget.simpleProduct.skus!.first.attributes != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8.0),
                        const Text(
                            'Choose a variety: ',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8.0),
                        if (skus.isNotEmpty &&
                            skus.any((sku) =>
                            sku.attributes?.isNotEmpty ?? false)) ...[
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: List.generate(skus.length, (index) {
                              final sku = skus[index];
                              return RadioButton<SkuSimple>(
                                groupValue: selectedSku,
                                value: sku,
                                onSelected: () => setSku(sku),
                                child: Text(
                                  sku.attributeName ?? '',
                                  style: TextStyle(fontSize: 11.11),
                                ),
                              );
                            }),
                          ),
                        ],
                      ],
                    ),
                  SizedBox(height: 16.0),
                  Text(
                    'Description',
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyLarge,
                  ),
                  AnimatedCrossFade(
                    firstChild: Html(data: _truncatedInfo,
                      style: {
                        "body": Style(
                            fontSize: FontSize(13)
                        )
                      },),
                    secondChild: Html(
                      data: htmlUnescape.convert(
                        widget.simpleProduct.description ?? '',
                      ),
                      style: {
                        "body": Style(
                            fontSize: FontSize(13)
                        )
                      }, // replaced details
                    ),
                    crossFadeState:
                    _expanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: Duration(milliseconds: 300),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _expanded = !_expanded;
                          });
                        },
                        child: Text(_expanded ? 'Read Less' : 'Read More'),
                      ),
                    ],
                  ),

                  if (errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        errorMessage!,
                        style: TextStyle(color: YLiftColor.orange),
                      ),
                    ),
                  SizedBox(height: 16.0),
                  Divider(),
                  SizedBox(height: 16.0),
                  Text(
                    'You Might Also Like',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),
                  if (similarProducts != null)
                    SizedBox(
                      height: 250,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        scrollDirection: Axis.horizontal,
                        itemCount:
                        similarProducts!
                            .length,
                        // TODO replace with actual recommended
                        separatorBuilder:
                            (context, index) => const SizedBox(width: 16),
                        itemBuilder: (context, index) {
                          final product = similarProducts![index];
                          return MobileProductTile(
                            product: product,
                            hidePrice: controller.isAuthenticated.isFalse,
                            onProductTap: () {
                              setState(() {
                                selectedSku = product.skus!.first;
                                widget.onSimilarProductSelected(product);
                              });
                              scrollController.jumpTo(0);
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ProductMenu(
        isAuthenticated: global.isAuthenticated.isTrue,
        onLogin: () {
          controller.vroute.navigateTo('/login');
        },
        child: YLiftStepper(
          quantityMin: selectedSku!.quantityMinimum,
          quantityMax: selectedSku!.quantityMaximum,
          quantityIncrement: selectedSku!.quantityIncrement,
          currentValue:
          (_quantity < selectedSku!.quantityMinimum)
              ? selectedSku!.quantityMinimum
              : _quantity,
          onQuantityChanged: (p0) {
            _quantity = p0;
          },
        ),
        replaceChild: Text('Sign in to unlock store features',
          maxLines: 2,
          style: TextStyle(fontSize: 13),
        ),
        onAddToCart: selectedSku!.tieredPrice > 0 ? _addToCart : null,
        onBuy: () async {
          await widget.onAddToCart(int.parse(selectedSku!.skuId), _quantity, widget.simpleProduct.productId!);
          controller.vroute.navigateToIndex(1);
        },
      ),
    );
  }

  Widget _buildPricingInfo(int? listPrice, int? tieredPrice, TextTheme textTheme) {
    if (listPrice == null || listPrice == 0 || tieredPrice == null)
      return const SizedBox.shrink();
    final discount = ((listPrice - tieredPrice) / listPrice * 100).round();
    final formattedRetailPrice = currencyFormat.format(listPrice / 100);
    // final formattedPrice = currencyFormat.format(tieredPrice / 100);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (tieredPrice > 0) ...[
              Text(
                tieredPrice.toCurrency(),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            if(listPrice > tieredPrice)...[
              SizedBox(width: 8),
              Text(
                '($discount% off)',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
              SizedBox(width: 8),
              Text(
                formattedRetailPrice,
                style: TextStyle(
                  fontSize: 16,
                  //fontWeight: FontWeight.Bold,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: textTheme.headlineSmall?.color,
                ),
              ),
            ],

          ],
        ),
      ],
    );
  }
}

class SimilarProductCard extends StatelessWidget {
  final ProductSimple simpleProduct;
  final GlobalController controller;
  final VoidCallback onProductSelected;
  final NumberFormat currencyFormat = NumberFormat.currency(symbol: '\$');

  SimilarProductCard({
    super.key,
    required this.simpleProduct,
    required this.onProductSelected,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onProductSelected,
        child: Container(
          width: 100,
          margin: EdgeInsets.only(right: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                simpleProduct.imageUrl.isNotEmpty
                    ? simpleProduct.imageUrl
                    : PLACEHOLDER_IMAGE,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) =>
                        Image.asset('msc/images/Placeholder_Product.png'),
              ),
              SizedBox(height: 8.0),
              Text(
                simpleProduct.name,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              if (simpleProduct.skus?.first.tieredPrice == 0) ...[
                const SizedBox(height: 8),
                LockPricingChip(vendorId: simpleProduct.vendorId),
              ] else if (simpleProduct.skus?.first.tieredPrice == 0 &&
                  simpleProduct.skus?.first.listPrice == 0) ...[
                const SizedBox(height: 8),
                LockPricingChip(vendorId: simpleProduct.vendorId),
              ] else if (simpleProduct.skus?.first.tieredPrice != null &&
                  (simpleProduct.skus?.first.listPrice != null &&
                      simpleProduct.skus?.first.listPrice != 0) &&
                  simpleProduct.skus?.first.listPrice !=
                      simpleProduct.skus?.first.tieredPrice) ...[
                const SizedBox(height: 4),
                Wrap(
                  spacing: 16,
                  children: [
                    Text(
                      simpleProduct.skus!.first.tieredPrice.toCurrency(),
                      style: TextStyle(
                        color: YLiftColor.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // const SizedBox(width: 16),
                    if (simpleProduct.skus?.first.listPrice != null &&
                        simpleProduct.skus?.first.listPrice != 0)
                      Text(
                        simpleProduct.skus!.first.listPrice!.toCurrency(),
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          fontSize: 13.33,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
              ] else if ((simpleProduct.skus?.first.tieredPrice ?? 0) > 0) ...[
                Text(
                  (simpleProduct.skus?.first.tieredPrice ?? 0).toCurrency(),
                  style: TextStyle(fontSize: 13.33),
                ),
              ] else
                LockPricingChip(vendorId: simpleProduct.vendorId),
            ],
          ),
        ),
      ),
    );
  }
}
