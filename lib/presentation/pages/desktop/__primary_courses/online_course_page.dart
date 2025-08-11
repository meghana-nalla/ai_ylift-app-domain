import 'dart:developer';
import 'dart:js_interop' as js;

import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/components/report_issue_button.dart';
import 'package:dio/dio.dart';
import 'package:galaxy_models/galaxy_models.dart' hide VideoTimestamp;
import 'package:YLift/presentation/components/_complex/desktop_view/page_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:web/web.dart' as web;

class OnlineCoursePage extends StatefulWidget {
  const OnlineCoursePage({super.key});

  @override
  State<OnlineCoursePage> createState() => _OnlineCoursePageState();
}

class _OnlineCoursePageState extends State<OnlineCoursePage> {
  final global = Get.find<GlobalController>();

  VideoCourseData? videoData;
  String? errorMessage;

  bool doesNotHaveAccess = false;

  late VideoPlayerController videoController;
  bool isFullscreen = false;

  bool showCaptionClosed = false;
  
  Future<ClosedCaptionFile>? _subtitleFile;
  Future<ClosedCaptionFile> getSubtitleFile(String subtitleUrl) async {
    final dio = Dio();
    final response = await dio.get(subtitleUrl);
    return SubRipCaptionFile(response.data);
  }
  
  String get videoCourseId => Uri.base.pathSegments.last;

  // Step 1: Fetch video data based on the videoCourseId
  void fetchVideoData(String videoCourseId) async {
    try {
      //throw Exception('Simulated error for testing');
      setState(() {
        errorMessage = null;
        this.videoData = null;
      });
      log('Fetching video data for ID: $videoCourseId');
      final virtualProduct = global.allVirtualProducts.value.virtualProducts.firstWhere((element) => element.id == videoCourseId);
      final subtitleUrl = virtualProduct.metadata['subtitleUrl'];
      var videoData = await global.products.getVideoData(videoCourseId);
      videoData = videoData.copyWith(description: virtualProduct.description, subtitleUrl: subtitleUrl);
      //subtitle url https://d26n8ibxbj8243.cloudfront.net/optimized/custom_images/belotero_subtitle.srt

      setState(() {
        this.videoData = videoData;
        if(videoData.subtitleUrl != null && videoData.subtitleUrl!.isNotEmpty) _subtitleFile = getSubtitleFile(subtitleUrl);
      });
      log('Video data fetched successfully: ${videoData.title}');
      initializeVideo(videoData.videoUrl);
    } catch (e) {
      setState(() {
        errorMessage = 'Something went wrong with fetching video data for ID: $videoCourseId\nFunction: fetchVideoData(String videoCourseId) \nError: $e';
      });
      // print('Error fetching video data: $e');
    }
  }

  // Step 2: Initialize the video player with the fetched video data
  void initializeVideo(String videoUrl) async {
    videoController = VideoPlayerController.networkUrl(
      Uri.parse(videoUrl),
      videoPlayerOptions: VideoPlayerOptions(
        webOptions: const VideoPlayerWebOptions(
          allowContextMenu: false,
          controls: VideoPlayerWebOptionsControls.disabled(),
        ),
      ),
    );
    await videoController.initialize();
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

  @override
  void initState() {
    fetchVideoData(videoCourseId);
    web.document.addEventListener('fullscreenchange', listener.toJS);
    super.initState();
  }

  @override
  void dispose() {
    web.document.removeEventListener('fullscreenchange', listener.toJS);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline_outlined,
                size: 48,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Something went wrong when fetching video $videoCourseId',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'If the problem persists, please contact ${YLiftConstant.yliftPhoneNumber} or ${YLiftConstant.yliftEmail}',
                style: const TextStyle(fontSize: 13.33),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              ReportIssueButton(errorMessage: errorMessage!),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () {
                  fetchVideoData(videoCourseId);
                },
                label: const Text('Retry'),
                icon: const Icon(Icons.refresh_outlined),
              ),
            ],
          ),
        ),
      );
    }

    if (videoData == null) {
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
        showClosedCaption: showCaptionClosed,
        closedCaptionFile: _subtitleFile,
        onClosedCaptionToggle: (value) {
          setState(() {
            showCaptionClosed = value;
          });
        },
      );
    }

    return GalaxyPageScaffold(
      children: [
        // Breadcrumbs
        Row(
          children: [
            GestureDetector(
              onTap: () {
                global.vroute.navigateTo('/courses');
              },
              child: Text(
                'Online Courses  /  ',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
            Text(
              videoData!.title,
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
          showClosedCaption: showCaptionClosed,
          closedCaptionFile: _subtitleFile,
          onClosedCaptionToggle: (value) {
            setState(() {
              showCaptionClosed = value;
            });
          },
        ),

        const SizedBox(height: 32),
        Text(
          videoData!.title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          videoData!.author.name,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          videoData!.author.title,
          style: TextStyle(fontSize: 13.33),
        ),

        Divider(height: 64),
        Text(
          'Course Overview',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(videoData!.description),
        const SizedBox(height: 32),
        Column(
          spacing: 32,
          children:
              videoData!.chapters.map(
                (chapter) {
                  return VideoChapterPanel(
                    title: chapter.name,
                    timestamps:
                        chapter.timestamps
                            .map(
                              (e) => VideoTimestamp(
                                name: e.name,
                                position: e.position,
                              ),
                            )
                            .toList(),
                    onTimestampPressed: (timestamp) {
                      videoController.seekTo(timestamp.position);
                      if (!videoController.value.isPlaying) {
                        videoController.play();
                      }
                    },
                  );
                },
              ).toList(),
        ),
        const SizedBox(height: 64),
      ],
    );
  }
}
