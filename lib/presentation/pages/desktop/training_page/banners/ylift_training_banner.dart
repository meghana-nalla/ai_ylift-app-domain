import 'package:YLift/core/repositories/image_repository.dart';
import 'package:flutter/material.dart';

class GalaxyYLiftBanner extends StatelessWidget {
  const GalaxyYLiftBanner({super.key});

  static const _imageRepository = ImageRepository();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        //
        Image.network(
          _imageRepository.getImageUrl('e2a0a64b-803f-46a6-8dc4-0a75338cf671'),
          fit: BoxFit.cover,
        ),
      ],
    );
  }
}
