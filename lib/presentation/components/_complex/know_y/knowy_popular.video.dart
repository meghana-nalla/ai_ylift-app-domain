import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:YLift/core/controllers/global.dart';

class KnowYPopularVideo extends StatelessWidget {
  const KnowYPopularVideo({
    super.key,
    this.titleText,
    this.descText,
    this.thumbnailUrl,
    required this.popularView, // is this video displayed in the popular view?
    required this.isInteractive, // is this widget interactive?
  });

  final String? titleText;
  final String? descText;
  final String? thumbnailUrl;
  final bool popularView;
  final bool isInteractive;


  @override
  Widget build(BuildContext context) {

    // get global controller
    final controller = Get.find<GlobalController>();

    double _boxHeight;
    double _boxWidth;
    int _videoFlexFactor;
    int _textFlexFactor;

    if (!popularView) {
      _boxHeight = 500;
      _boxWidth = double.infinity;
      _videoFlexFactor = 3;
      _textFlexFactor = 1;
    }
    else {
      _boxHeight = 250;
      _boxWidth = 300;
      _videoFlexFactor = 1;
      _textFlexFactor = 1;
    }

    // handle interactivity
    GestureTapCallback _handleClick = () {};

    if (isInteractive) {
      _handleClick = () => controller.navigateMobileIndex.value = 9;
      // navigate to video detail page
    }

    return GestureDetector(
      onTap: _handleClick,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(60.0),
        child: Container(
          height: _boxHeight,
          width: _boxWidth,
          decoration: BoxDecoration(
            color: Colors.grey[200],
          ),
          child: Column(
            children: [
              // Video Thumbnail
              Expanded(
                flex: _videoFlexFactor,
                child: Container(
                  width: double.infinity,
                  color: Colors.grey[300],
                  // TODO: add image
                  child: Center(child: Text('Video')),
                ),
              ),

              // Video info
              Expanded(
                flex: _textFlexFactor,
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          titleText ?? 'Video Title',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          descText ?? 'Video description will go here. This text is extra long to test wrap.',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            // thumbnail
          ),
        ),
      ),
    );
  }
}