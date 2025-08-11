import 'package:YLift/core/repositories/image_repository.dart';
import 'package:flutter/material.dart';

final _ylsLogoUrl = ImageRepository.getBannerImage(
  '74cb4b45-f48e-4073-a8d8-af92e137aa53',
);
// 'https://phantom.ylift.app/media/api/optimized/variant/image/banners/file/74cb4b45-f48e-4073-a8d8-af92e137aa53';
// const _ylsLogoUrlMobile = 'https://phantom.ylift.app/media/api/optimized/variant/image/file/321fb5c0-a71f-4879-aabb-a3dcf527adba';
final _ylsLogoUrlMobile = ImageRepository.getBannerImage(
  '321fb5c0-a71f-4879-aabb-a3dcf527adba',
);
final _ylsLogoBlackUrl = ImageRepository.getBannerImage(
  '7600bde7-ec02-481c-9f30-fb50b42572cd',
);

class YLSLogo extends StatelessWidget {
  final double? size;
  final bool isMobile;
  const YLSLogo({
    super.key,
    this.size,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      isMobile ? _ylsLogoUrlMobile : _ylsLogoUrl,
      width: size,
      height: size,
      errorBuilder:
          (context, error, stackTrace) => SizedBox.square(dimension: size),
    );
  }
}

class YLSLogoBlack extends StatelessWidget {
  final String text;
  final String? version;
  final TextStyle? textStyle;
  final double? size;
  final bool isMobile;
  final VoidCallback? onTap;

  const YLSLogoBlack({
    super.key,
    this.text = 'Y LIFT STORE',
    this.version,
    this.textStyle,
    this.size,
    this.isMobile = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height:
                    isMobile
                        ? 16
                        : size ?? MediaQuery.of(context).size.height * 0.15,
                child: Image.network(
                  _ylsLogoBlackUrl,
                  fit: BoxFit.fill,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          Image.asset('msc/images/ys_logo_black.png'),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                text,
                style: textStyle ?? const TextStyle(fontSize: 16),
              ),
            ],
          ),
          if (version != null)
            Text(
              version!,
              style: const TextStyle(fontSize: 8, color: Colors.grey),
            ),
        ],
      ),
    );
  }
}

class YLSTitle extends StatelessWidget {
  final bool isProvider;
  final bool isMobile;
  const YLSTitle({
    super.key,
    this.isProvider = false,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget title = Text(
      'Y LIFT STORE',
      style: TextStyle(
        fontSize: isMobile ? 16 : 23,
        color: Colors.white,
        fontWeight: FontWeight.w600,
        height: 1,
      ),
    );

    if (isProvider) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(height: 10.88),
          title,
          const SizedBox(height: 2),
          Text(
            'PROVIDER',
            style: TextStyle(
              fontSize: 8.88,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.4,
            ),
          ),
        ],
      );
    }

    return title;
  }
}
