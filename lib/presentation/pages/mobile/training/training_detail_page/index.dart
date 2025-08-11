/*
  This file contains the code for the Training Page.
  The Training Page displays the details of a specific training course.
  The page includes the following sections:
    - Image Container
    - Title
    - Description
    - Register Button
    - Learn More Button
*/

import 'package:YLift/core/constants/color.dart';
import 'package:YLift/core/repositories/image_repository.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:get/get.dart';


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/models/simple/TrainingSimple.dart';
import 'package:YLift/presentation/components/_complex/know_y/training_page/image.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:YLift/models/z-index_export.dart';


// DEBUG: a dummy JSON object to represent the data that will be fetched from the API

Map<String, dynamic> trainingJson = {
  'id': '1',
  'title': 'Become a Y LIFT® Provider',
  'subtitle': '30-Minute Miracle Facelift By Dr. Oz',
  'author': 'Training Author',
  'details': 'Training Overview',
  'overview':
      'The renowned Y LIFT® procedure is a revolutionary, patented minimally invasive facelift performed in 30-45 minutes which instantly creates beautiful, youthful and dramatic, yet natural-looking results. It was famously dubbed the “Miracle 30-Minute Facelift” by Dr. Oz.',
  'thumbnailUrl': 'Training Thumbnail URL',
};

class TrainingPage extends StatelessWidget {
              //Get.find<GlobalController>();
  const TrainingPage({
    super.key,
    this.training,
  });

  // TODO: require training object
  final TrainingSimple? training;

  @override
  Widget build(BuildContext context) {
    // access global context
    final GlobalController global = Get.find<GlobalController>();

    // TODO: pass in real training object (currently using hardcoded JSON)
    // Map<String, dynamic> trainingJson = training.toJson();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Navigate back to 'Know Y' page
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        global.vroute.navigateTo('/training');
                      },
                    ),
                    const Text('Back To Training')
                  ],
                ),
              ),
              const SizedBox(height: 10.0),

              // TODO: replace with actual image
              // Image Container with rounded corners
              KnowYTrainingPageImage(
                imageText: trainingJson['subtitle'],
              ),
              const SizedBox(height: 20),

              // Title Section
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  trainingJson['title'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Underline effect
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  width: 50,
                  height: 2,
                  color: Colors.brown, // Matches the design for the small underline
                ),
              ),

              const SizedBox(height: 10),

              // Description Text
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  trainingJson['overview'],
                  style: const TextStyle(fontSize: 14),
                ),
              ),

              const SizedBox(height: 20),

              // Register Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown, // Button background color
                    padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 40.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Register Now',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Learn More Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 40.0),
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Learn More',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 30.0),

              TrainingTabs(
                tabs: const [
                  Text('What You\'ll Get'),
                  Text('What You\'ll Learn'),
                ],
                pages: const <Widget>[
                  // What you will get
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Learning something new is only part of the journey. The other part is incorporating what you’ve learned into your practice and becoming successful.'),
                      Text(
                        'By registering for this course, you not only learn from one of the top cosmetic doctors in the country but you will also get:',
                      ),
                      TextWithIcon(
                        icon: Text('•'),
                        text:
                            'Patient Leads: Become listed as a YLIFT® Provider on our Find-A-Provider map featured on www.ylift.com. '
                            'Patients/clients can submit an appointment request directly to your office; '
                            'the leads come to you! Climb up the ranks on the listing by performing YLIFT® '
                            'procedures to become the top provider in your area!',
                      ),
                      TextWithIcon(
                        icon: Text('•'),
                        text:
                            'Discount Pricing: Instantly receive discounted pricing through Y LIFT Store on your favorite products!',
                      ),
                    ],
                  ),

                  // What you will learn
                  Column(
                    children: [
                      Text(
                        'Learn the Innovative, Non-Surgical Facelift technique with a comprehensive 2-day, '
                        'hands-on training course conducted by Y LIFT® Faculty in the comfort of your practice.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      EventRundown(
                        title: 'Day 1',
                        description:
                            'Y LIFT® Technique, flexY guide™, Facial Aesthetics, Business Notes, Hands-On Training & Live Demonstrations',
                        activities: [
                          Activity('9:00 - 9:30am', 'Facial Aesthetics'),
                          Activity('9:30 - 10:00am', 'Beauty Ideals'),
                          Activity('10:00 - 10:30am', 'flexY guide - Intro, Application, & Uses'),
                          Activity('10:30 - 12:00am', 'Y LIFT® – Set Up, Technique, Step-by-Step Video Guide'),
                          Activity('12:00 - 12:30pm', 'LUNCH BREAK'),
                          Activity('12:30 - 3:30pm', 'Hands-On Training: Live Patient Demo #1'),
                          Activity('3:30 - 5:30pm', 'Hands-On Training: Live Patient Demo #2'),
                          Activity('5:30 - 6:00pm', 'Implementing Y LIFT® Into Your Practice'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      EventRundown(
                        title: 'Day 2',
                        description: 'Y LIFT® Follow Up Appointments, Hands-On Training & Live Demonstrations',
                        activities: [
                          Activity('9:00 - 9:15 am', 'Follow-Up Patient #1 & Patient #2'),
                          Activity('9:15 - 9:30 am', 'Complications & How to Deal with Them'),
                          Activity('9:30 - 11:30 am', 'Hands-On Training: Live Patient Demo #3*'),
                          Activity('11:30 - 1:30 pm', 'Hands-On Training: Live Patient Demo #4*'),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 32),

              YLiftFilledButton(
                isExpanded: true,
                onPressed: () {},
                child: const Text('Become a Provider'),
              ),
              const SizedBox(height: 32),

              const Column(
                children: [
                  Text('Question or Concerns?', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  Text('Contact our office at (212) 861-7787'),
                  Text('or email us at info@ylift.com'),
                ],
              )

              // DynamicNestedTabView(),
            ],
          ),
        ),
      ),
    );
  }
}

/// This should be renamed to something else...
class TrainingTabs extends StatefulWidget {
  final List<Widget> tabs;
  final List<Widget> pages;
  final int? selectedTab;
  final void Function(int index)? onTabSelected;

  const TrainingTabs({
    super.key,
    required this.tabs,
    required this.pages,
    this.selectedTab,
    this.onTabSelected,
  }) : assert(tabs.length == pages.length);

  @override
  State<TrainingTabs> createState() => _TrainingTabsState();
}

class _TrainingTabsState extends State<TrainingTabs> {
  int currentTab = 0;

  void goToPage(int nextPage) async {
    setState(() {
      currentTab = nextPage;
    });
    widget.onTabSelected?.call(currentTab);
    print('TAB SELECTED $currentTab');
  }

  @override
  void initState() {
    if (widget.selectedTab != null) currentTab = widget.selectedTab!;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TrainingTabs oldWidget) {
    if (widget.selectedTab != oldWidget.selectedTab) {
      if (widget.selectedTab != null) goToPage(widget.selectedTab!);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40,
            child: Row(
              children: List.generate(
                widget.tabs.length,
                (index) {
                  final isSelected = index == currentTab;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => goToPage(index),
                      child: Container(
                        decoration: BoxDecoration(
                          border:
                              isSelected ? const Border(bottom: BorderSide(color: YLiftColor.brown, width: 3)) : null,
                        ),
                        alignment: Alignment.center,
                        child: DefaultTextStyle.merge(
                          style: isSelected ? const TextStyle(fontWeight: FontWeight.bold) : null,
                          child: widget.tabs[index],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          widget.pages[currentTab],
        ],
      ),
    );
  }
}
