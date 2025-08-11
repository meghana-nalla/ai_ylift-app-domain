import 'package:YLift/core/repositories/image_repository.dart';
import 'package:flutter/material.dart';

class MagnYmBanner extends StatelessWidget {
  const MagnYmBanner({super.key});

  static const _imageRepository = ImageRepository();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        Image.network(
          // 'https://store.ylift.com/static/img/Campaigns/enhance_hys.png',
          _imageRepository.getImageUrl('fc355ac2-d98e-4385-bd7a-4ee63c93b7ba'),
          fit: BoxFit.cover,
        ),
      ],
    );
  }
}
