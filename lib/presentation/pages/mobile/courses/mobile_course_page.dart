
import 'package:YLift/core/constants/hardcoded_id.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/presentation/components/_complex/desktop_view/page_scaffold.dart';
import 'package:YLift/presentation/components/_complex/dialogs/subscription_payment_dialog/subscription_payment_dialog.dart';
import 'package:YLift/presentation/pages/desktop/__primary_courses/components/discover_unlock_training_panel.dart';
import 'package:YLift/presentation/pages/desktop/__primary_courses/components/events_checkout/event_checkout_dialog.dart';
import 'package:YLift/presentation/pages/mobile/courses/my_library.dart';
import 'package:YLift/presentation/pages/desktop/__primary_courses/components/video_checkout/dynamic_checkout_dialog.dart';
import 'package:YLift/presentation/pages/desktop/__primary_courses/components/video_checkout/video_checkout_dialog.dart';
import 'package:YLift/presentation/pages/mobile/courses/mobile_course__video_checkout_page.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:get/get.dart';
import 'package:web/web.dart' as web;

class MobileCoursePage extends StatefulWidget {
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

  const MobileCoursePage({super.key});

  @override
  State<MobileCoursePage> createState() => _OnlineCoursesState();
}

class _OnlineCoursesState extends State<MobileCoursePage> {
  final List<String> tabs = [
    'My Library',
    'Trending',
    // 'Best Selling',
    // 'Newest',
    // 'Limited-Time Offer',
  ];
  String selectedTab = 'Trending'; // Default selected tab
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
              _global.vroute.navigateTo('/cart');
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
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
        children: [
          // -- first section is our product with banner -- //
      Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  // Left Icon Button
                  // Container(
                  //   padding: const EdgeInsets.all(8),
                  //   decoration: BoxDecoration(
                  //     color: const Color(0xFFDFE2FB),
                  //     shape: BoxShape.circle,
                  //   ),
                  //   child: const Icon(Icons.menu, size: 20, color: Color(0xFF343434)),
                  // ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTab = 'My Library';
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      decoration: ShapeDecoration(
                          color: selectedTab == 'My Library'
                              ? const Color(0xFFDFE2FB)
                              : Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        shadows: selectedTab == 'My Library' ? [] : [],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 8,
                        children: [
                          Text(
                            'My Library',
                            style: TextStyle(
                              color: selectedTab == 'My Library' ? Colors.black : const Color(0xFF343434),
                              fontSize: 13,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),



                  // const SizedBox(width: 12),

                  // Tag Nav Scroll
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: tabs
                            .where((tab) => tab != 'My Library')
                            .map(
                              (tab) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedTab = tab;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  decoration: ShapeDecoration(
                                    color: selectedTab == tab
                                        ? const Color(0xFF006AFF)
                                        : Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          selectedTab == tab ? 5 : 30),
                                    ),
                                  ),
                                  child: Text(
                                    tab,
                                    style: TextStyle(
                                      color: selectedTab == tab
                                          ? Colors.white
                                          : const Color(0xFF343434),
                                      fontSize: 13,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      height: 1,
                                    ),
                                  ),
                                ),
                              ),
                        )
                            .toList(),
                      ),
                    ),
                  ),
        ],
              ),
            ),
          // -- next section is our my content list -- //
          //MyVideoLibrarySection(),
          // -- next section is our virtual products list -- //
          // const SizedBox(height: 16),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          //   child: buildVirtualProductsList(),
          // ),
          // Content area changes based on selected tab
          if (selectedTab == 'My Library')
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: MyMobileVideoLibrarySection(),
              )
              // Replace with your real widget

          else if (selectedTab == 'Trending')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: buildVirtualProductsList(),
            )
          else
            Center(child: Text('Content for $selectedTab')), // Placeholder

          const SizedBox(height: 16),
          const SizedBox(height: 16),
        ],
      ),
      ),
    );
  }

  Widget buildVirtualProductsList() {
    final videos = _global.allVirtualProducts.value.tradingProducts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(videos.length, (index) {
        final video = videos[index];

        final products = _global.allProducts.value.getByIds(
          video.tradingMetadata?.productIds ?? [],
        );
        final brandName = products.firstOrNull?.brandName ?? 'Brand';

        final alreadyInCart = _global.simpleCart.value.tradeGoods.any(
              (element) => element.goodsTradingId == video.id,
        );

        final alreadyHave = _global.user.value.virtualContent?.any((element) {
          return element.virtualProductId == video.id ||
              element.bundleProductId == video.id;
        }) ?? false;

        final alreadyIncluded =
            _global.user.value.hasVirtualContentById(HardcodedId.eventTwoDay) &&
                video.metadata['type'] == 'EVENTS_PHYSICAL';

        MobileCourseTag? tag;
        if (video.metadata['type'] == 'TRAINING') {
          tag = MobileCourseTag.video;
        } else if (video.metadata['type'] == 'EVENTS_PHYSICAL') {
          tag = MobileCourseTag.handsOn;
        }

        final previewVideoUrl = video.metadata['previewVideoUrl'] ?? '';

        return Padding(
          padding: EdgeInsets.only(bottom: index < videos.length - 1 ? 32 : 0),
          child: MobileVideoCourseCard(
            thumbnailUrl: video.imageUrl,
            title: video.name,
            authorName: video.metadata['authorName'] ?? '',
            chapters: video.metadata['chapterCount'] ?? '',
            previewVideoUrl: previewVideoUrl.isNotEmpty ? previewVideoUrl : null,
            tag: tag,
            onTap: () {
              // TODO: Handle card tap
            },
            unlockMessage: alreadyHave
                ? 'Already purchased'
                : alreadyIncluded
                ? 'Already included in 2 days ticket'
                : alreadyInCart
                ? '✅ Already in Cart - View Cart'
                : (video.tradingMetadata != null
                ? 'Unlock with ${video.tradingMetadata!.requirementQuantity} $brandName Purchase'
                : null),
            onUnlockMessageTap: () {
              if (alreadyHave || alreadyIncluded) return;
              if (alreadyInCart) {
                _global.vroute.navigateTo('/cart');
                return;
              }

              if (_global.isAuthenticated.isFalse) {
                _saveVideoDialogAction(video.id);
                _global.vroute.navigateTo('/login');
                return;
              }

              if (video.metadata['type'] == 'EVENTS_PHYSICAL') {
                showDialog(
                  context: context,
                  builder: (context) =>
                      EventCheckoutDialog(virtualProductId: video.id),
                );
                return;
              }

              if (video.type == VirtualProductType.subscriptions) {
                showDialog(
                  context: context,
                  builder: (context) => SubscriptionPaymentDialog(),
                );
                return;
              }

              if (video.name.contains('Brazilian HDR Technique')) {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) =>
                      MobileCourseCheckoutScreen(product: video,),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) =>
                      DynamicVideoCheckoutDialog(product: video),
                );
              }
            },
          ),
        );
      }),
    );
  }
  Widget _buildTag(String label, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF006AFF) : Colors.transparent,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isSelected ? Colors.transparent : const Color(0xFFDFE2FB),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF343434),
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

}

// import 'package:YLift/presentation/components/_complex/footer.dart';
// import 'package:flutter/material.dart';
// import 'package:galaxy_ui/galaxy_ui.dart';
// class MobileCoursePage extends StatelessWidget {
//   const MobileCoursePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Top NavBar Section
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               child: Row(
//                 children: [
//                   // Left Icon Button
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFDFE2FB),
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(Icons.menu, size: 20, color: Color(0xFF343434)),
//                   ),
//
//                   const SizedBox(width: 12),
//
//                   // Tag Nav Scroll
//                   Expanded(
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Row(
//                         children: [
//                           _buildTag('Trending', isSelected: true),
//                           const SizedBox(width: 8),
//                           _buildTag('Best Selling'),
//                           const SizedBox(width: 8),
//                           _buildTag('Newest'),
//                           const SizedBox(width: 8),
//                           _buildTag('Limited-Time Offer'),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // Padding(
//             //   padding: const EdgeInsets.all(16.0),
//             //   child: VideoCourseCard(
//             //     thumbnailUrl: 'https://picsum.photos/400/225',
//             //     title: 'Advanced Facial Aesthetics Techniques',
//             //     authorName: 'Dr. Sarah Johnson',
//             //     chapters: '8 chapters',
//             //     onTap: () {},
//             //     unlockMessage: 'Unlock with 20-box Radiesse purchase',
//             //     tag: CourseTag.video,
//             //   ),
//             // ),
//             SizedBox(height: 16,),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   MobileVideoCourseCard(
//                     thumbnailUrl: 'https://media.stage.ylift.app/api/optimized/variant/image/file/94776c25-0a89-4674-a45c-67662378a7d1',
//                     title: 'Learn Brazilian HDR technique with Zoe',
//                     authorName: 'Dr. Zoe Flor',
//                     chapters: '5 Chapters',
//                     onTap: () {
//                       // Handle tap
//                     },
//                     unlockMessage: 'Unlock with 20-box Radiesse Purchase',
//                     onUnlockMessageTap: () {
//                       // Handle unlock message tap
//                     },
//                   ),
//                   // const SizedBox(height: 24),
//                   // MobileVideoCourseCard(
//                   //   thumbnailUrl: 'https://media.stage.ylift.app/api/optimized/variant/image/file/94776c25-0a89-4674-a45c-67662378a7d1',
//                   //   title: 'Mastering Full-Face Rejuvenation',
//                   //   authorName: 'Dr. Alex Chen',
//                   //   chapters: '7 Chapters',
//                   //   onTap: () {},
//                   //   unlockMessage: 'Unlock with 10-box Xeomin Purchase',
//                   // ),
//                   // const SizedBox(height: 24),
//                   // MobileVideoCourseCard(
//                   //   thumbnailUrl: 'https://media.stage.ylift.app/api/optimized/variant/image/file/94776c25-0a89-4674-a45c-67662378a7d1',
//                   //   title: 'Hands-On Cannula Techniques',
//                   //   authorName: 'Dr. Emma Stone',
//                   //   chapters: '3 Chapters',
//                   //   onTap: () {},
//                   //   unlockMessage: 'Unlock with 5-box Belotero Purchase',
//                   // ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),
//             // You can add your widgets below
// GalaxyFooter(),
//             // Forexample, more video course cards or other content
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTag(String label, {bool isSelected = false}) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       decoration: BoxDecoration(
//         color: isSelected ? const Color(0xFF006AFF) : Colors.transparent,
//         borderRadius: BorderRadius.circular(30),
//         border: Border.all(
//           color: isSelected ? Colors.transparent : const Color(0xFFDFE2FB),
//         ),
//       ),
//       child: Text(
//         label,
//         style: TextStyle(
//           color: isSelected ? Colors.white : const Color(0xFF343434),
//           fontSize: 13,
//           fontWeight: FontWeight.w400,
//         ),
//       ),
//     );
//   }
// }



