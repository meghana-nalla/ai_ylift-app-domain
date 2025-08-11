import 'package:YLift/core/controllers/z-index_export.dart';
import 'package:YLift/core/repositories/image_repository.dart';
import 'package:YLift/hardcodes/promotions/summer_glow_july_15/summer_glow_promotion.dart';
import 'package:YLift/models/simple/home_promotion_banner_data.dart';
import 'package:YLift/models/simple/z-index_export.dart';
import 'package:YLift/presentation/components/_complex/desktop_view/page_scaffold.dart';
import 'package:YLift/presentation/pages/desktop/__primary_shopping/components/video_banner.dart';
import 'package:YLift/presentation/pages/desktop/cart/components/merz_promotion_dialog.dart';
import 'package:YLift/presentation/pages/desktop/promotions/components/dial_in_promotion.dart';
import 'package:YLift/presentation/pages/desktop/promotions/components/dialogs/galderma_refresh_your_beauty_promotion_dialog.dart';
import 'package:YLift/presentation/pages/desktop/promotions/components/no_promotion_banner.dart';
import 'package:YLift/presentation/pages/desktop/promotions/components/single_promotion_banner.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/core/controllers/promotions/index.dart';

final _restalyneImageUrl = ImageRepository.getBannerImage(
  '3b904714-865e-40d6-b9dd-fdca0065c5ed',
);
final _sculptraImageUrl = ImageRepository.getBannerImage(
  'f7d37774-4de0-45f0-92d8-6ebfb29e727e',
);
final _jeaveauImageUrl = ImageRepository.getBannerImage(
  '923a0301-54f5-46bf-8dc6-5683ad79683a',
);

class DesktopPromotionPage extends StatefulWidget {
  const DesktopPromotionPage({super.key});

  @override
  State<DesktopPromotionPage> createState() => _DesktopPromotionPageState();
}

class _DesktopPromotionPageState extends State<DesktopPromotionPage> {
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
      // Handle error
      print('Error fetching promotions: $e');
    }
  }

  @override
  void initState() {
    loadPromotions();
    super.initState();
  }

  // THIS IS FOR TESTING PURPOSES, THIS SHOULD BE REMOVED LATER IN PRODUCTION!
  // THE PURPOSE OF THIS IS TO SHOW IF THERE IS NO PROMOTIONS AT ALL
  bool hasPromotion = true;

  @override
  Widget build(BuildContext context) {
    return GalaxyPageScaffold(
      children: [
        if (hasPromotion) ...[
          Column(
            spacing: 32,
            children:
                HomePromotionBannerData.activePromotions.map(
                  (promotion) {
                    final showCountdown = promotion.id == 'dial-in-discount';
                    if (showCountdown) return const DialInPromotion();

                    if (promotion.isVideo) {
                      return SizedBox(
                        width: 1080,
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          //child: VideoBannerByUrl(videoUrl: SummerGlowPromotion.videoUrl),
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
                  },
                ).toList(),
          ),

          // Center(
          //   child: SinglePromotionBanner(
          //     imageUrl: MerzSyringePromotion.bannerImageUrl,
          //     onTap: () {
          //       final extra = 'brand=${MerzSyringePromotion.brandId}';
          //       global.selectedBrandId.value = extra;
          //       global.vroute.navigateTo(
          //         '/shop/brand/${MerzSyringePromotion.brandId}',
          //       );
          //     },
          //   ),
          // ),
          const SizedBox(height: 32),
          SizedBox(
            height: 752,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      global.selectedBrandId.value = 'brand=81';
                      global.vroute.navigateTo('/shop/brand/81');
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          _restalyneImageUrl,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          bottom: 64,
                          child: Column(
                            children: [
                              Text(
                                'Enjoy Exclusive Pricing on the',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                'RESTYLANE COLLECTION',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 33,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: 200,
                                child: RoundedFilledButton(
                                  onPressed: () {
                                    global.selectedBrandId.value = 'brand=81';
                                    global.vroute.navigateTo('/shop/brand/81');
                                  },
                                  color: Colors.white,
                                  child: const Text(
                                    'SHOP NOW',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 32),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        global.selectedBrandId.value = 'brand=83';
                        global.vroute.navigateTo('/shop/brand/83');
                      },
                      child: SizedBox.square(
                        dimension: 360,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              _sculptraImageUrl,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              left: 24,
                              bottom: 48,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'SHOP SCULPTRA',
                                    style: TextStyle(
                                      fontSize: 27,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'And Other Neurotoxins',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    GestureDetector(
                      onTap: () {
                        global.selectedBrandId.value = 'brand=84';
                        global.vroute.navigateTo('/shop/brand/84');
                      },
                      child: SizedBox.square(
                        dimension: 360,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              _jeaveauImageUrl,
                              fit: BoxFit.fitHeight,
                            ),
                            Positioned(
                              left: 24,
                              bottom: 48,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'EXPLORE JEAVEAU',
                                    style: TextStyle(
                                      fontSize: 27,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'From Evolus',
                                    style: TextStyle(color: Colors.white),
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
              ],
            ),
          ),
        ] else ...[
          Center(child: NoPromotionBanner()),
          const SizedBox(height: 64),
          Text(
            'Our featured collections and products',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 752,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      global.selectedBrandId.value = 'brand=81';
                      global.vroute.navigateTo('/shop/brand/81');
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          _restalyneImageUrl,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          bottom: 64,
                          child: Column(
                            children: [
                              Text(
                                'Enjoy Exclusive Pricing on the',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                'RESTYLANE COLLECTION',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 33,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: 200,
                                child: RoundedFilledButton(
                                  onPressed: () {
                                    global.selectedBrandId.value = 'brand=81';
                                    global.vroute.navigateTo('/shop/brand/81');
                                  },
                                  color: Colors.white,
                                  child: const Text(
                                    'SHOP NOW',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 32),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        global.selectedBrandId.value = 'brand=83';
                        global.vroute.navigateTo('/shop/brand/83');
                      },
                      child: SizedBox.square(
                        dimension: 360,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              _sculptraImageUrl,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              left: 24,
                              bottom: 48,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'SHOP SCULPTRA',
                                    style: TextStyle(
                                      fontSize: 27,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'And Other Neurotoxins',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    GestureDetector(
                      onTap: () {
                        global.selectedBrandId.value = 'brand=84';
                        global.vroute.navigateTo('/shop/brand/84');
                      },
                      child: SizedBox.square(
                        dimension: 360,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              _jeaveauImageUrl,
                              fit: BoxFit.fitHeight,
                            ),
                            Positioned(
                              left: 24,
                              bottom: 48,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'EXPLORE JEAVEAU',
                                    style: TextStyle(
                                      fontSize: 27,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'From Evolus',
                                    style: TextStyle(color: Colors.white),
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
              ],
            ),
          ),
        ],
        const SizedBox(height: 64),
      ],
    );
  }
}
