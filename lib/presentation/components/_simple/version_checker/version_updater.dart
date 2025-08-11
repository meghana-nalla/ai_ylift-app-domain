import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/core/constants/index.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/core/services/version_service.dart';
import 'package:YLift/models/simple/version_data.dart';
import 'package:YLift/presentation/components/_simple/version_checker/new_update_available_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:galaxy_ui/galaxy_ui.dart';

class VersionChecker extends StatefulWidget {
  final Widget child;
  const VersionChecker({super.key, required this.child});

  @override
  State<VersionChecker> createState() => _VersionCheckerState();
}

class _VersionCheckerState extends State<VersionChecker> {
  static const _seenUpdatesKey = 'seen_updates';
  final _prefs = SharedPreferencesAsync();

  Future<void> saveSeenUpdate(VersionCode version) async {
    try {
      var seenUpdates =
          await _prefs.getStringList(_seenUpdatesKey) ?? <String>[];
      if (!seenUpdates.contains('$version')) {
        seenUpdates.add('$version');
        await _prefs.setStringList(_seenUpdatesKey, seenUpdates);
      }
    } catch (e) {
      debugPrint('Error saving seen update: $e');
    }
  }

  void checkVersion() async {
    final global = Get.find<GlobalController>();
    if (!global.isAuthenticated.value) return;
    final currentVersion = YLiftConstant.frontendVersion;
    final latestVersion = await VersionService.checkFrontendVersion();

    final seenUpdates =
        await _prefs.getStringList(_seenUpdatesKey) ?? <String>[];
    if (!mounted) return;
    final updateType = VersionCode.checkUpdateType(
      currentVersion,
      latestVersion,
    );
    final showUpdateDialog =
        updateType == UpdateType.major || updateType == UpdateType.minor;

    global.hasPatchUpdate.value = updateType == UpdateType.patch;

    if (showUpdateDialog) {
      showDialog(
        barrierDismissible: updateType != UpdateType.major,
        context: context,
        builder: (context) {
          return NewUpdateAvailableDialog(
            isMajorUpdate: updateType == UpdateType.major,
          );
        },
      );
    } else if (!seenUpdates.contains('$latestVersion')) {
      saveSeenUpdate(latestVersion);

      // showDialog(
      //   context: context,
      //   builder: (context) {
      //     return VersionDialog(versionData: VersionData.version104);
      //   },
      // );
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkVersion();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class VersionDialog extends StatelessWidget {
  final VersionData versionData;
  const VersionDialog({super.key, required this.versionData});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 800,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Y Lift Store just got even better!  🎉',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const Divider(height: 2),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Here\'s what is NEW in YLS v.${versionData.versionCode} :',
                  ),
                ],
              ),
            ),
            // Body
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 800),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16,
                  children:
                      versionData.features
                          .map(
                            (e) => Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.remove),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        e.title,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (e.imageUrl != null)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                          ),
                                          child: Image.network(e.imageUrl!),
                                        ),
                                      Text(e.description),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                ),
              ),
            ),

            // Buttons
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: OverflowBar(
                alignment: MainAxisAlignment.end,
                children: [
                  RoundedFilledButton(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
