import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';


class WebDeviceService {
  bool get isWeb => kIsWeb;

  bool get isMobileWeb {
    if (!isWeb) return false;
    return MediaQueryData.fromView(WidgetsBinding.instance.window).size.shortestSide < 600;
  }

  bool get isDesktopWeb => isWeb && !isMobileWeb;
}