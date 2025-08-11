/*
  This widget is used to display the training image in the Know Y section.
  It takes a text parameter which is displayed as the title of the image.
*/

import 'package:YLift/core/constants/sample_index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:galaxy_ui/galaxy_ui.dart';

final GlobalController global = Get.find<GlobalController>();

class KnowYTrainingImage extends StatelessWidget {
  const KnowYTrainingImage({
    super.key,
    this.text,
    this.textBoxColor,
    this.imageUrl,
  });

  final String? text;
  final Color? textBoxColor;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Container(
        height: 450,
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // TODO: Add Actual Image
            // Image(image: AssetImage(imageUrl)),
            const Expanded(
              child: PlaceholderImage(
                fit: BoxFit.cover,
                placeholderImage: PLACEHOLDER_IMAGE,
              ),
            ),
            GestureDetector(
              onTap: () => global.navigateMobileIndex.value = 8,
              child: Container(
                height: 50,
                width: double.infinity,
                color: textBoxColor ?? Theme.of(context).colorScheme.tertiary,
                child: Center(
                  child: Text(
                    text ?? "Details & Register",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
