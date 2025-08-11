import 'dart:developer';
import 'dart:js_interop' as js;

import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:dio/dio.dart';
import 'package:galaxy_models/galaxy_models.dart' hide VideoTimestamp;
import 'package:YLift/presentation/components/_complex/desktop_view/page_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:YLift/core/controllers/z-index_export.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:get/get.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:video_player/video_player.dart';
import 'package:web/web.dart' as web;

class MobileOnlineCoursePage extends StatefulWidget {
  const MobileOnlineCoursePage({super.key});

  @override
  State<MobileOnlineCoursePage> createState() => _OnlineCoursePageState();
}

class _OnlineCoursePageState extends State<MobileOnlineCoursePage> {
  final global = Get.find<GlobalController>();

  VideoCourseData? videoData;
  String? errorMessage;
  final controller = Get.find<GlobalController>();

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

  void fetchVideoData(String videoCourseId) async {
    try {
      setState(() {
        errorMessage = null;
        this.videoData = null;
      });
      log('Fetching video data for ID: $videoCourseId');
      final virtualProduct = global.allVirtualProducts.value.virtualProducts.firstWhere((element) => element.id == videoCourseId);
      final subtitleUrl = virtualProduct.metadata['subtitleUrl'];
      var videoData = await global.products.getVideoData(videoCourseId);
      videoData = videoData.copyWith(description: virtualProduct.description, subtitleUrl: subtitleUrl);

      setState(() {
        this.videoData = videoData;
        if (videoData.subtitleUrl != null && videoData.subtitleUrl!.isNotEmpty) {
          _subtitleFile = getSubtitleFile(subtitleUrl);
        }
      });
      log('Video data fetched successfully: ${videoData.title}');
      initializeVideo(videoData.videoUrl);
    } catch (e) {
      setState(() {
        errorMessage = '';
      });
    }
  }

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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_outlined),
              Text('Something went wrong when fetching video $videoCourseId'),
              Text(
                'If the problem persists, please contact ${YLiftConstant.yliftPhoneNumber} or ${YLiftConstant.yliftEmail}',
                style: const TextStyle(fontSize: 13.33),
              ),
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
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (isFullscreen) {
      return VideoMobileFullscreenView(
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

    return SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 32), // Leave space for the IconButton
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
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    child: Text(
                      videoData!.title,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    width: double.infinity,

                    child: Text(
                      videoData!.author.name,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: Text(
                      videoData!.author.title,
                      style: const TextStyle(fontSize: 13.33),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const Divider(height: 64),
                  Container(
                    width: double.infinity,
                    child: const Text(
                      'Course Overview',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                      child: Text(videoData!.description, style: const TextStyle(fontSize: 13))),
                  const SizedBox(height: 32),
                  Column(
                    spacing: 32,
                    children: videoData!.chapters.map((chapter) {
                      SizedBox(height: 16);
                      return MobileVideoChapterPanel(
                        title: chapter.name,
                        timestamps: chapter.timestamps.map((e) {
                          return VideoTimestamp(name: e.name, position: e.position);
                        }).toList(),
                        onTimestampPressed: (timestamp) {
                          videoController.seekTo(timestamp.position);
                          if (!videoController.value.isPlaying) {
                            videoController.play();
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 64),
                ],
              ),
            ),
          ),
          Positioned(
            top: 8,
            left: 8,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                controller.vroute.navigateTo('/courses');
              },
            ),
          ),
        ],
      ),
    );
  }
}
