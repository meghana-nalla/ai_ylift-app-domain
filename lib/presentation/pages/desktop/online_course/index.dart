import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/core/constants/index.dart';
import 'package:YLift/core/constants/text_style.dart';
import 'package:galaxy_models/galaxy_models.dart';

import 'package:flutter/material.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:YLift/core/controllers/z-index_export.dart';
import 'package:get/get.dart';
import 'package:galaxy_ui/galaxy_ui.dart';

import '../../../../core/repositories/image_repository.dart';


const _videoReferences = <Map<String, dynamic>>[
  {
    'uuid': '36cec623-4448-4ac2-9bc7-a14e299e2396',
    'thumbnailUrl': null,
    'title': 'Preview',
    'description': 'MagNym Preview',
  },
  {
    'uuid': '36cec623-4448-4ac2-9bc7-a14e299e2396',
    'thumbnailUrl': null,
    'title': 'MagnYm Introduction',
    'description': 'What do men really want?',
  },
  {
    'uuid': '05b8b7cc-c30b-480b-9c01-ba9e99d836d0',
    'thumbnailUrl': null,
    'title': 'MagnYm Didactics',
    'description': 'Dr Rovert Valenzuela\'s MagnYm Didactic',
  },
  {
    'uuid': 'baaa6c0c-982f-4e22-a517-b4588c9e14cf',
    'thumbnailUrl': null,
    'title': 'MagnYm Product Preparation',
    'description': 'Preparing Dysport for MagnYm',
  },
  {
    'uuid': 'd1f15d71-028c-47fb-826f-ffd849dbc8d3',
    'thumbnailUrl': null,
    'title': 'MagnYm Product Procedure Part 1',
    'description': 'Preparing Dysport for MagnYm',
  },
  {
    'uuid': '116838a1-7d7c-4349-97b3-7d1e31c499b8',
    'thumbnailUrl': null,
    'title': 'MagnYm Product Procedure Part 2',
    'description': 'Preparing Dysport for MagnYm',
  },
  {
    'uuid': '8d9c8c0a-248c-4731-9a95-f51573e04c91',
    'thumbnailUrl': null,
    'title': 'MagnYm Product Preparation',
    'description': 'Preparing Jeuveau for MagnYm',
  },
  {
    'uuid': '8f1b1cf4-cbcf-49ea-895e-379ed786c7c4',
    'thumbnailUrl': null,
    'title': 'MagnYm Product Procedure Part 1',
    'description': 'Preparing Jeuveau for MagnYm',
  },
  {
    'uuid': 'fba98af4-1427-4f44-9dde-1f580dd2d5ae',
    'thumbnailUrl': null,
    'title': 'MagnYm Product Procedure Part 2',
    'description': 'Preparing Jeuveau for MagnYm',
  },
];

const _reviews = <Map<String, dynamic>>[
  {
    'userInitial': 'JP',
    'userFullName': 'Jason P',
    'ratings': 4.5,
    'message': '(Actual user review about the course goes here',
    'reviewedAt': '01/14/2022 02:13PM',
  },
  {
    'userInitial': 'JP',
    'userFullName': 'Jason P',
    'ratings': 4.5,
    'message': '(Actual user review about the course goes here',
    'reviewedAt': '01/14/2022 02:13PM',
  },
  {
    'userInitial': 'JP',
    'userFullName': 'Jason P',
    'ratings': 4.5,
    'message': '(Actual user review about the course goes here',
    'reviewedAt': '01/14/2022 02:13PM',
  },
];

class OnlineCoursesPage extends StatefulWidget {
  const OnlineCoursesPage({super.key});

  @override
  State<OnlineCoursesPage> createState() => _OnlineCoursesPageState();
}

class _OnlineCoursesPageState extends State<OnlineCoursesPage> {
  final GlobalController global = Get.find();
  final isExpandeds = List.generate(3, (index) => false);
  int _currentVideoIndex = 0;

  bool isLocked = true;
  int registrationStep = 0;
  void toggleLock() async {
    if (!global.isAuthenticated.value) {
      global.vroute.navigateTo('/login', redirectPath: '/training');
      return;
    }
    global.trainingInterest.value = TrainingInterest(
      name: 'MagnYm Instant Training',
      tagName: 'MagnYm',
      supportText: 'Register to learn about MagnYm',
      oneTimeFee: 400000, // $4000
    );
    await global.training.initForm();
    global.vroute.navigateTo('/training/register');
  }

  bool isTheaterMode = false;
  void toggleTheaterMode(bool value) {
    setState(() {
      isTheaterMode = false;
    });
  }

  void _onVideoSelect(int index) {
    if (!isLocked || index == 0) {
      setState(() {
        _currentVideoIndex = index;
      });
    }
  }

  Future<void> onInit() async {
    registrationStep = await global.training.trainingsLog['step'];

    if (registrationStep > 4) {
      setState(() {
        isLocked = false;
      });
    }
    print('registration step: $registrationStep');
  }

  @override
  void initState() {
    super.initState();
    onInit();
  }

  @override
  void dispose() {

    super.dispose();
  }
  final _imageRepo = const ImageRepository();

  @override
  Widget build(BuildContext context) {
    return GalaxyPageScaffold(
      padding: EdgeInsets.only(
        top: YLiftConstant.totalTopNavigation + 24,
      ),
      children: [
        if (isTheaterMode) ...[
          GalaxyCourseVideo(
            isTheaterMode: isTheaterMode,
            onToggleTheaterMode: toggleTheaterMode,
            videoUuid: _videoReferences[_currentVideoIndex]['uuid'],
            videoUrl: _imageRepo.getVideoUrl(_videoReferences[_currentVideoIndex]['uuid']!),
          ),
          const GapY(),
        ],
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
              'MagnYm',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Video player
                  if (!isTheaterMode) ...[
                    GalaxyCourseVideo(
                      isTheaterMode: isTheaterMode,
                      onToggleTheaterMode: toggleTheaterMode,
                      videoUuid: _videoReferences[_currentVideoIndex]['uuid'],
                      videoUrl: _imageRepo.getVideoUrl(_videoReferences[_currentVideoIndex]['uuid']!),
                    ),
                    const GapY(),
                  ],

                  const Text('MagnYm Instant Male Enhancement', style: YLiftTextStyle.title),
                  const Text('VIRTUAL'),
                  const Text('Authors: Yan Trokel, MD DDS'),
                  const Text('Location: Online'),
                  if (isLocked) ...[
                  Text('\$4,000.00'),
                  Text('AND \$200.00/Month (Charged Anually)'),
                  const GapY(),

                    YLiftFilledButton(
                    isExpanded: true,
                    onPressed:() {
                      toggleLock();
                    },
                    child: isLocked ? const Text('REGISTER NOW') : const Text('You are registered!'),
                  ),

                  GapY(factor: 2),
                  ExpansionPanelList(
                    expansionCallback: (panelIndex, isExpanded) {
                      setState(() {
                        isExpandeds[panelIndex] = isExpanded;
                      });
                    },
                    children: [
                      // ExpansionPanel(
                      //   isExpanded: isExpandeds[0],
                      //   canTapOnHeader: true,
                      //   headerBuilder: (context, isExpanded) {
                      //     return Center(child: const Text('What you\'ll get'));
                      //   },
                      //   body: const Padding(
                      //     padding: EdgeInsets.all(16),
                      //     child: Text(
                      //       'This course includes:\n'
                      //           '1.) How to perform the various MagnYm® procedures!\n'
                      //           '2.) The science behind neuromodulators, growth factors, and exosomes, and their role in male enhancement.\n'
                      //           '3.) Physiology of erectile function and the history of ED treatments.\n'
                      //           '4.) How to positively affect length and girth of male genitalia.\n'
                      //           '5.) How to diminish Hyper-Active Penile Retraction Reflex.\n'
                      //           '6.) Product preparation and reconstitution.\n'
                      //           '7.) What patients should expect and how to identify who will benefit most from each MagnYm® procedure.\n'
                      //           '8.) Patient consultation and follow up.\n',
                      //     ),
                      //   ),
                      // ),
                      ExpansionPanel(
                        isExpanded: isExpandeds[0],
                        canTapOnHeader: true,
                        headerBuilder: (context, isExpanded) {
                          return const Center(child: Text('What you\'ll learn'));
                        },
                        body: const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'This course includes:\n'
                                '1.) How to perform the various MagnYm® procedures!\n'
                                '2.) The science behind neuromodulators, growth factors, and exosomes, and their role in male enhancement.\n'
                                '3.) Physiology of erectile function and the history of ED treatments.\n'
                                '4.) How to positively affect length and girth of male genitalia.\n'
                                '5.) How to diminish Hyper-Active Penile Retraction Reflex.\n'
                                '6.) Product preparation and reconstitution.\n'
                                '7.) What patients should expect and how to identify who will benefit most from each MagnYm® procedure.\n'
                                '8.) Patient consultation and follow up.\n',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const GapY(factor: 2),
                  ],
                  // Reviews Section
                  // const Text('Course Reviews', style: YLiftTextStyle.title),
                  // SizedBox(
                  //   height: 200,
                  //   child: Row(
                  //     children: [
                  //       Column(
                  //         children: [
                  //           const Text('5.0', style: TextStyle(fontSize: 60)),
                  //           Row(
                  //             children: List.generate(5, (index) => const Icon(Icons.star)),
                  //           )
                  //         ],
                  //       ),
                  //       const GapX(),
                  //       const Column(
                  //         children: [
                  //           StarRatingsIcon(ratings: 5),
                  //           StarRatingsIcon(ratings: 4),
                  //           StarRatingsIcon(ratings: 3),
                  //           StarRatingsIcon(ratings: 2),
                  //           StarRatingsIcon(ratings: 1),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  // const Text('Reviews'),
                  // const Divider(),
                  // ListView.separated(
                  //   shrinkWrap: true,
                  //   itemCount: _reviews.length,
                  //   separatorBuilder: (context, index) => const SizedBox(height: 16),
                  //   itemBuilder: (context, index) {
                  //     final userReview = _reviews[index];
                  //     return Row(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         CircleAvatar(
                  //           radius: 24,
                  //           child: Text(userReview['userInitial']!),
                  //         ),
                  //         const GapX(),
                  //         Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Text(userReview['userFullName']!),
                  //             Text(userReview['reviewedAt']!),
                  //           ],
                  //         ),
                  //         const GapX(),
                  //         Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             StarRatingsIcon(ratings: userReview['ratings']),
                  //             Text(userReview['message']),
                  //           ],
                  //         )
                  //       ],
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
            const GapX(),
            // Video List Container
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 0.4),
                borderRadius: const BorderRadius.all(Radius.circular(16)),
              ),
              width: 400,
              height: 640,
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'MagnYm® Instant Male Enhancement',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text('${_currentVideoIndex + 1}/${_videoReferences.length} videos completed'),
                  Text('${((_currentVideoIndex + 1) / _videoReferences.length * 100).toStringAsFixed(2)}% Completion'),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _videoReferences.length,
                      itemBuilder: (context, index) {
                        final videoReference = _videoReferences[index];
                        final isSelected = index == _currentVideoIndex;
                        final locked = isLocked ? index > 0 : false;

                        return Material(
                          color: locked
                              ? Colors.black38
                              : isSelected
                              ? YLiftColor.khaki.withOpacity(0.3)
                              : Colors.white,
                          child: InkWell(
                            onTap: locked ? null : () => _onVideoSelect(index),
                            child: SizedBox(
                              height: 120,
                              child: Row(
                                children: [
                                  locked
                                      ? const Expanded(
                                    child: Icon(Icons.lock),
                                  )
                                      : Expanded(
                                    child: videoReference['thumbnailUrl'] != null
                                        ? Image.network(videoReference['thumbnailUrl'])
                                        : const PlaceholderImage(fit: BoxFit.cover, placeholderImage: PLACEHOLDER_IMAGE,),
                                  ),
                                  const GapX(),
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            videoReference['title']!,
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                          ),
                                          Text(videoReference['description']!, style: const TextStyle(fontSize: 12)),
                                          Text('8:21 mins'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const GapY(factor: 4),
      ],
    );
  }
}