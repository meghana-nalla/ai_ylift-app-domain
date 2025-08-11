import 'package:YLift/core/constants/index.dart';
import 'package:flutter/material.dart';

class YLiftImage extends StatelessWidget {
  final String? imageUrl;
  const YLiftImage({
    super.key,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return Image.network(PLACEHOLDER_IMAGE);
    }
    return Image.network(imageUrl!);
  }
}
