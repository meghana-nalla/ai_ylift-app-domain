import 'dart:async';

import 'package:YLift/core/constants/color.dart';
import 'package:YLift/core/controllers/z-index_export.dart';
import 'package:YLift/models/simple/home_promotion_banner_data.dart';
import 'package:YLift/presentation/pages/desktop/__primary_shopping/components/video_banner.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

const _enableSlide = true;

class HomePageBanner extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;

  const HomePageBanner({
    super.key,
    this.width = 910.0,
    this.height = 512.25,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
  });

  @override
  State<HomePageBanner> createState() => _HomePageBannerState();
}

class _HomePageBannerState extends State<HomePageBanner> {
  final global = Get.find<GlobalController>();

  final pageController = PageController();
  int _currentIndex = 0;

  VideoPlayerController? _videoController;

  late List<HomePromotionBannerData> promotions;

  void initializeVideo(String videoUrl) async {
    if (_videoController != null) {
      await _videoController?.dispose();
      _videoController = null;
    }
    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(videoUrl),
    );
    await _videoController!.initialize();
    await _videoController!.setVolume(0.0);
    await _videoController!.setLooping(true);
    await _videoController!.play();
    setState(() {});
  }

  Timer? _autoScrollTimer;
  double _opacity = 1.0;

  void goToBanner(int index) async {
    if (index >= promotions.length) {
      fadeToFirst();
      return;
    }
    setState(() {
      _currentIndex = index;
    });

    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
    );

    final promotion = promotions[index];
    if (promotion.isVideo) initializeVideo(promotion.imageUrl);
  }

  void fadeToFirst() async {
    setState(() {
      _opacity = 0.0;
    });
    await Future.delayed(Duration(milliseconds: 150));
    pageController.jumpToPage(0);
    setState(() {
      _currentIndex = 0;
      _opacity = 1.0;
    });
  }

  void startAutoScroll() {
    if (!_enableSlide) return;
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      goToBanner(_currentIndex + 1);
    });
    debugPrint('HomePageBanner auto scroll has been started');
  }

  void pauseAutoScroll() {
    _autoScrollTimer?.cancel();
    debugPrint('HomePageBanner auto scroll has been stopped');
  }

  void goToPromotion(HomePromotionBannerData promotion) {
    if (global.isMobile.value) return;

    if (promotion.vendorIds != null) {
      final brands = global.brands.where(
        (brand) => brand.vendorIds.any(
          (vendorId) => promotion.vendorIds!.contains(vendorId),
        ),
      );
      final brandIds = brands.map((e) => e.brandId!);
      global.selectedBrandId.value = 'brand=${brandIds.join(',')}';
      global.vroute.navigateTo('/shop/all');
    }
    if (promotion.brandIds != null) {
      // if (promotion.brandIds!.contains(81)) {
      //   showDialog(
      //     context: context,
      //     builder: (context) => GaldermaRefreshYourBeautyPromotionDialog(),
      //   );
      //   return;
      // }
      global.selectedBrandId.value = 'brand=${promotion.brandIds!.join(',')}';
      global.vroute.navigateTo('/shop/all');
    }
    if (promotion.categoryIds != null) {
      global.selectedBrandId.value = 'brand=${promotion.brandIds!.join(',')}';
      global.vroute.navigateTo('/shop/all');
    }
    if (promotion.isTraining) {
      global.vroute.navigateTo('/training');
    }
    if (promotion.isEvents) {
      global.vroute.navigateTo('/events');
    }
  }

  @override
  void initState() {
    super.initState();
    promotions = HomePromotionBannerData.getList();
    if (promotions.isNotEmpty && promotions.first.isVideo) {
      initializeVideo(promotions.first.imageUrl);
    }
    startAutoScroll();
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: widget.borderRadius,
          child: SizedBox(
            width: widget.width,
            height: widget.height,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _opacity,
              child: PageView(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                children:
                    promotions.map((promotion) {
                      // When we have the promotions working,
                      // the list of promotions should replace [_bannerImageUrls]
                      if (promotion.isVideo) {
                        return VideoBanner(
                          controller: _videoController,
                          onTap: () => goToPromotion(promotion),
                          thumbnailUrl: promotion.imageUrl,
                        );
                      }

                      return MouseRegion(
                        cursor:
                            promotion.hasNavigation
                                ? SystemMouseCursors.click
                                : MouseCursor.defer,
                        onEnter: (event) => pauseAutoScroll(),
                        onExit: (event) => startAutoScroll(),
                        child: GestureDetector(
                          onTap: () => goToPromotion(promotion),
                          child: Image.network(
                            promotion.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) =>
                                    Image.asset('msc/images/ys_logo.png'),
                          ),
                          onLongPress: () => pauseAutoScroll(),
                          onLongPressUp: () => startAutoScroll(),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(promotions.length * 2 - 1, (index) {
            if (index.isOdd) return const SizedBox(width: 8);
            final imageIndex = index ~/ 2;
            final isSelected = _currentIndex == imageIndex;
            return _Indicator(
              indicatorSize: global.isMobile.value ? 6 : 12,
              isSelected: isSelected,
              onTap: () {
                pauseAutoScroll();
                startAutoScroll();
                goToBanner(imageIndex);
              },
            );
          }),
        ),
      ],
    );
  }
}

class _Indicator extends StatelessWidget {
  final bool isSelected;
  final void Function()? onTap;
  final double indicatorSize;

  const _Indicator({
    this.isSelected = false,
    this.indicatorSize = 20, // increased from 15
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget indicator;

    if (isSelected) {
      indicator = Container(
        width: indicatorSize + 10, // increased width from +8 to +10
        height: indicatorSize,
        decoration: ShapeDecoration(
          shape: StadiumBorder(),
          color: YLiftColor.orange,
        ),
      );
    } else {
      indicator = Container(
        width: indicatorSize,
        height: indicatorSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: YLiftColor.grey3, width: 1.5),
          color: YLiftColor.grey3,
        ),
      );
    }

    return GestureDetector(onTap: onTap, child: indicator);
  }
}


class HomePromotionBannerDialog extends StatelessWidget {
  final String imageUrl;
  const HomePromotionBannerDialog({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final global = Get.find<GlobalController>();

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 40),
        child: SizedBox(
          width: 800,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.lock, size: 19),
                  Text(
                    'Sign in to unlock or view without access',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.clear),
                    color: Color(0xFFBBBBBB),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(imageUrl, fit: BoxFit.cover),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          side: BorderSide(color: YLiftColor.grey3),
                        ),
                        onPressed: () {
                          global.vroute.navigateTo('/login');
                        },
                        child: const Text('Login / Sign up'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: RoundedFilledButton(
                        onPressed: () {
                          global.vroute.navigateTo('/promotion');
                        },
                        child: const Text('View Promotion'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Promotions for Restylane, Dysport, and Sculptra require training registrations.',
                    style: TextStyle(fontSize: 13.33),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      global.vroute.navigateTo('/training');
                    },
                    child: Text(
                      'Register Now >>',
                      style: TextStyle(
                        fontSize: 13.33,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
