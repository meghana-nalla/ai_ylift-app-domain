import 'package:YLift/core/constants/index.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/core/repositories/image_repository.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:galaxy_ui/galaxy_ui.dart';

final _promotionData = <String, dynamic>{
  'imageUrl': ImageRepository.getBannerImage('f9c76212-7bbc-4c1c-abe0-3584f81a04a5'),
  'title': 'Premium Perks Promo',
  'info':
      'Get \$50 patient coupon codes for each qualifying order! Select one of the qualifying option for this order:\n\n'
          '20 Restylanes, 20 Dyports, 10 Sculptra\n'
          '20 Restylanes, 20 Dyports, 10 Sculptra\n'
          '20 Restylanes, 20 Dyports, 10 Sculptra\n'
          '20 Restylanes, 20 Dyports, 10 Sculptra\n',
  'brandId': [81, 83, 82],
  'brandName': 'Galderma',
  'expirationDate': DateTime(2025, 1, 30),
};

class IndividualPromotionPage extends StatefulWidget {
  const IndividualPromotionPage({super.key});

  @override
  State<IndividualPromotionPage> createState() => _IndividualPromotionPageState();
}

class _IndividualPromotionPageState extends State<IndividualPromotionPage> {
  final global = Get.find<GlobalController>();
  late List<ProductSimple> products;

  late Future<List<ProductSimple>> _promotionProducts;

  @override
  void initState() {
    // _promotionProducts = global.products.getProducts(brandIds: [_promotionData['brandId']]);
    _promotionProducts = x();
    super.initState();
  }

  Future<List<ProductSimple>> x() async {
    return global.allProducts.value.getProductsByBrandIds(brandIds: _promotionData['brandId']);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GalaxyPageScaffold(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 16),
        SizedBox(
          height: 320,
          width: 1120,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    _promotionData['imageUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 32),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CountdownDisplay(
                      expirationDate: _promotionData['expirationDate'],
                      withBorder: true,
                      size: 12,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _promotionData['title'],
                      style: GoogleFonts.playfairDisplay(fontSize: 39),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _promotionData['info'],
                      style: TextStyle(fontSize: 13.33, color: Color(0xFF616161)),
                    ),
                    const Spacer(),
                    const Divider(color: Colors.black, thickness: 3),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(height: 96),
        FutureBuilder(
          future: _promotionProducts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else {
              final products = snapshot.data;
              if (products == null || products.isEmpty) {
                return Text('There are no products');
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${products.length} Products', style: TextStyle(color: Color(0xFF787878))),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 24,
                    runSpacing: 16,
                    children: products.map(
                      (product) {
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
                    ).toList(),
                  ),
                ],
              );
            }
          },
        ),
      ],
    );
  }
}
