import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart' as web;

import 'app_meta_controller.dart';
import 'core/controllers/global.dart';
import 'core/services/kodbox.dart';

class AppInitializer {
  static Future<void> initialize() async {
    setUrlStrategy(PathUrlStrategy());

    // Initialize KodBox
    final kodBoxService = KodBoxService();
    await kodBoxService.initialize();

    // Initialize controllers
    Get.put(GlobalController(), permanent: true);
    final global = Get.find<GlobalController>();
    await global.init();
    Get.put(MetaTagController(), permanent: true);
    _initializeManifest();
  }

  static void _initializeManifest() {
    final head = web.document.head!;
    var manifestLink = head.querySelector('link[rel="manifest"]');

    if (manifestLink == null) {
      manifestLink = web.HTMLLinkElement()..rel = 'manifest';
      manifestLink.setAttribute('data-rh', 'true');
      head.append(manifestLink);
    }
    manifestLink.setAttribute('href', 'https://ylift.app/api/v2/neptune/manifests/manifest-default.json');
  }
}
