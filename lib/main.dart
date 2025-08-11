import 'dart:async';
import 'dart:developer' as developer;

import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/core/services/device_check.dart';
import 'package:YLift/presentation/pages/desktop/error_page/index.dart';
import 'package:YLift/presentation/pages/desktop/maintenance/index.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_initializer.dart';
import 'platform_app.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    developer.log('Starting app initialization');
    try {
      await AppInitializer.initialize();
      final deviceInfo = await DeviceInfoPlugin().webBrowserInfo;
      // final isMobile = deviceInfo.userAgent?.contains('Mobile') ?? false;
      final isMobile = WebDeviceService().isMobileWeb;

      final global = Get.find<GlobalController>();
      global.isMobile.value = isMobile;
      final isInMaintenance = await global.checkMaintenance();
      if(isInMaintenance){
        runApp(MaintenanceApp());
        return;
      }

      runApp(PlatformApp());
    } catch (e, stackTrace) {
      developer.log('$stackTrace');
      developer.log('Error during initialization', error: e, stackTrace: stackTrace);
      runApp(ErrorApp(error: e.toString()));
    }
  }, (error, stack) {
    developer.log('Uncaught error', error: error, stackTrace: stack);
  });
}

class MaintenanceApp extends StatelessWidget{
  const MaintenanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MaintenancePage(),
    );
  }
}

class ErrorApp extends StatelessWidget {
  final String error;
  const ErrorApp({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ErrorPage(),
    );
  }
}
