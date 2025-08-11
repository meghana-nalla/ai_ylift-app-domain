import 'package:YLift/core/repositories/image_repository.dart';
import 'package:YLift/models/simple/version_data.dart';
import 'package:flutter/material.dart';

class YLiftConstant {
  const YLiftConstant._();

  static const mainNavigationHeight = 96.0;
  static const subNavigationHeight = 56.0;
  static const totalTopNavigation = mainNavigationHeight + subNavigationHeight;
  static const promotionBannerHeight = 32.0;
  static const footerHeight = 56.0;

  static const gap = 30.0;

  static const pageWidth = 1380.0;
  // smallest page width should be 1080
  static const pagePadding = EdgeInsets.only(
    top: totalTopNavigation + 32,
  );

  static final boxShadow = <BoxShadow>[
    BoxShadow(
      color: Colors.grey.shade300,
      blurRadius: 4,
    ),
  ];

  // static final productImageUrl = ImageRepository.getBannerImage('2c0a8920-f7da-45f7-97dc-12569896eb80');
      // 'https://phantom.ylift.app/media/api/optimized/variant/image/file/2c0a8920-f7da-45f7-97dc-12569896eb80';

  static const int galdermaVendorId = 19;
  static const baseUrl = 'https://phantom.dev.ylift.app';
  static const baseImageUrl = '$baseUrl/static/assets/optimized/custom_images';
  static const productImageUrlFallback = 'https://ylift.app/static/assets/optimized/custom_images/placeholder_product.png';

  static const version = 'v2.3.1';
  static const frontendVersion = VersionCode(2, 3, 0);
  static const backendVersion = VersionCode(2, 0, 0);

  static const yliftEmail = 'info@ylift.com';
  static const yliftPhoneNumber = '+1 (212) 861-7787';

  static const isDev = true;
}
