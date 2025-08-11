import 'package:YLift/core/constants/color.dart';
import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/core/constants/hardcoded_id.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/core/repositories/image_repository.dart';
import 'package:YLift/models/simple/home_promotion_banner_data.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:YLift/presentation/pages/desktop/__primary_courses/components/events_checkout/event_checkout_dialog.dart';
import 'package:YLift/presentation/pages/desktop/__primary_courses/components/video_checkout/video_checkout_dialog.dart';
import 'package:YLift/presentation/pages/desktop/promotions/components/dial_in_promotion.dart';
import 'components/quick_reorder_section.dart';
import 'components/single_list_featured_category.dart';
import 'components/banner_exclusive_pricing.dart';
import 'components/banner_shop_page.dart';
import 'components/banner_product_deals.dart';
import 'components/section_products.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'components/single_list_product_category.dart';
import 'package:galaxy_ui/galaxy_ui.dart';

/// This is the home page of the app.
/// Here the user lands in the route '/'
class ShopPage extends StatefulWidget {
  const ShopPage({super.key});
  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final global = Get.find<GlobalController>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (global.isAuthenticated.isTrue) checkAuthorize();
  }

  Future<void> checkAuthorize() async {
    if (!global.user.value.hasCardPayment) {
      await global.vroute.setInnerRedirect('/require_card_payment');
      final redirectPath = await global.vroute.getInnerRedirect();
      global.vroute.navigateTo(redirectPath!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dialInPromotion = HomePromotionBannerData.list.firstWhereOrNull(
      (element) => element.id == 'dial-in-discount',
    );

    return (_isLoading)
        ? Container()
        : GalaxyPageScaffold(
          backgroundColor: Colors.white,
          padding: EdgeInsets.only(top: YLiftConstant.totalTopNavigation + 8),
          children: [
            if (dialInPromotion != null && dialInPromotion.isOngoing)
              DialInPromotion()
            else ...[
              if (global.isAuthenticated.isTrue) ...[
                QuickReorderSection(),
                const SizedBox(height: 16),
              ],
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: ProductDealsBanner()),
                  const GapX(),
                  HomePageBanner(),
                ],
              ),
            ],

            const SizedBox(height: 32),
            const CategoryListView(),
            const SizedBox(height: 56),
            const ProductsSection(),
            const GapY(),
            // Bottom banner
            SizedBox(
              height: 450,
              child: Row(
                children: [
                  const GetExclusivePricingBanner(),
                  const GapX(),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            ImageRepository.getBannerImage(
                              'd5520053-5684-4b8d-b37a-ba2f3af7e302',
                            ),
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            top: 64,
                            left: 64,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hands-on /\nVirtual Trainings',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                  ),
                                ),
                                const SizedBox(height: 32),
                                Text(
                                  '2-day trainings on 3-5 LIVE patients.\nOur training faculties will travel to\nyour location',
                                  style: TextStyle(color: Colors.white),
                                ),
                                const SizedBox(height: 48),
                                SizedBox(
                                  width: 180,
                                  child: FilledButton(
                                    style: FilledButton.styleFrom(
                                      shape: const StadiumBorder(),
                                      backgroundColor: const Color(0xFFFF8C68),
                                    ),
                                    onPressed:
                                        () => global.vroute.navigateTo(
                                          '/training',
                                        ),
                                    child: const Text('Register Now'),
                                  ),
                                ),
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
            const SizedBox(height: 56),
            Column(
              children: List.generate(global.category.categoryId.length, (
                index,
              ) {
                return Column(
                  children: [
                    ProductsByCategoryListView(
                      title: global.category.categoryName[index],
                      categoryId: global.category.categoryId[index],
                    ),
                    const SizedBox(height: 24),
                  ],
                );
              }),
            ),
            const GapY(),
            Center(
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: YLiftColor.orange,
                ),
                onPressed:
                    () async => await global.vroute.navigateTo(
                      '/shop/all',
                      extra: "default",
                    ),
                iconAlignment: IconAlignment.end,
                icon: const Icon(Icons.arrow_right_alt),
                label: const Text('View All Products'),
              ),
            ),
            GapY(factor: 2),
          ],
        );
  }
}
