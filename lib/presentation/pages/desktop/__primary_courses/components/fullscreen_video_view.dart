import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FullscreenVideoView extends StatelessWidget {
  final VideoPlayerController controller;
  const FullscreenVideoView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: Stack(
            children: [
              VideoPlayer(controller),
            ],
          ),
        ),
      ),
    );
  }
}
