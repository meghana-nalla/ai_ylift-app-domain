import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/core/repositories/image_repository.dart';

import 'package:YLift/models/z-index_export.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:YLift/presentation/pages/desktop/y_university/components/event_location_dialog.dart';
import 'package:YLift/presentation/pages/desktop/y_university/components/kevin_tehrani_bio.dart';
import 'package:YLift/presentation/pages/desktop/y_university/components/yan_trokel_bio.dart';
import 'package:YLift/presentation/pages/desktop/y_university/components/yuly_gorodisky_bio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:YLift/core/controllers/z-index_export.dart';
import 'package:get/get.dart';


final _imageUrl = ImageRepository.getBannerImage('7797779b-e606-45b3-b3fb-f6784531b651');
    // 'https://phantom.ylift.app/media/api/optimized/variant/image/file/7797779b-e606-45b3-b3fb-f6784531b651';

enum _TabLabel {
  whatYoullGet('What you\'ll get'),
  whatYoullLearn('What you\'ll learn'),
  dateLocation('Date / Location'),
  meetTheExperts('Meet the Experts');

  final String label;
  const _TabLabel(this.label);
}

// Lead to y university. See https://store.ylift.com/y-university
class YUniversityPage extends StatefulWidget {
  const YUniversityPage({super.key});

  @override
  State<YUniversityPage> createState() => _YUniversityPageState();
}

class _YUniversityPageState extends State<YUniversityPage> {
  _TabLabel currentTab = _TabLabel.whatYoullGet;
  void setTab(_TabLabel label) {
    setState(() {
      currentTab = label;
    });
  }

  Future<void> enroll() async {
    final global = Get.find<GlobalController>();
    if (global.isAuthenticated.isFalse) {
      global.vroute.navigateTo('/login', redirectPath: '/y-university');
      return;
    }
    global.trainingInterest.value = TrainingInterest(
      name: 'Y University',
      tagName: 'SurgyLift',
      supportText: 'Register to join',
      oneTimeFee: 20000, // $20,000
    );
    await global.training.initForm();
    global.vroute.navigateTo('/training/register');
  }

  @override
  Widget build(BuildContext context) {
    return GalaxyPageScaffold(
      crossAxisAlignment: CrossAxisAlignment.center,
      padding: EdgeInsets.only(
        top: YLiftConstant.totalTopNavigation + 24,
      ),
      children: [
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
              'SurgYlift',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        SizedBox(height: 16),
        GestureDetector(
          onTap: enroll,
          child: SizedBox(
            width: YLiftConstant.pageWidth,
            child: Image.network(_imageUrl),
          ),
        ),
        const GapY(),
        SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Wrap(
                  children: List.generate(
                    _TabLabel.values.length * 2 - 1,
                    (index) {
                      if (index.isOdd) return SizedBox(width: 16);
                      final tab = _TabLabel.values[index ~/ 2];
                      final isSelected = tab == currentTab;

                      return InkWell(
                        onTap: () => setTab(tab),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text(
                            tab.label.toUpperCase(),
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w100,
                            ),
                          ),
                        ),
                      );
                    },
                    growable: false,
                  ),
                ),
              ),
              const Divider(height: 32),
              const SizedBox(height: 16),
              switch (currentTab) {
                _TabLabel.whatYoullGet => const _WhatYouWillGetContent(),
                _TabLabel.whatYoullLearn => const _WhatYouWillLearnContent(),
                _TabLabel.dateLocation => const _DateLocationContent(),
                _TabLabel.meetTheExperts => const _MeetTheExpertsContent(),
              }
            ],
          ),
        ),
        const GapY(factor: 2),
        YLiftFilledButton(
          isExpanded: true,
          onPressed: enroll,
          child: const Text(
            'Register Now',
            style: TextStyle(fontSize: 16),
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
        const Text(
          'Instantly receive discounted pricing through Y LIFT Store on your favorite products!',
          style: TextStyle(fontSize: 16),
        ),
        const GapY(),
        const Text(
          'YLIFT® Media Kit',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        const Text(
          'Access to the YLIFT® Media Kit to get your marketing started on the right foot! The Media Kit features Before & After photos, digital ads, social media posts, email templates, and more!',
          style: TextStyle(fontSize: 16),
        ),
        const GapY(),
        const Text(
          'Virtual Forum Premium',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        const Text(
          'Gain instant Premium Tier membership to our virtual forum AskY as well as YLIFT® Campaign Tier access to all YLIFT® channels. Join other professionals in your field to share knowledge and experience face to face!',
          style: TextStyle(fontSize: 16),
        ),
        const GapY(),
        const Text(
          'Course Material',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
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
          'Learn the revolutionary SurgYlift® technique with a comprehensive 2-day, hands-on training course on 3 live patients.',
        ),
        GapY(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: EventRundown(
                title: 'Day 1',
                activities: [
                  Activity('7:00 - 7:30am', 'Meet & Greet, Coffee, and Breakfast'),
                  Activity('7:30 - 8:30am', 'Face & Neck Anatomy, Functional Aesthetics, Beauty Ideals'),
                  Activity('8:30 - 9:00am', 'flexY guide - Intro, Application, & Uses'),
                  Activity('9:00 - 12:00am', 'Hands-On Training: Live Patient Demo #1'),
                  Activity('12:00 - 1:00pm', 'LUNCH BREAK'),
                  Activity('1:00 - 1:30pm', 'SurgYlift® - Technique Review, Ideal Candidate, Complications'),
                  Activity('1:30 - 4:30pm', 'Hands-On Training: Live Patient Demo #2'),
                  Activity('4:30 - 5:30pm', 'Q&A'),
                  Activity('6:00pm - Finish', 'Dinner & Drinks'),
                ],
              ),
            ),
            GapX(),
            Expanded(
              child: EventRundown(
                title: 'Day 2',
                activities: [
                  Activity('7:00 - 7:30 am', 'Coffee & Breakfast'),
                  Activity('7:30 - 8:00 am', 'Follow-Up Patient #1 & Patient #2'),
                  Activity('8:00 - 11:00 am', 'Hands-On Training: Live Patient Demo #3'),
                  Activity('11:00 - 12:00 pm', 'Q&A, Closing Statements'),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}

class _DateLocationContent extends StatelessWidget {
  const _DateLocationContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: YLiftConstant.gap * 2,
        runSpacing: YLiftConstant.gap * 2,
        children: [
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return EventLocationDialog(
                    imageUrl: 'https://store.ylift.com/static/img/Banners/surgcenter.png',
                    locationName: 'West Coast Plastic Surgery Center',
                    description:
                        'Learn the revolutionary SurgYlift® technique with a 2-day, hands-on training course on 3 live patients.',
                    locationAddress: AddressSimple(
                      line1: '2831 N Ventura Rd',
                      city: 'Oxnard',
                      state: 'CA',
                      zip: '93036',
                      phone: '+1 (212)-861-7787',
                      createdAt: DateTime.now(),
                    ),
                    date: 'March 9 & 10',
                  );
                },
              );
            },
            child: SizedBox(
              width: 640,
              child: Column(
                children: [
                  const Text(
                    'Oxnard, CA',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Image.network(
                    'https://store.ylift.com/static/img/location/OxnardCAMAR910.png',
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 640,
            child: Column(
              children: [
                const Text(
                  'New York City, NY',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Image.network(
                  'https://store.ylift.com/static/img/location/NewYorkCitySoon.png',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _MeetTheExpertsContent extends StatelessWidget {
  const _MeetTheExpertsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: [
          Text(
            'Faculty',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          GapY(),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: YLiftConstant.gap * 2,
            runSpacing: YLiftConstant.gap * 2,
            children: [
              YanTrokelBio(),
              YulyGorodiskyBio(),
              KevinTehraniBio(),
            ],
          ),
        ],
      ),
    );
  }
}
