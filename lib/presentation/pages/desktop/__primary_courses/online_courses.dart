import 'package:YLift/core/constants/hardcoded_id.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/presentation/components/_complex/desktop_view/page_scaffold.dart';
import 'package:YLift/presentation/components/_complex/dialogs/subscription_payment_dialog/subscription_payment_dialog.dart';
import 'package:YLift/presentation/pages/desktop/__primary_courses/components/discover_unlock_training_panel.dart';
import 'package:YLift/presentation/pages/desktop/__primary_courses/components/events_checkout/event_checkout_dialog.dart';
import 'package:YLift/presentation/pages/desktop/__primary_courses/components/online_courses/my_library_section.dart';
import 'package:YLift/presentation/pages/desktop/__primary_courses/components/video_checkout/dynamic_checkout_dialog.dart';
import 'package:YLift/presentation/pages/desktop/__primary_courses/components/video_checkout/video_checkout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:get/get.dart';
import 'package:web/web.dart' as web;

class OnlineCourses extends StatefulWidget {
  static final List<Map<String, dynamic>> _courseItems = [
    {
      'title': 'Brazilian HDR Technique',
      'doctor': 'Dr. Zoe Flor',
      'specialty': 'Injectable Technique',
      'imageUrl':
          'https://media.stage.ylift.app/api/optimized/variant/image/file/7fb98d6a-e90a-4cbf-b8cc-058137622532',
      'chapters': [
        //   'Chapter 1: Introduction',
        //   'Chapter 2: Patient Assessment',
        //   'Chapter 3: Sterilizing & Numbing',
        //   'Chapter 4: Injection Technique',
        //   'Chapter 5: Post-Procedure Care',
      ],
      'promoText': 'Free with 10-box Radiesse Purchase',
    },
  ];

  const OnlineCourses({super.key});

  @override
  State<OnlineCourses> createState() => _OnlineCoursesState();
}

class _OnlineCoursesState extends State<OnlineCourses> {
  final List<String> tabs = ['Trending'];

  final _global = Get.find<GlobalController>();

  // localStorage keys
  static const String _pendingVideoDialogKey = 'pendingVideoDialog';

  @override
  void initState() {
    super.initState();
    // check for pending dialog actions when this screen loads
    _checkPendingVideoDialog();
  }

  // save video dialog action to localStorage
  void _saveVideoDialogAction(String videoId) {
    web.window.localStorage.setItem(_pendingVideoDialogKey, videoId);
  }

  // check and execute pending video dialog actions
  Future<void> _checkPendingVideoDialog() async {
    // only process if user is authenticated
    if (_global.isAuthenticated.isTrue) {
      final pendingVideoId = web.window.localStorage.getItem(
        _pendingVideoDialogKey,
      );

      // if we have a pending video dialog to show
      if (pendingVideoId != null && pendingVideoId.isNotEmpty) {
        // clear the pending action first to prevent loops
        web.window.localStorage.removeItem(_pendingVideoDialogKey);

        // find the video product by ID
        final video = _global.allVirtualProducts.value.tradingProducts
            .firstWhereOrNull((product) => product.id == pendingVideoId);

        // if video exists, check if it's already in cart
        if (video != null) {
          // Check if already in cart
          final alreadyInCart = _global.simpleCart.value.tradeGoods.any(
            (element) => element.goodsTradingId == video.id,
          );

          // If already in cart, navigate to cart
          if (alreadyInCart) {
            // Small delay to ensure the page is fully loaded
            Future.delayed(Duration(milliseconds: 300), () {
              _global.vroute.goToCartPage();
            });
          } else {
            // Show dialog to add to cart
            Future.delayed(Duration(milliseconds: 300), () {

              showDialog(
                barrierDismissible: false,
                context: context,
                builder:
                    (context) => RadiesseVideoCheckoutDialog(product: video),
              );
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use Obx to make the UI reactive to cart changes
    return Obx(
      () => GalaxyPageScaffold(
        backgroundColor: Colors.white,
        children: [
          SizedBox(height: 20),
          // -- first section is our product with banner -- //
          SizedBox(
            height: 520,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 440,
                  height: 520,
                  child: DiscoverUnlockTrainingPanel(),
                ),
                // SingleVirtualProductCard(),
                SizedBox(width: 40),
                Expanded(
                  child: SizedBox(
                    height: 520,
                    child: GalaxyVideoCourseBannerCarousel(
                      items: OnlineCourses._courseItems,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // -- next section is our my content list -- //
          MyVideoLibrarySection(),
          // -- next section is our virtual products list -- //
          const SizedBox(height: 54),
          buildVirtualProductsList(),
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget buildVirtualProductsList() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Trending For You',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            // ElevatedButton(
            //   onPressed: () {},
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.blue,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(20),
            //     ),
            //   ),
            //   child: Row(
            //     mainAxisSize: MainAxisSize.min,
            //     children: const [
            //       Text('Browse All', style: TextStyle(color: Colors.white)),
            //       SizedBox(width: 4),
            //       Icon(Icons.arrow_forward, size: 16, color: Colors.white),
            //     ],
            //   ),
            // ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 400,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
          ),
          itemCount: _global.allVirtualProducts.value.tradingProducts.length,
          itemBuilder: (context, index) {
            final video =
                _global.allVirtualProducts.value.tradingProducts[index];

            final products = _global.allProducts.value.getByIds(
              video.tradingMetadata?.productIds ?? [],
            );
            final brandName = products.firstOrNull?.brandName ?? 'Brand';

            // Check if this video is already in the cart
            final alreadyInCart = _global.simpleCart.value.tradeGoods.any(
              (element) => element.goodsTradingId == video.id,
            );
            final alreadyHave =
                _global.user.value.virtualContent?.any((element) {
                  return element.virtualProductId == video.id ||
                      element.bundleProductId == video.id;
                }) ??
                false;

            CourseTag? tag;
            if (video.metadata['type'] == 'TRAINING') {
              tag = CourseTag.video;
            } else if (video.metadata['type'] == 'EVENTS_PHYSICAL') {
              tag = CourseTag.handsOn;
            }
            final alreadyIncluded =
                _global.user.value.hasVirtualContentById(
                  HardcodedId.eventTwoDay,
                ) &&
                video.metadata['type'] == 'EVENTS_PHYSICAL';

            final previewVideoUrl = video.metadata['previewVideoUrl'] ?? '';

            return VideoCourseCard(
              thumbnailUrl: video.imageUrl,
              title: video.name,
              authorName: video.metadata['authorName'] ?? '',
              chapters: video.metadata['chapterCount'] ?? '',
              previewVideoUrl:
                  previewVideoUrl.isNotEmpty ? previewVideoUrl : null,
              tag: tag,
              onTap: () async {
                // If the video is a Radiesse video, show the specific dialog
                // showDialog(
                //   context: context,
                //   builder: (context) => SubscriptionPaymentDialog(),
                // );
                // showDialog(
                //   context: context,
                //   builder: (context) => VideoCheckoutDialog(product: video),
                // );
                // await _global.basket.addVirtualItemToCart(video.id);
                // ScaffoldMessenger.of(
                //   context,
                // ).showSnackBar(SnackBar(content: Text('Video is added')));
              },
              unlockMessage:
                  alreadyHave
                      ? 'Already purchased'
                      : alreadyIncluded
                      ? 'Already included in 2 days ticket'
                      : alreadyInCart
                      ? 'Already in Cart - View Cart'
                      : (video.tradingMetadata != null
                          ? 'Unlock with ${video.tradingMetadata!.requirementQuantity} $brandName Purchase'
                          : null),
              onUnlockMessageTap: () {
                if (alreadyHave || alreadyIncluded) return;
                // If item is already in cart, navigate to cart
                if (alreadyInCart) {
                  _global.vroute.goToCartPage();
                  return;
                }

                // Check if the user is logged in
                if (_global.isAuthenticated.isFalse) {
                  // save action to localStorage to run after login
                  _saveVideoDialogAction(video.id);
                  _global.vroute.navigateTo('/login');
                  return;
                }

                if (video.metadata['type'] == 'EVENTS_PHYSICAL') {
                  showDialog(
                    context: context,
                    builder:
                        (context) => EventCheckoutDialog(
                          virtualProductId: video.id,
                        ),
                  );
                  return;
                }

                if(video.type == VirtualProductType.subscriptions) {
                  // If the video is a Radiesse video, show the specific dialog
                  showDialog(
                    context: context,
                    builder: (context) => SubscriptionPaymentDialog(),
                  );
                  return;
                }

                // user is already logged in, show dialog immediately
                if (video.name.contains('Brazilian HDR Technique')) {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder:
                        (context) =>
                            RadiesseVideoCheckoutDialog(product: video),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder:
                        (context) =>
                            DynamicVideoCheckoutDialog(product: video),
                  );
                }
              },
            );
          },
        ),
      ],
    );
  }
}
