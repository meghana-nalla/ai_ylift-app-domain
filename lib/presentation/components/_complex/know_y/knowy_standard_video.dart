import 'package:flutter/material.dart';

class KnowYStandardVideo extends StatelessWidget {
  const KnowYStandardVideo({
    super.key,
    this.titleText,
    this.descText,
    this.thumbnailUrl,
  });

  final String? titleText;
  final String? descText;
  final String? thumbnailUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(60.0),
      child: Container(
        height: 300,
        width: 350,
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        child: Stack(
          children: [

            // Video info
            Expanded(
              flex: 1,
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

                      // Video Thumbnail
                      Expanded(
                        flex: 1,
                        child: Container(
                          width: double.infinity,
                          color: Colors.grey[300],
                          // TODO: add image
                          child: Center(child: Text('Video')),
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
    );
  }
}