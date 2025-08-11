import 'package:YLift/core/constants/color.dart';
import 'package:YLift/presentation/components/mobile_footer.dart';
import 'package:YLift/presentation/pages/desktop/__primary_shopping/components/banner_shop_page.dart';
import 'package:YLift/presentation/pages/desktop/__primary_shopping/components/single_list_product_category.dart';
import 'package:YLift/presentation/pages/mobile/home/components/featured_category_list.dart';
import 'package:flutter/material.dart';
import 'package:YLift/core/controllers/z-index_export.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:YLift/presentation/components/navigation/search_bar/ylift_mobile_search_bar.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = Get.find<GlobalController>();

  @override
  void initState() {
    super.initState();
    //loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: YLSLogo(isMobile: true),
      //   backgroundColor: Colors.white,
      // ),
      // appBar: const YLiftAppBar(),
      extendBody: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // YLiftMobileSearchBar(),
            // SizedBox(height: 16),
            HomePageBanner(
              height: 240,
              width: MediaQuery.of(context).size.width,
              borderRadius: BorderRadius.zero,
            ),
            // TopBanner(),
            SizedBox(height: 8),
            FeaturedCategoryList(),
            SizedBox(height: 16),
            FeaturedProductsSlider(
              products:
                  (controller.allProducts.value.products.length > 10)
                      ? (controller.allProducts.value.products
                          .take(12)
                          .toList())
                      : (controller.allProducts.value.products),
              onSeeAll: () {
                // controller.vroute.navigateQuickLinksTap(4); // featured products
                controller.vroute.navigateTo('/shop/all');
              },
              onProductSelect: controller.products.select,
            ),
            SizedBox(height: 8),
            if (controller.promotions.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Promotions',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    TextButton(
                      onPressed: () {
                        controller.vroute.navigateQuickLinksTap(
                          5,
                        ); // promotions
                      },
                      child: Text('See All'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              Obx(() {
                return ImageCarousel(
                  items:
                      controller.promotions
                          .map(
                            (promotion) => {
                              'imageUrl': promotion.imageUrl,
                              'link': promotion.destinationPath,
                            },
                          )
                          .toList(),
                );
              }),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            ],
            // RegisterPromotionCard(),
            SizedBox(height: 32.0),
            Column(
              children: List.generate(controller.category.categoryId.length, (
                index,
              ) {
                return Column(
                  children: [
                    ProductsByCategoryListView(
                      title: controller.category.categoryName[index],
                      categoryId: controller.category.categoryId[index],
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              }),
            ),

            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GalaxyFilledButton(
                backgroundColor: YLiftColor.orange,
                isExpanded: true,
                onPressed: () {
                  controller.vroute.navigateTo('/shop/all');
                },
                child: Text('Shop All Products'),
              ),
            ),
            const SizedBox(height: 16),
            const MobileFooter(),
          ],
        ),
      ),
    );
  }
}
