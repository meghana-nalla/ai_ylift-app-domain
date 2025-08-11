import 'package:YLift/core/constants/theme.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_theme_wrapper.dart';
import 'core/constants/index.dart';
import 'core/routes/index.dart';

class PlatformApp extends StatelessWidget {
  final GlobalController controller = Get.find<GlobalController>();

  PlatformApp({super.key});

  @override
  Widget build(BuildContext context) {
    return controller.isMobile.isTrue ? _buildMobileApp() : _buildDesktopApp(context);
  }

  Widget _buildMobileApp() {
    return AppThemeWrapper(
      child: GetMaterialApp(
        theme: YLiftTheme.getMobileTheme(),
        title: SITE_NAME,
        initialRoute: (controller.isAuthenticated.isTrue) ? '/shop' : '/shop',
        getPages: AppPages.routesMobile,
        // home: AppController(),
      ),
    );
  }

  Widget _buildDesktopApp(BuildContext context) {
    // keep splash visible during initial route loading
    controller.showingSplash.value = true;
    controller.siteReady.value = false;
    
    return AppThemeWrapper(
      child: GetMaterialApp(
        theme: YLiftTheme.getTheme(),
        title: SITE_NAME,
        initialRoute: Get.currentRoute.isNotEmpty && Get.currentRoute != '/' ? Get.currentRoute : (controller.isAuthenticated.isTrue ? '/shop' : '/'),
        getPages: AppPages.routesDesktop,
        // home: AppController(),
      ),
    );
  }
}
