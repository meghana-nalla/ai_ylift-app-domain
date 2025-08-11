import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/core/repositories/image_repository.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:flutter/material.dart';

final _errorImageUrl = ImageRepository.getBannerImage('c10dbac0-91b8-4b8a-8d32-e153b17aaf80');
    // 'https://phantom.ylift.app/media/api/optimized/variant/image/file/c10dbac0-91b8-4b8a-8d32-e153b17aaf80';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GalaxyPageScaffold(
      padding: MediaQuery.of(context).size.width < 640 ? EdgeInsets.only(top: 32) : YLiftConstant.pagePadding,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 64),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Something Went Wrong...',
            style: TextStyle(
              color: Color(0xFFBBBBBB),
              fontSize: 39,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: MediaQuery.of(context).size.width < 640 ? MediaQuery.of(context).size.width : 640,
            child: SelectableText.rich(
              TextSpan(
                style: TextStyle(),
                children: [
                  TextSpan(
                    text:
                    'This could be due to a lost connection or an unexpected error. Please try again. If the problem persists, contact support team at ',
                  ),
                  TextSpan(
                    text: '(212)-861-7787',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: ' or ',
                  ),
                  TextSpan(
                    text: 'info@ylift.com.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
        Image.network(
          _errorImageUrl,
          errorBuilder: (context, error, stackTrace) => Image.asset('msc/images/ys_logo.png'),
          width: MediaQuery.of(context).size.width < 640 ? MediaQuery.of(context).size.width : 640,
          //height: MediaQuery.of(context).size.width < 640 ? (MediaQuery.of(context).size.height / 4) : 640,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
