import 'package:YLift/core/constants/color.dart';
import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/core/constants/text_style.dart';

import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_ui/galaxy_ui.dart';

class MyActivityPanel extends StatelessWidget {

  final bool debugMode = true;
  MyActivityPanel({super.key});

  @override
  Widget build(BuildContext context) {
    if (debugMode) {
      return SizedBox(
        height: 400,
        width: double.infinity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Coming soon',
                style: YLiftTextStyle.title,
              ),
            ],
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Let\'s start learning, David', style: YLiftTextStyle.title),
        const GapY(),
        Wrap(
          spacing: 24,
          runSpacing: 24,
          children: [
            CourseTile(
              leading: const PlaceholderImage(),
              titleText: 'SILK Technique',
              currentChapter: '1. Introductions',
              onWatchLecture: () {},
            ),
            CourseTile(
              leading: const PlaceholderImage(),
              titleText: 'SILK Technique',
              currentChapter: '1. Introductions',
              onWatchLecture: () {},
            ),
            CourseTile(
              leading: const PlaceholderImage(),
              titleText: 'SILK Technique',
              currentChapter: '1. Introductions',
              onWatchLecture: () {},
            ),
          ],
        ),
      ],
    );
  }
}

class CourseTile extends StatelessWidget {
  final Widget leading;
  final String titleText;
  final String currentChapter;
  final void Function() onWatchLecture;

  const CourseTile({
    super.key,
    required this.leading,
    required this.titleText,
    required this.currentChapter,
    required this.onWatchLecture,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: SizedBox(
        width: 300,
        height: 320,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: leading,
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(titleText, style: const TextStyle(fontWeight: FontWeight.w400, color: YLiftColor.grey)),
                  Text(currentChapter, style: const TextStyle(fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const Divider(height: YLiftConstant.gap),
            BrownButton(
              onTap: onWatchLecture,
              child: const Text('Watch Lecture'),
            ),
          ],
        ),
      ),
    );
  }
}
