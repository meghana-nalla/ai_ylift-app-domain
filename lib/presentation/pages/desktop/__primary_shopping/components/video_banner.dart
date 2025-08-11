import 'package:YLift/hardcodes/promotions/summer_glow_july_15/summer_glow_promotion.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoBanner extends StatelessWidget {
  final VideoPlayerController? controller;
  final String? thumbnailUrl;

  final void Function()? onTap;
  final void Function()? onEnter;
  final void Function()? onExit;

  const VideoBanner({
    super.key,
    required this.controller,
    this.thumbnailUrl,
    this.onTap,
    this.onEnter,
    this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    if (controller == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ColoredBox(
      color: Colors.white,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: ValueListenableBuilder(
          valueListenable: controller!,
          builder: (context, value, child) {
            if (value.hasError) {
              if (thumbnailUrl != null) {
                return Image.network(
                  thumbnailUrl!,
                  fit: BoxFit.cover,
                );
              }
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.black),
                    const Text(
                      'Unable to load promotion video.',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              );
            }
            return Stack(
              children: [
                VideoPlayer(controller!),
                MouseRegion(
                  cursor:
                      onTap != null
                          ? SystemMouseCursors.click
                          : MouseCursor.defer,
                  onEnter: onEnter != null ? (_) => onEnter!() : null,
                  onExit: onExit != null ? (_) => onExit!() : null,

                  child: GestureDetector(
                    onTap: onTap,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.transparent,
                    ),
                  ),
                ),

                if (value.volume == 0.0)
                  Positioned(
                    top: 16,
                    right: 16,
                    child: IconButton.filledTonal(
                      style: iconButtonStyle,
                      onPressed: () => controller!.setVolume(1.0),
                      icon: const Icon(Icons.volume_off_outlined),
                    ),
                  )
                else
                  Positioned(
                    top: 16,
                    right: 16,
                    child: IconButton.filledTonal(
                      style: iconButtonStyle,
                      onPressed: () => controller!.setVolume(0.0),
                      icon: const Icon(Icons.volume_up_outlined),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  ButtonStyle get iconButtonStyle {
    return IconButton.styleFrom(
      backgroundColor: Colors.black26,
      foregroundColor: Colors.white,
    );
  }
}

class VideoBannerByUrl extends StatefulWidget {
  final String videoUrl;

  const VideoBannerByUrl({
    super.key,
    required this.videoUrl,
  });

  @override
  State<VideoBannerByUrl> createState() => _VideoBannerByUrlState();
}

class _VideoBannerByUrlState extends State<VideoBannerByUrl> {
  late final VideoPlayerController controller;
  late Future<void> _initializeVideo;

  Future<void> initializeVideo() async {
    controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    await controller.initialize();
    await controller.setVolume(0.0);
    await controller.setLooping(true);
    await controller.play();
    setState(() {});
  }

  @override
  void initState() {
    _initializeVideo = initializeVideo();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideo,
      builder: (context, snapshot) {
        final isLoading = snapshot.connectionState == ConnectionState.waiting;
        return VideoBanner(
          controller: isLoading ? null : controller,
          //thumbnailUrl: SummerGlowPromotion.imageUrl,
        );
      },
    );
  }
}
