import 'package:YLift/core/constants/index.dart';
import 'package:YLift/core/constants/text_style.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/presentation/components/_complex/desktop_view/gap.dart';
import 'package:YLift/presentation/components/_complex/desktop_view/page_scaffold.dart';

import 'package:YLift/presentation/components/_simple/star_ratings_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:galaxy_ui/galaxy_ui.dart';

import '../../../../core/repositories/image_repository.dart';

class BootYLiftCoursePage extends StatefulWidget {
  const BootYLiftCoursePage({super.key});

  @override
  State<BootYLiftCoursePage> createState() => _BootYLiftCoursePageState();
}

class _BootYLiftCoursePageState extends State<BootYLiftCoursePage> {
  final  global = Get.find<GlobalController>();
  final isExpandeds = List.generate(3, (index) => false);
  int _currentVideoIndex = 0;
  late TrainingCourse trainingCourse;

  bool isLocked = true;
  void toggleLock() {

    global.trainingInterest.value.tagName = 'BootYLift';
    global.trainingInterest.value.name = 'BootYLift Training';
    global.vroute.navigateTo('/training/register');
  }

  bool isTheaterMode = false;
  void toggleTheaterMode(bool value) {
    setState(() {
      isTheaterMode = value;
    });
  }

  void _onVideoSelect(int index) {
    if (!isLocked || index == 0) {
      setState(() {
        _currentVideoIndex = index;
      });
    }
  }
  
  @override
  void initState() {
    super.initState();
    // if (global.trainingCourseVideo.length > 0) {
    //   trainingCourse = global.trainingCourseVideo.firstWhere((x) => x.name == "BootyLift");
    // }
  }
  final _imageRepo = const ImageRepository();

  @override
  Widget build(BuildContext context) {
    return
      GalaxyPageScaffold(
      children: [
        if (isTheaterMode) ...[
          GalaxyCourseVideo(
            isTheaterMode: isTheaterMode,
            onToggleTheaterMode: toggleTheaterMode,
            videoUuid: trainingCourse.videos[_currentVideoIndex].id,
            videoUrl: _imageRepo.getVideoUrl(trainingCourse.videos[_currentVideoIndex].id),

          ),
          const GapY(),
        ],
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
                      videoUuid: trainingCourse.videos[_currentVideoIndex].id,
                      videoUrl: _imageRepo.getVideoUrl(trainingCourse.videos[_currentVideoIndex].id),
                    ),
                    const GapY(),
                  ],

                  const Text('BootyLift Instant Women Enhancement', style: YLiftTextStyle.title),
                  Text('VIRTUAL and HANDS ON'),
                  Text('Authors: Yan Trokel, MD DDS'),
                  Text('Location: Online'),
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
                      ExpansionPanel(
                        isExpanded: isExpandeds[0],
                        canTapOnHeader: true,
                        headerBuilder: (context, isExpanded) {
                          return Center(child: const Text('What you\'ll get'));
                        },
                        body: const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'This course includes:\n'
                                '1.) How to perform the various MagnYm® procedures VIRTUAL and LIVE!\n'
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
                      ExpansionPanel(
                        isExpanded: isExpandeds[1],
                        canTapOnHeader: true,
                        headerBuilder: (context, isExpanded) {
                          return const Center(child: Text('What you\'ll learn'));
                        },
                        body: const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'This course includes:\n'
                                '1.) How to perform the various MagnYm® procedures VIRTUAL and LIVE!\n'
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

                  // Reviews Section
                  const Text('Course Reviews', style: YLiftTextStyle.title),
                  SizedBox(
                    height: 200,
                    child: Row(
                      children: [
                        Column(
                          children: [
                            const Text('5.0', style: TextStyle(fontSize: 60)),
                            Row(
                              children: List.generate(5, (index) => const Icon(Icons.star)),
                            )
                          ],
                        ),
                        const GapX(),
                        const Column(
                          children: [
                            StarRatingsIcon(ratings: 5),
                            StarRatingsIcon(ratings: 4),
                            StarRatingsIcon(ratings: 3),
                            StarRatingsIcon(ratings: 2),
                            StarRatingsIcon(ratings: 1),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const Text('Reviews'),
                  const Divider(),
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: _reviews.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final userReview = _reviews[index];
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 24,
                            child: Text(userReview['userInitial']!),
                          ),
                          const GapX(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(userReview['userFullName']!),
                              Text(userReview['reviewedAt']!),
                            ],
                          ),
                          const GapX(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              StarRatingsIcon(ratings: userReview['ratings']),
                              Text(userReview['message']),
                            ],
                          )
                        ],
                      );
                    },
                  ),
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
                  Text('${_currentVideoIndex + 1}/${trainingCourse.videos!.length} videos completed'),
                  Text('${((_currentVideoIndex + 1) / trainingCourse.videos!.length * 100).toStringAsFixed(2)}% Completion'),
                  Expanded(
                    child: ListView.builder(
                      itemCount: trainingCourse.videos!.length,
                      itemBuilder: (context, index) {
                        final videoReference = trainingCourse.videos![index];
                        final isSelected = index == _currentVideoIndex;
                        final locked = isLocked ? index > 0 : false;

                        return Material(
                          color: locked
                              ? Colors.black38
                              : isSelected
                              ? YLiftColor.khaki.withOpacity(0.3)
                              : null,
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
                                    child: videoReference.thumbnailUrl != null
                                        ? Image.network(videoReference.thumbnailUrl!)
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
                                            videoReference.title,
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                          ),
                                          Text(videoReference.description, style: const TextStyle(fontSize: 12)),
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

// const _videoReferences = <Map<String, dynamic>>[
//   {
//     'uuid': '36cec623-4448-4ac2-9bc7-a14e299e2396',
//     'thumbnailUrl': null,
//     'title': 'Preview',
//     'description': 'MagNym Preview',
//   },
//   {
//     'uuid': '36cec623-4448-4ac2-9bc7-a14e299e2396',
//     'thumbnailUrl': null,
//     'title': 'MagnYm Introduction',
//     'description': 'What do men really want?',
//   },
//   {
//     'uuid': '05b8b7cc-c30b-480b-9c01-ba9e99d836d0',
//     'thumbnailUrl': null,
//     'title': 'MagnYm Didactics',
//     'description': 'Dr Rovert Valenzuela\'s MagnYm Didactic',
//   },
//   {
//     'uuid': 'baaa6c0c-982f-4e22-a517-b4588c9e14cf',
//     'thumbnailUrl': null,
//     'title': 'MagnYm Product Preparation',
//     'description': 'Preparing Dysport for MagnYm',
//   },
//   {
//     'uuid': 'd1f15d71-028c-47fb-826f-ffd849dbc8d3',
//     'thumbnailUrl': null,
//     'title': 'MagnYm Product Procedure Part 1',
//     'description': 'Preparing Dysport for MagnYm',
//   },
//   {
//     'uuid': '116838a1-7d7c-4349-97b3-7d1e31c499b8',
//     'thumbnailUrl': null,
//     'title': 'MagnYm Product Procedure Part 2',
//     'description': 'Preparing Dysport for MagnYm',
//   },
//   {
//     'uuid': '8d9c8c0a-248c-4731-9a95-f51573e04c91',
//     'thumbnailUrl': null,
//     'title': 'MagnYm Product Preparation',
//     'description': 'Preparing Jeuveau for MagnYm',
//   },
//   {
//     'uuid': '8f1b1cf4-cbcf-49ea-895e-379ed786c7c4',
//     'thumbnailUrl': null,
//     'title': 'MagnYm Product Procedure Part 1',
//     'description': 'Preparing Jeuveau for MagnYm',
//   },
//   {
//     'uuid': 'fba98af4-1427-4f44-9dde-1f580dd2d5ae',
//     'thumbnailUrl': null,
//     'title': 'MagnYm Product Procedure Part 2',
//     'description': 'Preparing Jeuveau for MagnYm',
//   },
// ];

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
