import 'package:YLift/core/repositories/image_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SurgYLiftBanner extends StatelessWidget {
  const SurgYLiftBanner({super.key});

  static const _imageRepository = ImageRepository();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        Image.network(
          _imageRepository.getImageUrl('48ead3bb-41d0-4c09-a0ed-bfae305bf993'),
          fit: BoxFit.cover,
        ),
        // Positioned(
        //   top: 32,
        //   left: 32,
        //   right: 32,
        //   child: SvgPicture.network(
        //     'https://store.ylift.com/static/img/Campaigns/SURGYLIFT.svg',
        //     theme: const SvgTheme(currentColor: Colors.white),
        //     height: 72,
        //   ),
        // ),
        // const Positioned(
        //   top: 160,
        //   child: Text(
        //     'NON-SURGICAL FACE + NEXT LIFT',
        //     style: TextStyle(color: Colors.white, fontSize: 18),
        //     textAlign: TextAlign.center,
        //   ),
        // )
      ],
    );
  }
}
