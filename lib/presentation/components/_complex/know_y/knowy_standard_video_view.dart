import 'package:flutter/material.dart';
import 'knowy_popular.video.dart';

class KnowYStandardVideoView extends StatelessWidget {
  const KnowYStandardVideoView({
    super.key,
    required this.numVideos,
  });

  final int numVideos;

  @override
  Widget build(BuildContext context) {
    // Popular Videos Display
    return SingleChildScrollView(
      child: Column(
          children: List.generate(numVideos, (index) {
            return const Column(
              children: [
                KnowYPopularVideo(
                  popularView: false,
                  isInteractive: true,
                ),
                SizedBox(height: 25)
              ],
            );
          })
      ),
    );
  }
}