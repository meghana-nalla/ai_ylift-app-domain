import 'package:flutter/material.dart';

import '../../core/constants/color.dart';
import '../pages/auth/having_trouble/index.dart';
import 'package:get/get.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:device_info_plus/device_info_plus.dart';
class ReportIssueButton extends StatefulWidget {
  final String errorMessage;


  ReportIssueButton({super.key, required this.errorMessage});

  @override
  State<ReportIssueButton> createState() => _ReportIssueButtonState();
}

class _ReportIssueButtonState extends State<ReportIssueButton> {
  final global = Get.find<GlobalController>();
  bool submitted = false;



  void reportIssue(String message) async {
    final deviceInfo = DeviceInfoPlugin();
    final browserInfo = await deviceInfo.webBrowserInfo;
    final infoDevice = await deviceInfo.deviceInfo;
    try {
      final feedbackData = {
        "title": "Issue reported while browsing",
        "description": message,
        "type": 'Bug Report',
        "priority": "High",
        "status": "Submitted",
        "category": "Checkout Process", // Checkout Process, Shopping Cart, Search & Filtering
        "isPublic": true,
        "isAnonymous": false,
        "tags": [],
        "expectedOutcome": "",
        "currentBehavior": "",
        "expectedBehavior": "",
        "stepsToReproduce": "",
        "browserInfo": browserInfo.userAgent,
        "deviceInfo": browserInfo.platform,
      };


      await global.userProfile.postFeedbacks(feedbackData);
      debugPrint('Error reported: $message');
      if (mounted) {
        setState(() {
          submitted = true;
        });
      }
    } catch (e) {
      debugPrint('Failed to report issue: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    if (submitted) {
      return const Text(
        'Thank you for reporting this issue. Our development team has been notified and will investigate promptly.',
        style: TextStyle(
          color: Colors.red,
          fontSize: 15,
        ),
      );
    }
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          reportIssue(widget.errorMessage);
          },
          // Call your function here
          //reportBug();

        child: Text(
          'Report the issue here',
          style: const TextStyle(
            color: YLiftColor.orange,
            fontSize: 13.33,
            decoration: TextDecoration.underline,
            decorationColor: YLiftColor.orange,
          ),
        ),
      ),
    );
  }
}


