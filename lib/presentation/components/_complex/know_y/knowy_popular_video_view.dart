import 'package:flutter/material.dart';
import 'knowy_popular.video.dart';

class KnowYPopularVideoView extends StatelessWidget {
  const KnowYPopularVideoView({
    super.key,
    required this.numVideos,
  });

  final int numVideos;

  @override
  Widget build(BuildContext context) {
    // Popular Videos Display
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(numVideos, (index) {
          return const Row(
            children: [
              KnowYPopularVideo(
                popularView: true,
                isInteractive: true,
              ),
              SizedBox(width: 25)
            ],
          );
        })
      ),
    );
  }
}
