import 'dart:math';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:YLift/presentation/components/_complex/dialogs/error_tile.dart';
import 'package:YLift/presentation/components/_simple/lock_pricing_chip.dart';
import 'package:YLift/presentation/components/_simple/product_image_view.dart';
import 'package:YLift/presentation/components/npi_required_text.dart';
import 'package:YLift/presentation/components/report_issue_button.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:YLift/presentation/pages/desktop/cart/components/merz_promotion_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:get/get.dart';
import 'package:galaxy_models/galaxy_models.dart';

import '../../../../core/constants/constant.dart';

class ProductPageView extends StatefulWidget {
  const ProductPageView({super.key});

  @override
  State<ProductPageView> createState() => _ProductPageViewState();
}

class _ProductPageViewState extends State<ProductPageView> {
  final GlobalController global = Get.find<GlobalController>();

  bool isAddingToCart = false;
  bool get allowPurchase {
    return !isAddingToCart && allowPeptidePurchase;
  }

  String? errorMessage;

  bool get allowPeptidePurchase {
    final medicalLicense = global.user.value.medicalLicense;
    final isPeptide = product?.categoryId?.contains(136) ?? false;
    if (isPeptide) {
      return medicalLicense?.npiNumber != null && medicalLicense!.npiNumber!.isNotEmpty;
    } else {
      return true;
    }
  }

  String? _skuText;
  String? _skuCode;

  // We'll manage these with local state
  SkuSimple? _selectedSku;
  SkuSimple? _clickedSku;
  int _clickedSkuIndex = 0;
  int _quantity = 1; // initialize with default value

  bool _clicked = false;
  bool _isActive = false;

  // Check if a sku is already in the cart
  bool isSkuInCart(SkuSimple sku) {
    return global.simpleCart.value.cartItems.any(
          (item) => item.skuId == sku.skuId,
    );
  }

  // Check if any sku from this product is in the cart
  bool isProductInCart(ProductSimple currentProduct) {
    if (currentProduct.productId == null) return false;
    return global.simpleCart.value.cartItems.any(
          (item) => item.productId == currentProduct.productId,
    );
  }

  // Get the list of skus in cart for this product
  List<int> getCartSkuIds(ProductSimple currentProduct) {
    if (currentProduct.productId == null) return [];
    return global.simpleCart.value.cartItems
        .where((item) => item.productId == currentProduct.productId)
        .map((item) => item.skuId)
        .toList();
  }

  final scrollController = ScrollController();
  bool isAtStart = true;
  bool isAtEnd = false;
  static const productWidth = 256.0 + 20;
  static const nextProducts = productWidth * 3;

  ProductSimple? product;
  List<ProductSimple> lstProducts = [];

  void scrollListener() {
    final position = scrollController.position;
    setState(() {
      isAtStart = position.pixels == position.minScrollExtent;
      isAtEnd = position.pixels == position.maxScrollExtent;
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

  ///Modified to not change the value when user change from other product
  void setSku(SkuSimple sku) {
    setState(() {
      _selectedSku = sku;
      _quantity = _quantity; //max(_quantity, sku.quantityMinimum);
    });
    _setDisplayText(_getDisplayText(_selectedSku));
    _setProductId(_getAttributeProductId(_selectedSku));
  }

  void buyNow() async {
    try {
      setState(() {
        isAddingToCart = true;
      });

      if (!global.isAuthenticated.value) {
        showDialog(
          context: context,
          builder: (context) => const NetworkBenefitsDialog(),
        );
        return;
      }

      if (!_isActive) {
        TierDialog.show(context);
        return;
      }

      if (_selectedSku == null) {
        // Show SKU selection required dialog
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
            title: const Text('Selection Required'),
            content: const Text('Please select a product variant'),
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

      await global.basket.addToCart(
        customerId: global.user.value.profileId.toString(),
        quantity: _quantity,
        product: "${product?.productId ?? '0'}-${_selectedSku!.skuId}",
      );
      global.vroute.navigateTo('/order/cart');
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isAddingToCart = false;
      });
    }
  }

  void addToCart() async {
    try {
      //throw Exception();
      setState(() {
        isAddingToCart = true;
      });
      if (global.isAuthenticated.value) {
        if (_isActive) {
          await global.basket.addToCart(
            customerId: global.user.value.profileId.toString(),
            //customerId: "0",
            quantity: _quantity,
            product: "${product?.productId ?? '0'}-${_selectedSku!.skuId}",
          );
          if (!mounted) return;
          showDialog(
            context: context,
            builder:
                (context) => MoreLikeThisDialog(
              productName: global.displayProduct.value.name,
              similarProducts:
              (global.displayProduct.value.tags != null
                  ? global.allProducts.value.getProductsByTags(
                tags: global.displayProduct.value.tags!,
                productId: global.displayProduct.value.productId,
              )
                  : global.allProducts.value.getBestSellers()),
              onSimilarProductSelected: (product) async {
                final productId = product.productId ?? -1;
                if (productId != -1) {
                  global.displayProduct.value = product;
                  fetchProducts();
                }
              },
            ),
          );
        } else {
          TierDialog.show(context);
        }
      } else {
        showDialog(
          context: context,
          builder:
              (context) => _AuthenticationRequiredDialog(
            productId: global.displayProduct.value.productId!.toString(),
          ),
        );
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isAddingToCart = false;
      });
    }
  }

  Map<String, dynamic> _getDisplayAttributes(SkuSimple selectedSku) {
    if (selectedSku.attributes == null) {
      return {};
    }

    Map<String, dynamic> skuAttributes = selectedSku.attributes!;

    var filteredEntries =
    skuAttributes.entries.where((entry) {
      final key = entry.key.toLowerCase();
      return key != 'Product-#' &&
          key != 'PRODUCT-#' &&
          key != 'product-#' &&
          key != 'sku' &&
          key != 'metadata' &&
          key != 'test';
    }).toList();

    // Sort entries by key length
    filteredEntries.sort((a, b) => a.value.length.compareTo(b.value.length));

    return Map.fromEntries(filteredEntries);
  }

  //Get Product Id from Attributes
  Map<String, dynamic> _getProductAttribute(SkuSimple selectedSku) {
    if (selectedSku.attributes == null) {
      return {};
    }

    Map<String, dynamic> skuAttributes = selectedSku.attributes!;

    //Filter Entries to get just Product id
    var filteredEntries =
    skuAttributes.entries
        .where((x) => x.key.toLowerCase().contains("product"))
        .toList();

    return Map.fromEntries(filteredEntries);
  }

  String _getDisplayText(SkuSimple? selectedSku) {
    if (selectedSku == null) {
      return "";
    }

    Map<String, dynamic> attributes = _getDisplayAttributes(selectedSku);

    if (attributes.isEmpty) {
      return "";
    }

    String displayText = "";
    for (int i = 0; i < attributes.length; i++) {
      displayText += attributes.keys.elementAt(i).toString().toUpperCase();
      displayText += ": ";
      displayText += attributes.values.elementAt(i).toString();
      if (i != attributes.length - 1) displayText += " | ";
    }
    return displayText;
  }

  String _getAttributeProductId(SkuSimple? selectedSku) {
    if (selectedSku == null) {
      return "";
    }

    Map<String, dynamic> attributes = _getProductAttribute(selectedSku);

    if (attributes.isEmpty) {
      return "";
    }
    String displayText = attributes.values.elementAt(0);
    return displayText;
  }

  void _setDisplayText(String displayText) {
    setState(() {
      _skuText = displayText;
    });
  }

  void _setProductId(String displayText) {
    setState(() {
      _skuCode = displayText;
    });
  }

  //Set the price based on the object information
  void setPrice(ProductSimple? product) {
    if (product == null) return;

    if (product.defaultSkuId != null || product.skus != null) {
      if (product.defaultSkuId == null) {
        var lstskus = product.skus?.where((s) => s.isActive);
        if (lstskus != null && lstskus.isNotEmpty) {
          _selectedSku = lstskus.first;
          _clickedSku = _selectedSku;
          _isActive =
              _selectedSku?.tieredPrice != null &&
                  _selectedSku!.tieredPrice > 0;
          _setDisplayText(_getDisplayText(_selectedSku));
          _quantity = max(1, (_selectedSku?.quantityMinimum ?? 1));
        }
      }
    }
  }

  void fetchProducts() async {
    // Get the current global product
    final displayProduct = global.displayProduct.value;

    // Make sure we have a product to display
    if (displayProduct.productId == null) {
      setState(() {
        product = null;
        _quantity = 1;
        lstProducts = [];
      });

      // Force hiding splash and loading screens
      global.showingSplash.value = false;
      global.siteReady.value = true;
      global.update();
      return;
    }

    // Set the product from global state
    setState(() {
      product = displayProduct;
    });

    // Handle SKU selection
    if (displayProduct.skus != null && displayProduct.skus!.isNotEmpty) {
      setState(() {
        _selectedSku = displayProduct.skus![0];
        _clickedSku = _selectedSku;
        _isActive =
            _selectedSku?.tieredPrice != null && _selectedSku!.tieredPrice > 0;
        _setDisplayText(_getDisplayText(_selectedSku));
        _quantity = max(1, (_selectedSku?.quantityMinimum ?? 1));
      });
    } else {
      setState(() {
        _selectedSku = null;
        _clickedSku = null;
        _isActive = false;
        _quantity = 1;
      });
    }

    try {
      // Get related products
      if (displayProduct.tags != null && displayProduct.productId != null) {
        final taggedProducts =
        global.allProducts.value
            .getProductsByTags(
          tags: displayProduct.tags!,
          productId: displayProduct.productId,
        )
            .toList();

        setState(() {
          lstProducts = taggedProducts;
        });
      } else {
        final bestSellers = global.allProducts.value.getBestSellers().toList();
        setState(() {
          lstProducts = bestSellers;
        });
      }

      // Add scroll listener if needed
      if (lstProducts.length > 5) {
        scrollController.addListener(scrollListener);
      }
    } catch (e) {
      print('Error loading related products: $e');
    } finally {
      // Ensure splash and loading screens are hidden
      global.showingSplash.value = false;
      global.siteReady.value = true;
      global.update();
    }
  }

  @override
  void initState() {
    super.initState();
    // Check if we're accessing directly via URL
    final currentPath = Uri.base.path;
    if (currentPath.startsWith('/shop/product/')) {
      final segments = currentPath.split('/');
      if (segments.length >= 3) {
        final productId = int.tryParse(segments[2]);
        if (productId != null) {
          // Start loading indicator
          setState(() {
            product = null; // Ensure we show loading state
          });

          // Set the product ID directly from URL
          global.products
              .getProductSimple(productId)
              .then((fetchedProduct) {
            if (mounted) {
              setState(() {
                global.displayProduct.value = fetchedProduct;
                product = fetchedProduct;
                fetchProducts();
              });

              // Ensure splash is hidden after product is loaded
              global.showingSplash.value = false;
              global.siteReady.value = true;
              global.update();
            }
          })
              .catchError((error) {
            print('Error fetching product: $error');
            if (mounted) {
              // Even on error, ensure splash screen is hidden
              global.showingSplash.value = false;
              global.siteReady.value = true;
              global.update();
            }
          });
          return;
        }
      }
    }

    // Normal initialization
    fetchProducts();

    // Make sure splash is hidden when this page loads from navigation
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        global.showingSplash.value = false;
        global.siteReady.value = true;
        global.update();
      }
    });

    // Add a safety timeout to ensure splash gets hidden even if other logic fails
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        global.showingSplash.value = false;
        global.siteReady.value = true;
        global.update();
      }
    });
  }

  int _selectedSkuIndex = 0;

  @override
  void dispose() {
    // Clean up scroll controller to prevent memory leaks
    if (scrollController.hasListeners) {
      scrollController.removeListener(scrollListener);
    }
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => _buildSingleProductView(context));
  }

  Widget _buildSingleProductView(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // Access simpleCart to make this reactive to cart changes
    final _ = global.simpleCart.value;

    // Use global.displayProduct directly instead of local product variable
    final displayProduct = global.displayProduct.value;

    // Handle the case where product is still loading or not available
    if (displayProduct.productId == null) {
      // Force update global state to ensure splash is hidden
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          global.showingSplash.value = false;
          global.siteReady.value = true;
          global.update();
        }
      });

      return const GalaxyPageScaffold(
        children: [
          SizedBox(height: 200),
          Center(child: CircularProgressIndicator()),
          SizedBox(height: 16),
          Center(child: Text("Loading product details...")),
        ],
      );
    }

    // Update our local product variable from global
    if (product == null || product!.productId != displayProduct.productId) {
      // This ensures our local product is updated from global state
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            product = displayProduct;
            fetchProducts();
          });

          // Ensure splash is hidden after product is loaded
          global.showingSplash.value = false;
          global.siteReady.value = true;
          global.update();
        }
      });
    }

    return GalaxyPageScaffold(
      key: ValueKey(displayProduct.productId),
      padding: EdgeInsets.only(top: YLiftConstant.totalTopNavigation + 10),
      children: [
        Column(
          children: [
            Row(
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    //minimumSize: Size(50, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    alignment: Alignment.center,
                    overlayColor: Colors.white,
                  ),
                  child: Text(
                    'SHOP',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  onPressed: () {
                    global.vroute.returnToHome();
                  },
                ),
                SizedBox(width: 4),
                Text('/ ', style: TextStyle(color: Colors.grey)),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    overlayColor: Colors.white,
                  ),
                  child: Text(
                    global.displayProduct.value.brandName ?? 'Unknown Brand',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onPressed: () {
                    // Use the new direct brand URL format
                    global.vroute.navigateTo(
                      '/shop/brand/${global.displayProduct.value.brandId}',
                    );
                  },
                ),
                SizedBox(width: 4),
                Text('/', style: TextStyle(color: Colors.grey)),
                SizedBox(width: 4),
                Text(
                  global.displayProduct.value.name,
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 80,
              child: Column(
                children: [
                  SizedBox.square(
                    dimension: 86,
                    child: ProductImageView(
                      imageUrl: displayProduct.imageUrl ?? '',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            const GapX(),
            SizedBox.square(
              dimension: 560,
              child: ProductImageView(
                imageUrl: displayProduct.imageUrl ?? '',
                fit: BoxFit.cover,
              ),
            ),
            const GapX(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isProductInCart(displayProduct) &&
                      global.isAuthenticated.isTrue) ...[
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.green,
                            size: 16,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'This product is already in your cart.',
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                          TextButton(
                            onPressed: () => global.vroute.goToCartPage(),
                            child: Text(
                              'VIEW CART',
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  if (displayProduct.caption != null)
                    Text(
                      displayProduct.caption!,
                      style: TextStyle(fontSize: 13.33),
                    ),
                  Text(displayProduct.name, style: textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text('Brand: ${displayProduct.brandName ?? 'Unknown'}'),
                  const SizedBox(height: 8),
                  // Price Text
                  if (global.isAuthenticated.isFalse)
                  // Text('Log in to see prices', style: textTheme.titleLarge?.copyWith(color: YLiftColor.orange))
                    LockPricingChip(vendorId: displayProduct.vendorId)
                  else
                    ProductDisplayText(
                      textTheme: textTheme,
                      controller: global,
                      selectedSku:
                      displayProduct.skus?.isNotEmpty == true
                          ? displayProduct.skus![_selectedSkuIndex]
                          : null,
                      quantity: _quantity,
                      isGalderma:
                      displayProduct.vendorId ==
                          YLiftConstant.galdermaVendorId ||
                          displayProduct.name.contains('RYng'),
                      vendorId: displayProduct.vendorId,
                    ),
                  if (_skuText != null) ...[
                    SizedBox(height: 8),
                    Text(
                      _skuText!,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                  if (_skuCode != null) ...[
                    SizedBox(height: 8),
                    Text(
                      'SKU ${_skuCode}',
                      style: TextStyle(
                        fontSize: 11.11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                  if (displayProduct.hasActivePromotion == true &&
                      displayProduct.promotionMessage != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      displayProduct.promotionMessage!,
                      style: TextStyle(fontSize: 13.33),
                    ),
                    Text(
                      displayProduct.promotionMessageForCart ?? '',
                      style: TextStyle(fontSize: 13.33),
                    ),
                  ],
                  const Divider(height: 32),
                  if (MerzSyringePromotion.productIds.contains(
                    displayProduct.productId,
                  )) ...[
                    Text('Promotions for this product:'),
                    Image.network(
                      MerzSyringePromotion.bannerImageUrl,
                      width: 480,
                      errorBuilder:
                          (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                    ),
                  ],
                  if (displayProduct.skus != null &&
                      displayProduct.skus!.length > 1) ...[
                    const GapY(),
                    Wrap(
                      children: List.generate(displayProduct.skus!.length, (
                          index,
                          ) {
                        SkuSimple currentSku = displayProduct.skus![index];
                        return MouseRegion(
                          onEnter: (_) {
                            if (_clicked == false) {
                              Future.delayed(
                                const Duration(milliseconds: 100),
                                    () {
                                  setSku(currentSku);
                                  _selectedSkuIndex = index;
                                  _quantity =
                                      _selectedSku?.quantityMinimum ?? 1;
                                },
                              );
                            }
                          },
                          onExit: (_) {
                            if (_clicked == false) {
                              Future.delayed(
                                const Duration(milliseconds: 100),
                                    () {
                                  setSku(
                                    _clickedSku ?? displayProduct.skus![0],
                                  );
                                  _selectedSkuIndex = _clickedSkuIndex;
                                  _quantity = _clickedSku?.quantityMinimum ?? 1;
                                },
                              );
                            }
                          },
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              setSku(currentSku);
                              setState(() {
                                _clicked = true;
                                _clickedSku = currentSku;
                                _selectedSkuIndex = index;
                                _clickedSkuIndex = index;
                                _quantity = _clickedSku?.quantityMinimum ?? 1;
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Material(
                                elevation: (_selectedSkuIndex == index) ? 2 : 0,
                                borderRadius: BorderRadius.circular(8),
                                child: Opacity(
                                  opacity:
                                  _selectedSkuIndex == index ? 1.0 : 0.4,
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: 60,
                                        width: 300,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border:
                                          (_selectedSkuIndex == index)
                                              ? Border.all(
                                            color:
                                            isSkuInCart(currentSku)
                                                ? Colors.green
                                                : Colors.black,
                                            width: 3.0,
                                          )
                                              : Border.all(
                                            color:
                                            isSkuInCart(currentSku)
                                                ? Colors.green
                                                : Colors.grey,
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                      if (isSkuInCart(currentSku))
                                        Positioned(
                                          top: 5,
                                          right: 5,
                                          child: Container(
                                            padding: EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 12,
                                            ),
                                          ),
                                        ),
                                      Positioned.fill(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 4,
                                          ),
                                          child: Row(
                                            children: [
                                              SizedBox.square(
                                                dimension: 40,
                                                child: ProductImageView(
                                                  imageUrl:
                                                  displayProduct.imageUrl ??
                                                      '',
                                                ),
                                              ),
                                              SizedBox(width: 20),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    // Text('Type: ${currentSku.skuId}', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)),
                                                    SizedBox(height: 2),
                                                    if (currentSku.attributes !=
                                                        null)
                                                      Wrap(
                                                        children: [
                                                          Text(
                                                            currentSku
                                                                .attributeName ??
                                                                '',
                                                            //_getDisplayText(currentSku).split('|')[1],
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w900,
                                                              overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                            ),
                                                            maxLines: 1,
                                                          ),
                                                        ],
                                                      ),
                                                    if (_isActive &&
                                                        global
                                                            .isAuthenticated
                                                            .isTrue) ...[
                                                      if (currentSku
                                                          .tieredPrice !=
                                                          0) ...[
                                                        Row(
                                                          children: [
                                                            Text(
                                                              (currentSku
                                                                  .tieredPrice)
                                                                  .toCurrency(),
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color:
                                                                Colors
                                                                    .orange,
                                                              ),
                                                            ),
                                                            if (currentSku
                                                                .listPrice !=
                                                                null &&
                                                                currentSku
                                                                    .tieredPrice <
                                                                    currentSku
                                                                        .listPrice!) ...[
                                                              const SizedBox(
                                                                width: 8,
                                                              ),
                                                              Text(
                                                                (currentSku
                                                                    .listPrice!)
                                                                    .toCurrency(),
                                                                style: TextStyle(
                                                                  fontSize: 11,
                                                                  color:
                                                                  Colors
                                                                      .grey,
                                                                  decoration:
                                                                  TextDecoration
                                                                      .lineThrough,
                                                                ),
                                                              ),
                                                            ],
                                                          ],
                                                        ),
                                                      ] else if (currentSku
                                                          .listPrice! >
                                                          0)
                                                        Text(
                                                          (currentSku.listPrice ??
                                                              currentSku
                                                                  .tieredPrice)
                                                              .toCurrency(),
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                            Colors.orange,
                                                          ),
                                                        ),
                                                    ],
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                  const GapY(),
                  Row(
                    children: [
                      SizedBox(
                        width: 240,
                        child: QuantityDropdown(
                          value: max(
                            _quantity,
                            _selectedSku?.quantityMinimum ?? 1,
                          ),
                          minQty: _selectedSku?.quantityMinimum ?? 1,
                          maxQty: _selectedSku?.quantityMaximum ?? 100,
                          incrementQty: _selectedSku?.quantityIncrement ?? 1,
                          isActive: _isActive && global.isAuthenticated.isTrue,
                          onChanged: (newValue) {
                            setState(() {
                              _quantity = max(
                                newValue,
                                (_selectedSku?.quantityMinimum ?? 1),
                              );
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 24),
                    ],
                  ),
                  const GapY(),
                  OverflowBar(
                    spacing: 24,
                    children: [
                      SizedBox(
                        width: 200,
                        child: GalaxyFilledButton(
                          shape: GalaxyButtonShape.stadium,
                          backgroundColor: YLiftColor.orange,
                          onPressed: allowPurchase ? buyNow : null,
                          child: const Text('Buy Now'),
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: GalaxyFilledButton(
                          shape: GalaxyButtonShape.stadium,
                          backgroundColor: Colors.black,
                          onPressed: allowPurchase ? addToCart : null,
                          child: const Text('Add to Cart'),
                        ),
                      ),
                    ],
                  ),
                  if (!allowPeptidePurchase && global.isAuthenticated.value) ... const [
                    SizedBox(height: 16),
                    NPIRequiredText(),
                  ],
                  if (errorMessage != null) ...[
                    const SizedBox(height: 24),
                    ErrorTile(
                      errorMessage: errorMessage,
                      onClose: () {
                        setState(() {
                          errorMessage = null;
                        });
                      },
                    ),

                  ],
                ],
              ),
            ),
          ],
        ),
        const GapY(),
        Text('Description', style: textTheme.titleLarge),
        Html(data: displayProduct.description ?? ''),
        const Divider(height: 64),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Similar Products for You', style: textTheme.titleLarge),
                const Spacer(),
                if (lstProducts.length > 5) ...[
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
              ],
            ),
            SizedBox(height: 8),
            SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(lstProducts.length * 2, (index) {
                  if (index.isOdd) return const SizedBox(width: 20);
                  final pproduct = lstProducts[index ~/ 2];
                  final productId = pproduct.productId ?? 638;

                  return ProductCard(
                    product: pproduct,
                    hidePrice: global.isAuthenticated.isFalse,
                    onTap: () async {
                      setState(() {
                        _selectedSku = pproduct.skus?.first;
                      });
                      global.displayProduct.value = pproduct;
                      await global.vroute.navigateSoftlyToProduct(productId);
                    },
                    onLiked: () async {
                      await global.products.likeProduct(productId);
                    },
                    onAddToCart: () {
                      if (global.isAuthenticated.isFalse) {
                        global.vroute.navigateTo('/login');
                        return;
                      }
                      showDialog(
                        context: context,
                        builder:
                            (context) => AddToCartDialog(
                          product: pproduct,
                          onSeeProduct: () {
                            global.vroute.navigateToProduct(
                              pproduct.productId!,
                            );
                          },
                          onAddToCart: (sku, quantity) async {
                            await global.basket.addToCart(
                              customerId:
                              global.user.value.profileId.toString(),
                              quantity: quantity,
                              product: "${pproduct.productId}-${sku.skuId}",
                            );
                            global.drawerController.openEndDrawer();
                          },
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
        const SizedBox(height: 80),
      ],
    );
  }
}

class _AuthenticationRequiredDialog extends StatelessWidget {
  final String productId;
  const _AuthenticationRequiredDialog({required this.productId, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Login Required'),
      content: const Text(
        'Before adding an item to a cart, please log in or sign up if you don\'t have an account',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Close'),
        ),
        FilledButton(
          onPressed: () {
            final global = Get.find<GlobalController>();
            global.vroute.navigateTo('/signup', productId: productId);
          },
          child: const Text('Sign up'),
        ),
        FilledButton(
          onPressed: () {
            final global = Get.find<GlobalController>();
            global.vroute.navigateTo('/login', productId: productId);
          },
          child: const Text('Log in'),
        ),
      ],
    );
  }
}

class ProductDisplayText extends StatelessWidget {
  final SkuSimple? selectedSku;
  final TextTheme textTheme;
  final GlobalController controller;
  final int? quantity;

  final bool isGalderma;
  final int? vendorId;

  const ProductDisplayText({
    super.key,
    required this.textTheme,
    required this.controller,
    this.selectedSku,
    this.quantity,
    this.isGalderma = false,
    this.vendorId,
  });

  // Helper method to determine prices and handle null cases
  (int, int) _getPrices() {
    if (selectedSku == null) return (0, 0);

    // Determine old (higher) price
    int oldPrice = selectedSku?.listPrice ?? 0;

    // Determine new (lower) price
    int newPrice = selectedSku?.tieredPrice ?? 0;

    // If we only have one valid price, return it as the new price
    if ((oldPrice == 0) && (newPrice != 0)) {
      return (0, newPrice);
    }
    if (newPrice == 0 && oldPrice != 0) {
      return (0, oldPrice);
    }

    // Ensure old price is always higher than new price
    if (newPrice > oldPrice) {
      final temp = oldPrice;
      oldPrice = newPrice;
      newPrice = temp;
    }

    return (oldPrice, newPrice);
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.isAuthenticated.value) {
      return Text(
        'Log in to see prices',
        style: textTheme.titleLarge?.copyWith(color: YLiftColor.orange),
      );
    }

    if (selectedSku == null) {
      return Text(
        'Select SKU to see product info',
        style: textTheme.titleLarge?.copyWith(color: YLiftColor.orange),
      );
    }

    final (oldPrice, newPrice) = _getPrices();

    if (selectedSku?.tieredPrice == null || selectedSku!.tieredPrice == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Pricing info is not available for non-providers. ',
                style: TextStyle(
                  color: YLiftColor.orange,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              GestureDetector(
                onTap: () {
                  controller.vroute.navigateTo('/training');
                },
                child: Text(
                  'Get trained to be a provider >>',
                  style: TextStyle(
                    color: YLiftColor.orange,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                    decorationColor: YLiftColor.orange,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          LockPricingChip(vendorId: vendorId),
        ],
      );
    }

    final displayPrice = (newPrice == 0) ? oldPrice : newPrice;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildPriceDisplay(
          (oldPrice * (quantity ?? 1)),
          (newPrice * (quantity ?? 1)),
          quantity,
        ),
        const SizedBox(width: 10),
        if (displayPrice / selectedSku!.numUnits! <= displayPrice) ...[
          Text(
            '(${(displayPrice / selectedSku!.numUnits!).toCurrency()} / unit)',
            style: TextStyle(fontSize: 16, color: YLiftColor.orange),
          ),
        ],
      ],
    );
  }

  Widget _buildPriceDisplay(int oldPrice, int newPrice, int? quantity) {
    quantity ??= 1;

    // If we have both prices, show discount view
    if (oldPrice != 0 && newPrice != 0 && oldPrice != newPrice) {
      final discountPercentage = DoubleConverter.getPercentage(
        newPrice,
        oldPrice,
      );
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                newPrice.toCurrency(),
                style: textTheme.titleLarge?.copyWith(color: YLiftColor.orange),
              ),
              const SizedBox(width: 16),
              if (quantity > 1) quantityWindow(quantity)!,
              const SizedBox(width: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: YLiftColor.orange),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Text(
                  'Save ${discountPercentage.toStringAsPrecision(3)}%',
                  style: TextStyle(fontSize: 11.11, color: YLiftColor.orange),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('List Price: ', style: TextStyle(color: Colors.grey)),
              Text(
                oldPrice.toCurrency(),
                style: TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      );
    }

    // Single price display
    return Row(
      children: [
        Text(
          (newPrice).toCurrency(),
          style: textTheme.titleLarge?.copyWith(color: YLiftColor.orange),
        ),
        const SizedBox(width: 16),
        if (quantity > 1) quantityWindow(quantity)!,
        const SizedBox(width: 16),
      ],
    );
  }

  Widget? quantityWindow(int quantity) {
    if (quantity > 1) {
      return Text(
        '(Quantity: $quantity | ${selectedSku!.tieredPrice.toCurrency()} / item)',
        style: textTheme.titleMedium?.copyWith(color: YLiftColor.orange),
      );
    }
    return null;
  }
}
