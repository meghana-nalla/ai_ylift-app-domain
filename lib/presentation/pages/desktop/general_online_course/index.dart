import 'dart:developer';
import 'dart:js_interop' as js;

import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/core/controllers/z-index_export.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:web/web.dart' as web;

import '../../../../core/repositories/image_repository.dart';
import '../../../components/report_issue_button.dart';

class GeneralOnlineCoursesPage extends StatefulWidget {
  const GeneralOnlineCoursesPage({super.key});

  @override
  State<GeneralOnlineCoursesPage> createState() =>
      _GeneralOnlineCoursesPageState();
}

class _GeneralOnlineCoursesPageState extends State<GeneralOnlineCoursesPage> {
  final GlobalController global = Get.find();

  final scrollController = ScrollController();

  TrainingCourse? trainingCourseData;
  List<VideoHeader>? videos;
  int selectedVideoIndex = 0;
  VideoHeader? get selectedVideo => videos?[selectedVideoIndex];

  late VideoPlayerController videoController;
  bool isFullscreen = false;

  String? errorMessage;

  String get videoCourseId => Uri.base.pathSegments.last;

  // Step 1: Fetch video data based on the videoCourseId
  void fetchVideoData(String trainingCourseId) async {
    try {
      //throw Exception('Simulated error for testing');
      setState(() {
        errorMessage = null;
        trainingCourseData = null;
      });

      final trainingCourses = await global.userController.getTrainingCourses();
      trainingCourseData = trainingCourses.firstWhereOrNull(
        (course) => course.name == trainingCourseId,
      );
      videos =
          trainingCourseData!.videos
              .where((element) => element.title != 'Preview')
              .toList();
      // trainingCourseData = global.selectedTrainingCourse.value;
      log('Video data fetched successfully: ${trainingCourseData?.name}');
      initializeVideo(_imageRepo.getVideoUrl(selectedVideo!.id));
    } catch (e) {
      setState(() {
        errorMessage = 'Something went wrong with fetching video data for ID: $videoCourseId\nFunction: fetchVideoData(String videoCourseId) on GeneralOnlineCoursesPage  \nError: $e';
      });
      print('Error fetching video data: $e');
    }
  }

  // Step 2: Initialize the video player with the fetched video data
  void initializeVideo(String videoUrl, {bool autoPlay = false}) async {
    log('Initializing video with URL: $videoUrl');
    videoController = VideoPlayerController.networkUrl(
      Uri.parse(videoUrl),
      videoPlayerOptions: VideoPlayerOptions(
        webOptions: const VideoPlayerWebOptions(
          allowContextMenu: false,
          controls: VideoPlayerWebOptionsControls.disabled(),
        ),
      ),
    );
    videoController.addListener(videoListener);
    await videoController.initialize();
    if (autoPlay) await videoController.play();
    setState(() {
      isFullscreen = web.document.fullscreenElement != null;
      global.hideTopNavigation.value = isFullscreen;
    });
  }

  void listener(web.Event event) {
    setState(() {
      isFullscreen = web.document.fullscreenElement != null;
      global.hideTopNavigation.value = isFullscreen;
    });
  }

  void videoListener() {
    final videoValue = videoController.value;
    if (videoValue.isCompleted && selectedVideoIndex != (videos!.length - 1)) {
      setState(() {
        selectedVideoIndex = (selectedVideoIndex + 1) % videos!.length;
        initializeVideo(
          _imageRepo.getVideoUrl(selectedVideo!.id),
          autoPlay: true,
        );
      });
    }
  }

  @override
  void initState() {
    fetchVideoData(videoCourseId);
    web.document.addEventListener('fullscreenchange', listener.toJS);
    super.initState();
  }

  @override
  void dispose() {
    web.document.removeEventListener('fullscreenchange', listener.toJS);
    videoController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  final _imageRepo = const ImageRepository();

  @override
  Widget build(BuildContext context) {
    if (errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_outlined),
              Text('Something went wrong when fetching video $videoCourseId'),
              Text(
                'If the problem persists, please contact ${YLiftConstant.yliftPhoneNumber} or ${YLiftConstant.yliftEmail}',
                style: TextStyle(fontSize: 13.33),
              ),
              const SizedBox(height: 8),
              ReportIssueButton(errorMessage: errorMessage!),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () {
                  fetchVideoData(videoCourseId);
                },
                label: const Text('Retry'),
                icon: Icon(Icons.refresh_outlined),
              ),
            ],
          ),
        ),
      );
    }

    if (selectedVideo == null || trainingCourseData == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (isFullscreen) {
      return VideoFullscreenView(
        videoController,
        onFullscreenToggle: (value) {
          setState(() {
            isFullscreen = value;
            global.hideTopNavigation.value = isFullscreen;
          });
        },
      );
    }

    return GalaxyPageScaffold(
      scrollController: scrollController,
      children: [
        // Breadcrumbs
        Row(
          children: [
            GestureDetector(
              onTap: () {
                global.vroute.navigateTo('/courses');
              },
              child: Text(
                'Training Courses  /  ',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
            Text(
              trainingCourseData!.name,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 32),
        GalaxyVideoPlayer(
          controller: videoController,
          onFullscreenToggle: (value) {
            setState(() {
              isFullscreen = value;
              global.hideTopNavigation.value = isFullscreen;
            });
          },
          errorMessage:
              'Something went wrong when loading ${selectedVideo?.title}\n'
              'If the problem persists, please contact ${YLiftConstant.yliftPhoneNumber} or ${YLiftConstant.yliftEmail}',
        ),

        const SizedBox(height: 32),
        Text(
          selectedVideo!.title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(selectedVideo!.description),

        const Divider(height: 64),
        Column(
          children: List.generate(videos!.length, (index) {
            final video = videos![index];
            final isSelected =
                video.title == selectedVideo!.title &&
                video.id == selectedVideo!.id;

            return _VideoTile(
              video: video,
              isSelected: isSelected,
              onTap: () {
                if (isSelected) return;
                setState(() {
                  selectedVideoIndex = index;
                });
                initializeVideo(
                  _imageRepo.getImageUrl(selectedVideo!.id),
                  autoPlay: true,
                );
                scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
            );
          }, growable: false),
        ),
        const SizedBox(height: 64),
      ],
    );

    // if (trainingCourse == null || trainingCourse!.videos.isEmpty) {
    //   return const Center(child: CircularProgressIndicator());
    // }
    //
    // final videos = trainingCourse!.videos;
    //
    // return GalaxyPageScaffold(
    //   children: [
    //     if (isTheaterMode) ...[
    //       GalaxyCourseVideo(
    //         isTheaterMode: isTheaterMode,
    //         onToggleTheaterMode: toggleTheaterMode,
    //         videoUuid: videos[_currentVideoIndex].id,
    //         videoUrl: _imageRepo.getVideoUrl(videos[_currentVideoIndex].id),
    //         // videoUuid: _videoReferences[_currentVideoIndex]['uuid'],
    //       ),
    //       const GapY(),
    //     ],
    //     Row(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Expanded(
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               // Video player
    //               if (!isTheaterMode) ...[
    //                 GalaxyCourseVideo(
    //                   isTheaterMode: isTheaterMode,
    //                   onToggleTheaterMode: toggleTheaterMode,
    //                   videoUuid: videos[_currentVideoIndex].id,
    //                   videoUrl: _imageRepo.getVideoUrl(videos[_currentVideoIndex].id),
    //                 ),
    //                 const GapY(),
    //               ],
    //               Text(videos[_currentVideoIndex].title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    //               Text(videos[_currentVideoIndex].description, style: TextStyle(fontSize: 13.33)),
    //               const GapY(factor: 2),
    //             ],
    //           ),
    //         ),
    //         const GapX(),
    //         // Video List Container
    //         Container(
    //           decoration: BoxDecoration(
    //             border: Border.all(width: 0.4),
    //             borderRadius: const BorderRadius.all(Radius.circular(16)),
    //           ),
    //           width: 400,
    //           height: 640,
    //           padding: const EdgeInsets.all(8),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text(
    //                 trainingCourse!.name,
    //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    //               ),
    //               const SizedBox(height: 16),
    //               // Text('${_currentVideoIndex + 1}/${videos.length} videos completed'),
    //               // Text('${((_currentVideoIndex + 1) / videos.length * 100).toStringAsFixed(2)}% Completion'),
    //               Expanded(
    //                 child: ListView.builder(
    //                   itemCount: videos.length,
    //                   itemBuilder: (context, index) {
    //                     final videoReference = videos[index];
    //                     final isSelected = index == _currentVideoIndex;
    //                     final locked = isLocked ? index > 0 : false;
    //
    //                     return Material(
    //                       color: locked
    //                           ? Colors.black38
    //                           : isSelected
    //                               ? YLiftColor.khaki.withOpacity(0.3)
    //                               : Colors.white,
    //                       child: InkWell(
    //                         onTap: locked ? null : () => _onVideoSelect(index),
    //                         child: SizedBox(
    //                           height: 120,
    //                           child: Row(
    //                             children: [
    //                               locked
    //                                   ? const Expanded(
    //                                       child: Icon(Icons.lock),
    //                                     )
    //                                   : Expanded(
    //                                       child: videoReference.thumbnailUrl != null
    //                                           ? Image.network(videoReference.thumbnailUrl!)
    //                                           // : const PlaceholderImage(fit: BoxFit.cover),
    //                                           : Padding(
    //                                         padding: const EdgeInsets.symmetric(vertical: 40),
    //                                           child: Image.asset('msc/images/ys_logo.png')
    //                                       ),
    //                                     ),
    //                               const GapX(),
    //                               Expanded(
    //                                 flex: 2,
    //                                 child: Padding(
    //                                   padding: const EdgeInsets.symmetric(vertical: 8.0),
    //                                   child: Column(
    //                                     mainAxisAlignment: MainAxisAlignment.center,
    //                                     crossAxisAlignment: CrossAxisAlignment.start,
    //                                     children: [
    //                                       Text(
    //                                         videoReference.title,
    //                                         style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    //                                       ),
    //                                       Text(videoReference.description, style: const TextStyle(fontSize: 12)),
    //                                       // Text('8:21 mins'),
    //                                     ],
    //                                   ),
    //                                 ),
    //                               ),
    //                             ],
    //                           ),
    //                         ),
    //                       ),
    //                     );
    //                   },
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //     const GapY(factor: 4),
    //   ],
    // );
  }
}

class _VideoTile extends StatelessWidget {
  final VideoHeader video;
  final bool isSelected;
  final void Function() onTap;

  const _VideoTile({
    super.key,
    required this.video,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        side: isSelected ? BorderSide() : BorderSide.none,
      ),
      color: isSelected ? Colors.grey.shade100 : Colors.white,
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    video.description,
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              const Spacer(),
              if (isSelected) Text('Currently Playing'),
            ],
          ),
        ),
      ),
    );
  }
}
