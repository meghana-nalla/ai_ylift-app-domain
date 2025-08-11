import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/models/_clean/product.dart';
import 'package:YLift/presentation/components/_simple/lock_pricing_chip.dart';
import 'package:YLift/presentation/components/_simple/product_image_view.dart';
import 'package:YLift/presentation/components/_simple/product_name.dart';
import 'package:YLift/presentation/components/dialogs/mobile_dialog.dart';
import 'package:YLift/presentation/components/mobile_scaffold.dart';
import 'package:YLift/presentation/components/npi_required_text.dart';
import 'package:YLift/presentation/components/products/mobile_product_tile.dart';
import 'package:YLift/presentation/pages/desktop/error_page/index.dart';
import 'package:YLift/presentation/pages/mobile/product/components/price_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:web/web.dart' as html;

class MobileProductPage extends StatefulWidget {
  final int? productId;
  const MobileProductPage({
    super.key,
    this.productId,
  });

  @override
  State<MobileProductPage> createState() => _MobileProductPageState();
}

class _MobileProductPageState extends State<MobileProductPage> {
  final global = Get.find<GlobalController>();
  final htmlUnescape = HtmlUnescape();

  int quantity = 1;

  int get productId =>
      widget.productId ?? int.parse(Uri.base.path.split('/').last);

  ProductSimple? product;
  bool isLoading = true;
  String? errorMessage;

  late SkuSimple selectedSku;

  bool isAddingToCart = false;

  bool get allowPeptidePurchase {
    final medicalLicense = global.user.value.medicalLicense;
    final isPeptide = product?.categoryId?.contains(136) ?? false;
    if (isPeptide) {
      return medicalLicense?.npiNumber != null &&
          medicalLicense!.npiNumber!.isNotEmpty;
    } else {
      return true;
    }
  }

  bool get allowPurchase {
    return !isAddingToCart && allowPeptidePurchase;
  }

  void addToCart({bool goToCart = false}) async {
    try {
      setState(() {
        isAddingToCart = true;
      });
      final profileId = global.user.value.profileId;
      await global.basket.addToCart(
        customerId: '$profileId',
        quantity: quantity,
        product: '${product!.productId}-${selectedSku.skuId}',
      );
      if (!mounted) return;
      if (!goToCart) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${product?.name} has been added to your cart.'),
            action: SnackBarAction(
              label: 'View Cart',
              onPressed: () {
                global.vroute.navigateTo('/cart');
              },
            ),
          ),
        );
      } else {
        global.vroute.navigateTo('/cart');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return MobileDialog(
            title: Text('Failed to add item'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Something went wrong while adding the item to your cart, please try again later.\n'
                  'If the problem persists, please contact ${YLiftConstant.yliftPhoneNumber} or ${YLiftConstant.yliftEmail}',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  '$e',
                  style: TextStyle(fontSize: 12, color: YLiftColor.orange),
                ),
              ],
            ),
          );
        },
      );
    } finally {
      setState(() {
        isAddingToCart = false;
      });
    }
  }

  List<ProductSimple>? get similarProducts {
    if (product == null) return null;
    final tags = product!.tags;
    if (tags == null) return null;
    final similarProducts = global.allProducts.value.getProductsByTags(
      tags: tags,
      productId: product!.productId,
    );
    return similarProducts;
  }

  void fetchProduct() async {
    try {
      setState(() {
        isLoading = true;
      });
      final product = await global.products.getProductSimple(productId);
      setState(() {
        selectedSku = product.skus!.first;
        quantity = product.skus!.first.quantityMinimum;
        this.product = product;
        errorMessage = null;
      });
    } catch (e) {
      print("Error fetching product: $e");
      setState(() {
        errorMessage = "Failed to load product data. Please try again.";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    fetchProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (errorMessage != null) {
      return ErrorPage();
    }

    final product = this.product;
    if (product == null) {
      return Scaffold(
        body: Center(
          child: Text("Product not found with ID: $productId"),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                global.vroute.navigateTo('/shop');
                              },
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.home_rounded,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Shop',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              ' / ',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(16),
                          ),
                          child: ProductImageView(imageUrl: product.imageUrl),
                        ),
                        const SizedBox(height: 8),
                        ProductName(product.name, fontSize: 18),
                        if (product.caption != null)
                          Text(
                            product.caption!,
                            style: const TextStyle(fontSize: 14),
                          ),

                        // Price
                        if (global.isAuthenticated.isTrue) ...[
                          if (selectedSku.tieredPrice == 0)
                            LockPricingChip(vendorId: product.vendorId)
                          else ...[
                            const SizedBox(height: 8),
                            MobileProductPriceView(
                              listPrice: selectedSku.listPrice,
                              price: selectedSku.tieredPrice,
                            ),
                          ],
                        ],
                        const SizedBox(height: 16),
                        const Text(
                          'Choose a variety:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children:
                              product.skus!.map((e) => _buildSKU(e)).toList(),
                        ),

                        if (product.description != null) ...[
                          const SizedBox(height: 16),
                          const Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Html(
                            data: htmlUnescape.convert(product.description!),
                            style: {
                              "body": Style(fontSize: FontSize(12)),
                            }, // replaced details
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (similarProducts != null) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: const Text(
                        'You Might Also Like',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 256,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        scrollDirection: Axis.horizontal,
                        itemCount: similarProducts!.length,
                        separatorBuilder:
                            (context, index) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final product = similarProducts![index];
                          return NewMobileProductTile(
                            width: 160,
                            product: product,
                            hidePrice: global.isAuthenticated.isFalse,
                            onProductTap: () {
                              html.window.history.replaceState(
                                null,
                                '',
                                '/shop/product/${product.productId}',
                              );
                              fetchProduct();
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          MobileBar(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (!allowPeptidePurchase && global.isAuthenticated.value) ...[
                  const NPIRequiredText(),
                  const SizedBox(height: 8),
                ],

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 120,
                      child: MobileCartItemQuantityField(
                        value: quantity,
                        minimumQuantity: selectedSku.quantityMinimum,
                        maximumQuantity: selectedSku.quantityMaximum,
                        incrementQuantity: selectedSku.quantityIncrement,
                        onChanged: (value) {
                          setState(() {
                            quantity = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Row(
                      children: [
                        _AddToCartButton(
                          onPressed: allowPurchase ? addToCart : null,
                        ),
                        _BuyNowButton(
                          onPressed:
                              allowPurchase
                                  ? () => addToCart(goToCart: true)
                                  : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSKU(SkuSimple sku) {
    final isSelected = selectedSku.skuId == sku.skuId;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSku = sku;
          quantity = selectedSku.quantityMinimum;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? YLiftColor.orange : Colors.grey.shade100,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          sku.attributeName ?? '',
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

class _AddToCartButton extends StatelessWidget {
  final double width;
  final void Function()? onPressed;

  const _AddToCartButton({
    super.key,
    this.width = 120.0,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(6),
        bottomLeft: Radius.circular(6),
      ),
      color: onPressed != null ? YLiftColor.yellow : Colors.grey.shade200,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          width: width,
          padding: EdgeInsets.symmetric(vertical: 6),
          alignment: Alignment.center,
          child: Text(
            'Add to Cart',
            style: TextStyle(
              fontSize: 14,
              color: onPressed != null ? Colors.white : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

class _BuyNowButton extends StatelessWidget {
  final double width;
  final void Function()? onPressed;

  const _BuyNowButton({
    super.key,
    this.width = 120.0,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(6),
        bottomRight: Radius.circular(6),
      ),
      color: onPressed != null ? YLiftColor.orange : Colors.grey.shade200,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          width: width,
          padding: EdgeInsets.symmetric(vertical: 6),
          alignment: Alignment.center,
          child: Text(
            'Buy Now',
            style: TextStyle(
              fontSize: 14,
              color: onPressed != null ? Colors.white : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
