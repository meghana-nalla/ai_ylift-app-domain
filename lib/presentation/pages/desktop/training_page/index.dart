import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/core/constants/hardcoded_id.dart';
import 'package:YLift/core/constants/index.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:YLift/presentation/components/_complex/desktop_view/gap.dart';
import 'package:YLift/presentation/components/_complex/footer.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/presentation/pages/desktop/training_page/banners/magnym_banner.dart';
import 'package:YLift/presentation/pages/desktop/training_page/banners/surgy_lift_banner.dart';
import 'package:YLift/presentation/pages/desktop/training_page/banners/ylift_training_banner.dart';
import 'package:YLift/presentation/pages/desktop/training_page/faq/index.dart';
import 'package:YLift/presentation/pages/desktop/training_page/partnership_list_view/index.dart';
import 'package:YLift/presentation/pages/desktop/training_page/training_experiences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:galaxy_ui/galaxy_ui.dart';

final _trainingImageUrl =
    '$API_WEB_LINK/${ApiUrl.getImage.path}/ab5d7087-9a1d-4353-ab6e-0e81a4910ede';
final _injectingImageUrl =
    '$API_WEB_LINK/${ApiUrl.getImage.path}/22141fc8-ac71-4a56-ac5a-02d5612b374b';
final _productsImageUrl =
    '$API_WEB_LINK/${ApiUrl.getImage.path}/24de809a-c482-4ffa-9ebf-ae64c1accecb';

class DesktopTrainingPage extends StatefulWidget {
  const DesktopTrainingPage({super.key});

  static const borderRadius = BorderRadius.all(Radius.circular(24));

  @override
  State<DesktopTrainingPage> createState() => _DesktopTrainingPageState();
}

class _DesktopTrainingPageState extends State<DesktopTrainingPage> {
  final scrollController = ScrollController();
  final _partnershipKey = GlobalKey();

  void howItWorks() async {
    final prefs = SharedPreferencesAsync();
    final extra = await prefs.getString('extra');
    if (extra == 'scroll') {
      final partnerBox =
          _partnershipKey.currentContext!.findRenderObject() as RenderBox;
      final partnerPosition = partnerBox.localToGlobal(Offset.zero);
      scrollController.jumpTo(
        partnerPosition.dy - YLiftConstant.totalTopNavigation,
      );
      prefs.remove('extra');
    }
  }

  @override
  void initState() {
    howItWorks();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GlobalController>();
    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.only(top: YLiftConstant.mainNavigationHeight),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 640,
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: [
                Image.network(
                  _trainingImageUrl,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 120,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TrainingBanner(
                        onTap: () {
                          controller.vroute.navigateTo('/network-provider');
                        },
                        banner: const GalaxyYLiftBanner(),
                        buttonColor: const Color(0xFFAC9B8D),
                      ),
                      const GapX(factor: 2),
                      TrainingBanner(
                        onTap: () {
                          controller.vroute.navigateTo('/y-university');
                        },
                        banner: const SurgYLiftBanner(),
                        buttonColor: const Color(0xFF88614D),
                      ),
                      const GapX(factor: 2),
                      TrainingBanner(
                        onTap: () async {

                          controller.trainingInterest.value = TrainingInterest(
                            name: 'MagnYm Instant Training',
                            tagName: 'MagnYm',
                            supportText: 'Register to learn about MagnYm',
                            oneTimeFee: 400000, // $4000
                          );
                          await controller.training.initForm();
                          controller.update();

                          final registrationStep = await controller.training.trainingsLog['step'] ?? 0;
                          if(registrationStep > 4) {
                            controller.vroute.navigateTo('/training/videos/MagnYm');
                            return;
                          }
                          controller.vroute.navigateTo('/video');
                        },
                        banner: const MagnYmBanner(),
                        buttonColor: const Color(0xFF303030),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.black,
            width: double.infinity,
            height: 480,
            alignment: Alignment.center,
            child: SizedBox(
              width: YLiftConstant.pageWidth,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'Enjoy Provider Network Benefits',
                    style: TextStyle(fontSize: 33, color: Colors.white),
                  ),
                  Text(
                    'After successfully for one of our trainings courses',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _NetworkBenefit(
                        icon: Icons.payments_outlined,
                        title: 'Exclusive Pricing',
                        description:
                            'Top-tier pricing on dermal fillers, neurotoxins, threads, and more.',
                      ),
                      _NetworkBenefit(
                        icon: Icons.map_outlined,
                        title: 'Patient Leads',
                        description:
                            'Patient leads sent to you through our finder’s map.',
                      ),
                      _NetworkBenefit(
                        icon: Icons.subscriptions_outlined,
                        title: 'Media Kit',
                        description:
                            'Use of all Y LIFT MEDIA KIT promotional materials.',
                      ),
                      _NetworkBenefit(
                        icon: Icons.help_outline_outlined,
                        title: 'ASK Y Platform',
                        description:
                            'Access to the ASK Y platform for education and networking.',
                      ),
                      _NetworkBenefit(
                        icon: Icons.school_outlined,
                        title: '1-on-1 Mentorship',
                        description:
                            'Have questions after your session? We\'re always here for you.',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            key: _partnershipKey,
            height: 120,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 60,
                  child: ColoredBox(color: Colors.black),
                ),
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  height: 120,
                  width: YLiftConstant.pageWidth,
                  child: const PartnershipListView(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 64),
          SizedBox(
            height: 360,
            width: YLiftConstant.pageWidth,
            child: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                    child: Image.network(
                      _injectingImageUrl,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFF3F4F3),
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 24,
                    ),
                    height: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Become our provider and\nreceive all network benefits.',
                          style: TextStyle(
                            fontSize: 33,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'After successfully registering one of our training courses, you can choose to train at our location or have one of our experts come to you to help you master our techniques,',
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.timer_outlined),
                            const SizedBox(width: 8),
                            Text('2-Day Training'),
                            const SizedBox(width: 32),
                            Icon(Icons.group_outlined),
                            const SizedBox(width: 8),
                            Text('3-5 LIVE Patients'),
                          ],
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton.icon(
                          onPressed: () {
                            scrollController.animateTo(
                              0,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 4,
                            backgroundColor: Color(0xFFFF8C68),
                          ),
                          iconAlignment: IconAlignment.end,
                          icon: Icon(Icons.arrow_forward, color: Colors.white),
                          label: Text('Register for Trainings'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 64),
          SizedBox(
            width: YLiftConstant.pageWidth,
            height: 420,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: DesktopTrainingPage.borderRadius,
                    color: Color(0xFFF3F4F3),
                  ),
                  width: 420,
                  height: 420,
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Unlock Exclusive\nTop-Tier Pricing',
                        style: TextStyle(
                          fontSize: 33,
                          color: Color(0xFF3A3A3A),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'On Products',
                        style: GoogleFonts.metal(fontSize: 39),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Fillers, neurotoxins, threads, and more from Galderma, Evolus, and others!',
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(elevation: 4),
                          onPressed: () {
                            scrollController.animateTo(
                              0,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: const Text('Enroll Now'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: ClipRRect(
                    borderRadius: DesktopTrainingPage.borderRadius,
                    child: Image.network(
                      _productsImageUrl,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 64),
          const TrainingExperiences(),
          const SizedBox(height: 32),
          const FrequentlyAskedQuestionsSection(),
          const SizedBox(height: 64),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: YLiftColor.orange),
            onPressed: () {
              scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            },
            child: const Text('Get Trained Today!'),
          ),
          const SizedBox(height: 64),
          GalaxyFooter(),
        ],
      ),
    );
  }
}

class TrainingBanner extends StatefulWidget {
  final Widget banner;
  final Color buttonColor;
  final void Function()? onTap;

  const TrainingBanner({
    super.key,
    required this.banner,
    this.buttonColor = YLiftColor.brown,
    this.onTap,
  });

  @override
  State<TrainingBanner> createState() => _TrainingBannerState();
}

class _TrainingBannerState extends State<TrainingBanner> {
  bool isHovering = false;
  void toggleHover(bool value) {
    setState(() {
      isHovering = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: isHovering ? 1.1 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (event) => toggleHover(true),
          onExit: (event) => toggleHover(false),
          child: SizedBox(
            width: 280,
            height: 320,
            child: Column(
              children: [
                Expanded(child: widget.banner),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: widget.buttonColor,
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      // textStyle: const TextStyle(fontSize: 14),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.5,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 24,
                      ),
                    ),
                    onPressed: widget.onTap,
                    child: const Text('Details & Register'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NetworkBenefit extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  const _NetworkBenefit({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Color(0xFF343434),
      ),
      width: 240,
      height: 240,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            width: 32,
            height: 32,
            child: Icon(icon, color: Color(0xFF343434)),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(description, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
