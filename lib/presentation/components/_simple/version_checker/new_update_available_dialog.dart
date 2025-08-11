import 'package:YLift/core/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

class NewUpdateAvailableDialog extends StatelessWidget {
  final bool isMajorUpdate;

  const NewUpdateAvailableDialog({super.key, this.isMajorUpdate = false});

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Dialog(
        child: SizedBox(
          width: 800,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'New Update Available!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                Text(
                  'You are seeing this because the current version of Y Lift Store in this browser is outdated.',
                ),
                Text(
                  'To receive an update, please refresh the browser couple times or press "Refresh".',
                ),
                const SizedBox(height: 24),
                Text(
                  'MacOS',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 8),
                  child: Text('Chrome & Firefox: Command + Shift + R'),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 8),
                  child: Text('Safari: Command + Option + R'),
                ),
                const SizedBox(height: 16),
                Text(
                  'Windows',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 8),
                  child: Text('Chrome, Firefox, and IE: Control + F5'),
                ),
                // const SizedBox(height: 8),
                // Text('Current Version: $currentVersion'),
                // Text('Latest Version: $latestVersion'),
                const SizedBox(height: 24),
                Text(
                  'You may still continue using the current version, but miss out on new promotions, features, and encounter some errors.',
                ),
                const SizedBox(height: 16),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text:
                            'If you keep seeing this after refreshing the browser couple times, please email us at ',
                      ),
                      TextSpan(
                        text: YLiftConstant.yliftEmail,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(text: ' or contact us at '),
                      TextSpan(
                        text: YLiftConstant.yliftPhoneNumber,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                OverflowBar(
                  alignment: MainAxisAlignment.end,
                  children: [
                    if (!isMajorUpdate)
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    FilledButton(
                      onPressed: () {
                        web.window.location.reload();
                      },
                      child: const Text('Refresh'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
