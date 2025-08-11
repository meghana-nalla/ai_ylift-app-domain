import 'package:YLift/core/constants/color.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/models/_clean/product.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:YLift/presentation/pages/desktop/__primary_shopping/components/banner_product_deals.dart';
import 'package:YLift/presentation/pages/desktop/__primary_shopping/components/banner_shop_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShopNonMedicalPage extends StatefulWidget {
  const ShopNonMedicalPage({super.key});

  @override
  State<ShopNonMedicalPage> createState() => _ShopNonMedicalPageState();
}

class _ShopNonMedicalPageState extends State<ShopNonMedicalPage> {
  final global = Get.find<GlobalController>();

  List<ProductSimple> getProducts() {
    return global.allProducts.value.products;
    // final skinCareProducts =
    //     global.allProducts.value.products
    //         .where((element) => element.categoryId!.contains(119))
    //         .toList();
    // final preimeProducts =
    //     global.allProducts.value.products
    //         .where((element) => element.vendorId == 27)
    //         .toList();
    // return [...preimeProducts, ...skinCareProducts];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GalaxyPageScaffold(
      backgroundColor: Colors.white,
      children: [
        Container(
          decoration: BoxDecoration(
            color: YLiftColor.beige,
            borderRadius: BorderRadius.all(Radius.circular(8)),
            border: Border.all(color: Colors.black54),
          ),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'You are currently viewing non-medical products as your account does not have any associated medical license.',
          ),
        ),
        const SizedBox(height: 32),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: ProductDealsBanner()),
            const GapX(),
            HomePageBanner(),
          ],
        ),
        const SizedBox(height: 64),
        // Text(
        //   'Products',
        //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        // ),
        // const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          children:
              getProducts().map((product) {
                return ProductCard(
                  product: product,
                  hidePrice: global.isAuthenticated.isFalse,
                  onLiked: () async {
                    await global.products.likeProduct(product.productId!);
                    setState(() {});
                  },
                  onTap: () async {
                    await global.vroute.navigateToProduct(product.productId!);
                  },
                  onAddToCart: () {
                    showDialog(
                      context: context,
                      builder:
                          (context) => AddToCartDialog(
                            product: product,
                            onSeeProduct: () async {
                              await global.vroute.navigateToProduct(
                                product.productId!,
                              );
                            },
                            onAddToCart: (sku, quantity) async {
                              if (global.isAuthenticated.isFalse) {
                                await global.vroute.navigateTo('/login');
                                return;
                              }
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
              }).toList(),
        ),
        // const CategoryListView(),
        // const SizedBox(height: 56),
        // const ProductsSection(),
        // const GapY(),
        // Bottom banner
        // SizedBox(
        //   height: 450,
        //   child: Row(
        //     children: [
        //       const GetExclusivePricingBanner(),
        //       const GapX(),
        //       Expanded(
        //         child: ClipRRect(
        //           borderRadius: const BorderRadius.all(Radius.circular(20)),
        //           child: Stack(
        //             fit: StackFit.expand,
        //             children: [
        //               Image.network(
        //                 ImageRepository.getBannerImage(
        //                   'd5520053-5684-4b8d-b37a-ba2f3af7e302',
        //                 ),
        //                 fit: BoxFit.cover,
        //               ),
        //               Positioned(
        //                 top: 64,
        //                 left: 64,
        //                 child: Column(
        //                   crossAxisAlignment: CrossAxisAlignment.start,
        //                   children: [
        //                     Text(
        //                       'Hands-on /\nVirtual Trainings',
        //                       style: TextStyle(
        //                         color: Colors.white,
        //                         fontSize: 32,
        //                       ),
        //                     ),
        //                     const SizedBox(height: 32),
        //                     Text(
        //                       '2-day trainings on 3-5 LIVE patients.\nOur training faculties will travel to\nyour location',
        //                       style: TextStyle(color: Colors.white),
        //                     ),
        //                     const SizedBox(height: 48),
        //                     SizedBox(
        //                       width: 180,
        //                       child: FilledButton(
        //                         style: FilledButton.styleFrom(
        //                           shape: const StadiumBorder(),
        //                           backgroundColor: const Color(0xFFFF8C68),
        //                         ),
        //                         onPressed: () {
        //                           global.vroute.navigateTo('/training');
        //                         },
        //                         child: const Text('Register Now'),
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        const SizedBox(height: 64),
      ],
    );
  }
}
