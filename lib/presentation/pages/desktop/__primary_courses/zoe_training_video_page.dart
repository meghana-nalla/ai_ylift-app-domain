import 'dart:js_interop' as js;
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/components/_complex/desktop_view/page_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:web/web.dart' as web;

// const _zoeTrainingVideoUrl = 'https://media.stage.ylift.app/api/video/stream/0b1e1d59-a22e-448b-bb80-1383607b9c1f'; the correct url
const _zoeTrainingVideoUrl = 'https://media.stage.ylift.app/api/video/stream/0b1e1d59-a22e-448b-bb80-1383607b9c1f';
class ZoeTrainingVideoPage extends StatefulWidget {
  const ZoeTrainingVideoPage({super.key});

  @override
  State<ZoeTrainingVideoPage> createState() => _ZoeTrainingVideoPageState();
}

class _ZoeTrainingVideoPageState extends State<ZoeTrainingVideoPage> {
  final global = Get.find<GlobalController>();
  bool isSafari = false;
  bool _videoTimedOut = false;

  late final VideoPlayerController _videoController;
  bool isVideoPlaying = false;

  bool isFullscreen = false;
  double videoVolume = 1.0; // Default volume level

  late Future<void> _initializeVideoFuture;

  void videoListener() {
    setState(() {
      isVideoPlaying = _videoController.value.isPlaying;
      videoVolume = _videoController.value.volume;
    });
  }

  @override
  void initState() {
    super.initState();

    // Detect Safari
    final userAgent = web.window.navigator.userAgent.toLowerCase();
    isSafari = userAgent.contains("safari") && !userAgent.contains("chrome");

    final hasZoeTrainingVideo = global.user.value.virtualContent?.any(
          (content) => content.virtualProductId == '6837417548bb1452c7ae97b1',
    ) ??
        false;

    if (global.isAuthenticated.value && hasZoeTrainingVideo && !isSafari) {
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(_zoeTrainingVideoUrl),
        videoPlayerOptions: VideoPlayerOptions(
          webOptions: VideoPlayerWebOptions(
            allowContextMenu: false,
            controls: VideoPlayerWebOptionsControls.disabled(),
          ),
        ),
      );

      _initializeVideoFuture = _videoController.initialize().timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          _videoTimedOut: true;
          return Future.error(
            Exception('Video initialization timed out'),
          );
        },
      );
      _videoController.addListener(videoListener);
    } else if (!global.isAuthenticated.value || !hasZoeTrainingVideo) {
      global.vroute.navigateTo('/courses');
    }
  }


  @override
  void dispose() {
    if (!isSafari) {
      _videoController.dispose();
    }

    web.document.removeEventListener(
      'fullscreenchange',
      ((web.Event event) {
        setState(() {
          isFullscreen = web.document.fullscreenElement != null;
          global.hideTopNavigation.value = isFullscreen;
        });
      }).toJS,
    );

    super.dispose();
  }


  void toggleVideoPlayback() {
    if (_videoController.value.isPlaying) {
      _videoController.pause();
    } else {
      _videoController.play();
    }
  }

  @override
  Widget build(BuildContext context) {

    if (isFullscreen) {
      return Scaffold(
        body: Center(
          child: AspectRatio(
            aspectRatio: _videoController.value.aspectRatio,
            child: Stack(
              alignment: Alignment.center,
              children: [
                VideoPlayer(_videoController),
                if (!isVideoPlaying)
                  const Icon(
                    Icons.play_circle_fill,
                    size: 120,
                    color: Colors.white,
                  ),
                ...buildVideoControllers(),
              ],
            ),
          ),
        ),
      );
    }

    return FutureBuilder(
      future: isSafari ? Future.value() : _initializeVideoFuture,
      builder: (context, snapshot) {
        if (!isSafari && snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final bool showFallback = isSafari || _videoTimedOut || snapshot.hasError;

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
                  'Zoe Training',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.black12,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: isSafari
                    ? Container(
                  width: double.infinity,
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        'https://media.stage.ylift.app/api/optimized/variant/image/file/4d512e3c-6496-4c4e-9340-268ea9936809',
                        height: 300,

                      ),
                    ],

                  ),
                )
                    : AspectRatio(
                  //aspectRatio: _videoController.value.aspectRatio,
                  aspectRatio: 16 / 9,

                  child: showFallback
                      ? Container(
                    color: Colors.black12,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          'https://media.stage.ylift.app/api/optimized/variant/image/file/e227976a-75f5-4dd5-8c21-3d8877e075a0',
                          height: 500,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Video not available right now, please try again later or contact support.',
                          style: TextStyle(fontSize: 32, color: Colors.black),
                        ),

                      ],
                    ),
                  )

                    :Stack(
                    alignment: Alignment.center,
                    children: [
                      VideoPlayer(_videoController),
                      if (!isVideoPlaying)
                        const Icon(Icons.play_circle_fill, size: 120, color: Colors.white),
                      ...buildVideoControllers(),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
            Text(
              'Master the Advanced Brazilian HDR Technique with Dr. Zoe Flor',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Dr. Zoe Flor, DNP FNP-C',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'Board-Certified Doctorate Nurse Practitioner',
              style: TextStyle(fontSize: 13.33),
            ),

            Divider(height: 64),
            Text(
              'Course Overview',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'The Brazilian HDR BBL technique is a non-invasive body contouring procedure using Radiesse to enhance the buttocks by focusing on a shapely, athletic butt. This procedure differs to those being done by everyone else because of the placement and focus of the enhancement being done. Instead of focusing on large volume to create a big butt, the Brazilian HDR BBL focuses on actually shaping the glutes by applying the product on the lateral aspects of the butt creating a shapely butt vs a large butt.  This procedure involves no downtime or aftercare making it a convenient and safer option than surgery.',
            ),
            const SizedBox(height: 32),
            // Video Chapters
            ChapterSection(
              chapterTitle: 'Chapter 1 - Introduction & HDR Preparation',
              lessons: [
                Lesson(
                  name: 'HDR Preparation',
                  position: Duration(seconds: 0),
                ),
                Lesson(
                  name: 'Mixing Process',
                  position: Duration(minutes: 1, seconds: 1),
                ),
              ],
              onLessonTapped: (lesson) {
                // Handle lesson selection
                _videoController.seekTo(lesson.position);
                if (!isVideoPlaying) {
                  toggleVideoPlayback();
                }
              },
            ),
            const SizedBox(height: 32),
            ChapterSection(
              chapterTitle: 'Chapter 2 - Patient 1 Demo',
              lessons: [
                Lesson(
                  name: 'Procedure Overview & Marking',
                  position: Duration(minutes: 4, seconds: 51),
                ),
                Lesson(
                  name: 'Numbing',
                  position: Duration(minutes: 6, seconds: 1),
                ),
                Lesson(
                  name: 'Inject Radiesse with Lidocaine',
                  position: Duration(minutes: 6, seconds: 34),
                ),
                Lesson(
                  name: 'Inject Plain Syringes with Radiesse',
                  position: Duration(minutes: 9, seconds: 13),
                ),
                Lesson(
                  name: 'One-Side Showcase',
                  position: Duration(minutes: 15, seconds: 5),
                ),
                Lesson(
                  name: 'Repeat On The Other Side',
                  position: Duration(minutes: 15, seconds: 38),
                ),
                Lesson(
                  name: 'Before-and-After-Showcase',
                  position: Duration(minutes: 24, seconds: 20),
                ),
              ],
              onLessonTapped: (lesson) {
                // Handle lesson selection
                _videoController.seekTo(lesson.position);
                if (!isVideoPlaying) {
                  toggleVideoPlayback();
                }
              },
            ),
            const SizedBox(height: 32),
            ChapterSection(
              chapterTitle: 'Chapter 3 - Patient 2 Demo',
              lessons: [
                Lesson(
                  name: 'Procedure Overview & Preparation',
                  position: Duration(minutes: 24, seconds: 52),
                ),
                Lesson(
                  name: 'Injections',
                  position: Duration(minutes: 26, seconds: 29),
                ),
                Lesson(
                  name: 'Before-and-After & Testimonial',
                  position: Duration(minutes: 31, seconds: 50),
                ),
              ],
              onLessonTapped: (lesson) {
                // Handle lesson selection
                _videoController.seekTo(lesson.position);
                if (!isVideoPlaying) {
                  toggleVideoPlayback();
                }
              },
            ),
            const SizedBox(height: 64),
          ],
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  List<Widget> buildVideoControllers() {
    return [
      GestureDetector(
        onTap: toggleVideoPlayback,
        child: Container(
          color: Colors.transparent,
          width: double.infinity,
          height: double.infinity,
        ),
      ),

      // Progress bar
      Positioned(
        bottom: 58,
        left: 0,
        right: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: VideoProgressIndicator(
            _videoController,
            allowScrubbing: true,
            colors: const VideoProgressColors(
              playedColor: Colors.white,
              bufferedColor: Colors.white54,
              backgroundColor: Colors.grey,
            ),
          ),
        ),
      ),

      Positioned(
        bottom: 8,
        left: 16,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Play / Pause',
              onPressed: () {
                toggleVideoPlayback();
              },
              icon:
                  isVideoPlaying
                      ? const Icon(Icons.pause)
                      : const Icon(Icons.play_arrow),
              color: Colors.white,
            ),

            // Skip 10 seconds backward
            IconButton(
              tooltip: 'Skip Backward 10s',
              icon: const Icon(Icons.replay_10),
              onPressed: () {
                final newPosition =
                    _videoController.value.position -
                    const Duration(seconds: 10);
                if (newPosition >= Duration.zero) {
                  _videoController.seekTo(newPosition);
                } else {
                  _videoController.seekTo(Duration.zero);
                }
              },
              color: Colors.white,
            ),

            // Skip 10 seconds forward
            IconButton(
              tooltip: 'Skip Forward 10s',
              icon: const Icon(Icons.forward_10),
              onPressed: () {
                final newPosition =
                    _videoController.value.position +
                    const Duration(seconds: 10);
                if (newPosition < _videoController.value.duration) {
                  _videoController.seekTo(newPosition);
                }
              },
              color: Colors.white,
            ),

            // Volume control
            IconButton(
              tooltip: 'Volume',
              icon: Icon(
                _videoController.value.volume > 0
                    ? Icons.volume_up
                    : Icons.volume_off,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  if (_videoController.value.volume > 0) {
                    _videoController.setVolume(0);
                  } else {
                    _videoController.setVolume(1);
                  }
                });
              },
              color: Colors.white,
            ),
            Slider(
              activeColor: Colors.white,
              thumbColor: Colors.white,
              value: _videoController.value.volume,
              min: 0,
              max: 1,
              onChanged: (value) {
                _videoController.setVolume(value);
              },
            ),
            const SizedBox(width: 8),

            // Duration/Position indicator
            Text(
              '${_formatDuration(_videoController.value.position)} / ${_formatDuration(_videoController.value.duration)}',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),

      // Fullscreen button
      Positioned(
        bottom: 12,
        right: 16,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Playback Speed',
              onPressed: () {
                setState(() {
                  if (_videoController.value.playbackSpeed == 1.0) {
                    _videoController.setPlaybackSpeed(2.0);
                  } else {
                    _videoController.setPlaybackSpeed(1.0);
                  }
                });
              },
              icon: Text(
                _videoController.value.playbackSpeed > 1.0 ? '1X' : '2X',
                style: TextStyle(color: Colors.white),
              ),
            ),
            IconButton(
              tooltip: isFullscreen ? 'Exit Fullscreen' : 'Enter Fullscreen',
              onPressed: () async {
                if (!isFullscreen) {
                  await web.document.documentElement
                      ?.requestFullscreen()
                      .toDart;
                } else {
                  await web.document.exitFullscreen().toDart;
                }

                setState(() {
                  isFullscreen = web.document.fullscreenElement != null;
                  global.hideTopNavigation.value = isFullscreen;
                });
                if (_videoController.value.isPlaying) {
                  await Future.delayed(const Duration(milliseconds: 100));
                  await _videoController.play();
                }
              },
              icon:
                  isFullscreen
                      ? const Icon(Icons.fullscreen_exit)
                      : const Icon(Icons.fullscreen),
              color: Colors.white,
            ),
          ],
        ),
      ),
    ];
  }
}

class Lesson {
  final String name;
  final Duration position;

  const Lesson({
    required this.name,
    required this.position,
  });
}

class ChapterSection extends StatelessWidget {
  final String chapterTitle;
  final List<Lesson> lessons;
  final void Function(Lesson lesson) onLessonTapped;

  const ChapterSection({
    super.key,
    required this.chapterTitle,
    required this.lessons,
    required this.onLessonTapped,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade300),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      collapsedShape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade300),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      initiallyExpanded: true,
      title: Text(
        chapterTitle,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      children:
          lessons.map((e) {
            return ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(e.name),
                  Text(
                    '${e.position.inMinutes}:${(e.position.inSeconds % 60).toString().padLeft(2, '0')}',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
              onTap: () => onLessonTapped(e),
            );
          }).toList(),
    );
  }
}
