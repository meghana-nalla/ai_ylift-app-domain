import 'package:YLift/core/controllers/z-index_export.dart';
import 'package:YLift/core/repositories/image_repository.dart';
import 'package:YLift/hardcodes/promotions/summer_glow_july_15/summer_glow_promotion.dart';
import 'package:YLift/models/simple/home_promotion_banner_data.dart';
import 'package:YLift/models/simple/z-index_export.dart';
import 'package:YLift/presentation/components/_complex/desktop_view/page_scaffold.dart';
import 'package:YLift/presentation/components/mobile_footer.dart';
import 'package:YLift/presentation/pages/desktop/__primary_shopping/components/video_banner.dart';
import 'package:YLift/presentation/pages/desktop/promotions/components/no_promotion_banner.dart';
import 'package:YLift/presentation/pages/desktop/promotions/components/single_promotion_banner.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:get/get.dart';

final _restalyneImageUrl = ImageRepository.getBannerImage(
  '3b904714-865e-40d6-b9dd-fdca0065c5ed',
);
final _sculptraImageUrl = ImageRepository.getBannerImage(
  'f7d37774-4de0-45f0-92d8-6ebfb29e727e',
);
final _jeaveauImageUrl = ImageRepository.getBannerImage(
  '923a0301-54f5-46bf-8dc6-5683ad79683a',
);

class MobilePromotionPage extends StatefulWidget {
  const MobilePromotionPage({super.key});

  @override
  State<MobilePromotionPage> createState() => _MobilePromotionPageState();
}

class _MobilePromotionPageState extends State<MobilePromotionPage> {
  final global = Get.find<GlobalController>();
  final PromotionsController _promotionsController = Get.put(
    PromotionsController(),
  );
  List<PromotionSimple>? _promotions;
  bool get isLoading => _promotions == null;

  void loadPromotions() async {
    try {
      final promotions = await _promotionsController.fetchActivePromotions();
      setState(() {
        _promotions = promotions;
      });
    } catch (e) {
      print('Error fetching promotions: $e');
    }
  }

  @override
  void initState() {
    loadPromotions();
    super.initState();
  }

  bool hasPromotion = true;

  @override
  Widget build(BuildContext context) {
    return GalaxyPageScaffold(
      padding: EdgeInsets.zero,
      showGalaxyFooter: false,
      children: [
        if (hasPromotion) ...[
          Column(
            spacing: 16,
            children:
                HomePromotionBannerData.activePromotions.map((promotion) {
                  if (promotion.isVideo) {
                    return AspectRatio(
                      aspectRatio: 16 / 9,
                      child: VideoBannerByUrl(
                        videoUrl: '',
                      ),
                    );
                  }

                  return Center(
                    child: SinglePromotionBanner(
                      imageUrl: promotion.imageUrl,
                      onTap: () {
                        if (promotion.vendorIds != null) {
                          final brands = global.brands.where(
                            (brand) => brand.vendorIds.any(
                              (vendorId) =>
                                  promotion.vendorIds!.contains(vendorId),
                            ),
                          );
                          final brandIds =
                              brands.map((e) => e.brandId!).toList();
                          global.selectedBrandId.value =
                              'brand=${brandIds.join(',')}';
                          global.vroute.navigateTo('/shop/all');
                          return;
                        }
                        if (promotion.brandIds != null) {
                          global.selectedBrandId.value =
                              'brand=${promotion.brandIds!.join(',')}';
                          global.vroute.navigateTo('/shop/all');
                          return;
                        }
                        if (promotion.isTraining) {
                          global.vroute.navigateTo('/training');
                          return;
                        }
                        if (promotion.isEvents) {
                          global.vroute.navigateTo('/events');
                          return;
                        }
                      },
                    ),
                  );
                }).toList(),
          ),
          const SizedBox(height: 32),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Explore our featured products',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 220,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildCarouselItem(
                      label: 'RESTYLANE',
                      imageUrl: _restalyneImageUrl,
                      onTap: () {
                        global.selectedBrandId.value = 'brand=81';
                        global.vroute.navigateTo('/shop/brand/81');
                      },
                    ),
                    _buildCarouselItem(
                      label: 'SCULPTRA',
                      imageUrl: _sculptraImageUrl,
                      onTap: () {
                        global.selectedBrandId.value = 'brand=83';
                        global.vroute.navigateTo('/shop/brand/83');
                      },
                    ),
                    _buildCarouselItem(
                      label: 'JUVEAU',
                      imageUrl: _jeaveauImageUrl,
                      onTap: () {
                        global.selectedBrandId.value = 'brand=84';
                        global.vroute.navigateTo('/shop/brand/84');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ] else ...[
          const Center(child: NoPromotionBanner()),
          const SizedBox(height: 64),
        ],
        const MobileFooter(),
      ],
    );
  }

  Widget _buildCarouselItem({
    required String label,
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        width: 150,
        child: Column(
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFE2E2E2)),
              ),
              child: const Text(
                'DISCOVER',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF343434),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
