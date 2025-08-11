import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/core/repositories/image_repository.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:YLift/core/controllers/z-index_export.dart';
import 'package:get/get.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:galaxy_ui/galaxy_ui.dart';

final _bannerUrl = ImageRepository.getBannerImage('c53d4972-f509-4254-b3bf-2a66dcc6b839');
    // 'https://phantom.ylift.app/media/api/optimized/variant/image/file/c53d4972-f509-4254-b3bf-2a66dcc6b839';
const _tabLabels = ['What you\'ll get', 'What you\'ll learn'];

// Lead to network-provider. See https://store.ylift.com/network-provider
class NetworkProviderPage extends StatefulWidget {
  const NetworkProviderPage({super.key});

  @override
  State<NetworkProviderPage> createState() => _NetworkProviderPageState();
}

class _NetworkProviderPageState extends State<NetworkProviderPage> {
  String currentTab = _tabLabels[0];
  void setTab(String label) {
    setState(() {
      currentTab = label;
    });
  }

  void enroll() async {
    final global = Get.find<GlobalController>();
    if (global.isAuthenticated.isFalse) {
      global.vroute.navigateTo('/login', redirectPath: '/network-provider');
      return;
    }

    global.trainingInterest.value = TrainingInterest(
      name: 'Network Provider',
      tagName: 'YLift',
      supportText: 'Register to become a YLIFT Provider',
      oneTimeFee: 1500000, //$15,000
    );
    await global.training.initForm();
    global.vroute.navigateTo('/training/register');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GalaxyPageScaffold(
      padding: EdgeInsets.only(
        top: YLiftConstant.totalTopNavigation + 24,
      ),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Top Navigation
        Row(
          children: [
            SizedBox(
              width: 8,
            ),
            TextButton(
              style: TextButton.styleFrom(padding: EdgeInsets.zero, overlayColor: Colors.white),
              child: Text(
                'Training',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              onPressed: () async {
                await global.vroute.navigateTo('/training');
              },
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              '/',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              'Y LIFT',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        SizedBox(height: 16),
        GestureDetector(
          onTap: enroll,
          child: SizedBox(
            width: YLiftConstant.pageWidth,
            child: Image.network(_bannerUrl),
          ),
        ),
        const GapY(),
        SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => setTab(_tabLabels[0]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        _tabLabels[0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: _tabLabels[0] == currentTab ? FontWeight.bold : FontWeight.w100,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 32),
                  InkWell(
                    onTap: () => setTab(_tabLabels[1]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        _tabLabels[1].toUpperCase(),
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: _tabLabels[1] == currentTab ? FontWeight.bold : FontWeight.w100,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 32),
              const SizedBox(height: 16),
              if (currentTab == _tabLabels[1]) const _WhatYouWillLearnContent() else const _WhatYouWillGetContent(),
            ],
          ),
        ),
        const GapY(factor: 2),
        SizedBox(
          width: double.infinity,
          child: RoundedFilledButton(
            onPressed: enroll,
            child: const Text(
              'Register Now',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        const GapY(factor: 4),
      ],
    );
  }
}

class _WhatYouWillGetContent extends StatefulWidget {
  const _WhatYouWillGetContent();

  @override
  State<_WhatYouWillGetContent> createState() => _WhatYouWillGetContentState();
}

class _WhatYouWillGetContentState extends State<_WhatYouWillGetContent> {
  final yLiftCom = TapGestureRecognizer()
    ..onTap = () {
      print('tapped');
    };

  @override
  void dispose() {
    yLiftCom.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Learning something new is only part of the journey. The other part is incorporating what you’ve learned into your practice and becoming successful.\n'
          'By registering for this course, you not only learn from one of the top cosmetic doctors in the country but you will also get:',
          style: TextStyle(fontSize: 16),
        ),
        const GapY(),
        const Text(
          'Patient Leads',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SelectableText.rich(
          TextSpan(
            style: const TextStyle(fontSize: 16),
            children: [
              const TextSpan(
                text: 'Become listed as a YLIFT® Provider on our Find-A-Provider map featured on ',
              ),
              TextSpan(
                text: 'www.ylift.com',
                recognizer: yLiftCom,
                mouseCursor: SystemMouseCursors.click,
              ),
              const TextSpan(text: '. '),
              const TextSpan(text: 'Patients/clients can submit an appointment request directly to your office; '),
              const TextSpan(
                text: 'the leads come to you! ',
                style: TextStyle(decoration: TextDecoration.underline),
              ),
              const TextSpan(
                text: 'Climb up the ranks on the listing by performing YLIFT® procedures to become the ',
              ),
              const TextSpan(
                text: 'top provider in your area!',
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            ],
          ),
        ),
        const GapY(),
        const Text(
          'Discount Pricing',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Instantly receive discounted pricing through Y LIFT Store on your favorite products!',
          style: TextStyle(fontSize: 16),
        ),
        const GapY(),
        const Text(
          'YLIFT® Media Kit',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Access to the YLIFT® Media Kit to get your marketing started on the right foot! The Media Kit features Before & After photos, digital ads, social media posts, email templates, and more!',
          style: TextStyle(fontSize: 16),
        ),
        const GapY(),
        const Text(
          'Virtual Forum Premium',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Gain instant Premium Tier membership to our virtual forum AskY as well as YLIFT® Campaign Tier access to all YLIFT® channels. Join other professionals in your field to share knowledge and experience face to face!',
          style: TextStyle(fontSize: 16),
        ),
        const GapY(),
        const Text(
          'Course Material',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Unlimited lifetime access to all course material.',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

class _WhatYouWillLearnContent extends StatelessWidget {
  const _WhatYouWillLearnContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Course Outline',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        Text(
          'Learn the Innovative, Non-Surgical Facelift technique with a comprehensive 2-day, hands-on training course conducted by Y LIFT® Faculty in the comfort of your practice.',
        ),
        GapY(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: EventRundown(
                title: 'Day 1',
                description:
                    'Y LIFT® Technique, flexY guide™, Facial Aesthetics, Business Notes, Hands-On Training & Live Demonstrations',
                activities: [
                  Activity('9:00 - 9:30am', 'Facial Aesthetics'),
                  Activity('9:30 - 10:00am', 'Beauty Ideals'),
                  Activity('10:00 - 10:30am', 'flexY guide - Intro, Application, & Uses'),
                  Activity('10:30 - 12:00am', 'Y LIFT® – Set Up, Technique, Step-by-Step Video Guide'),
                  Activity('12:00 - 12:30pm', 'LUNCH BREAK'),
                  Activity('12:30 - 3:30pm', 'Hands-On Training: Live Patient Demo #1*'),
                  Activity('3:30 - 5:30pm', 'Hands-On Training: Live Patient Demo #2*'),
                  Activity('5:30 - 6:00pm', 'Implementing Y LIFT® Into Your Practice'),
                ],
              ),
            ),
            GapX(),
            Expanded(
              child: EventRundown(
                title: 'Day 2',
                description: 'Y LIFT® Follow Up Appointments, Hands-On Training & Live Demonstrations',
                activities: [
                  Activity('9:00 - 9:15 am', 'Follow-Up Patient #1 & Patient #2'),
                  Activity('9:15 - 9:30 am', 'Complications & How to Deal with Them'),
                  Activity('9:30 - 11:30 am', 'Hands-On Training: Live Patient Demo #3*'),
                  Activity('11:30 - 1:30 pm', 'Hands-On Training: Live Patient Demo #4*'),
                ],
              ),
            )
          ],
        ),
        SizedBox(height: 32),
        Text(
          '* We recommend you choose 3-4 patients for the live demonstrations. Depending on the number of patients the schedule can be arranged to suit your needs.',
        ),
        Text('** Training schedule subject to travel arrangements and availability'),
      ],
    );
  }
}
