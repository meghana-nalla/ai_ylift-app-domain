import 'package:YLift/core/constants/color.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:device_info_plus/device_info_plus.dart';

class HavingTroubleDialog extends StatefulWidget {
  const HavingTroubleDialog({super.key});

  @override
  State<HavingTroubleDialog> createState() => _HavingTroubleDialogState();
}

class _HavingTroubleDialogState extends State<HavingTroubleDialog> {
  final global = Get.find<GlobalController>();
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final description = TextEditingController();
  final customTitleController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  String selectedTitle = 'Login issues';
  String type = 'Bug Report';

  final List<String> commonIssues = [
    // 'Payment failed',
    // 'Unable to place order',
    // 'Item not delivered',
    // 'Incorrect item received',
    // 'App crashing',
    'Login issues',
    // 'Cart not updating',
    'Password reset issues',
    'Account creation issues',
    'Slow performance',
    'Others',
  ];

  @override
  void dispose() {
    description.dispose();
    customTitleController.dispose();
    super.dispose();
  }

  void submitFeedback() async {
    if (!formKey.currentState!.validate()) return;
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final title =
          selectedTitle == 'Others' ? customTitleController.text : selectedTitle;
      final email = emailController.text;
      final descriptionText =
          description.text.trim() + " Email: " + emailController.text;

      final typeText = type.trim();
      final deviceInfo = DeviceInfoPlugin();
      final browserInfo = await deviceInfo.webBrowserInfo;
      final infoDevice = await deviceInfo.deviceInfo;

      final feedbackData = {
        "title": title,
        "description": descriptionText,
        "type": typeText,
        "priority": "High",
        "status": "Submitted",
        "category": "Checkout Process", // Checkout Process, Shopping Cart, Search & Filtering
        "isPublic": true,
        "isAnonymous": true,
        "tags": [],
        "expectedOutcome": "",
        "currentBehavior": "",
        "expectedBehavior": "",
        "stepsToReproduce": "",
        "browserInfo": browserInfo.userAgent,
        "deviceInfo": browserInfo.platform,
      };

      await global.userProfile.postFeedbacks(feedbackData);

      debugPrint("Submitted Feedback: $feedbackData");

      if (selectedTitle == 'Others') customTitleController.clear();
      description.clear();
      setState(() {
        selectedTitle = 'Login issues';
        type = 'Bug Report';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Feedback submitted!')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
      setState(() {
        errorMessage = "Failed to submit the response.";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isCustomTitle = selectedTitle == 'Others';

    return AlertDialog(
      title: Text("Having Trouble"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          const GapY(),
          SizedBox(
            width: 500,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Select your Issue',
                            border: OutlineInputBorder(),
                          ),
                          value: selectedTitle,
                          items:
                              commonIssues
                                  .map(
                                    (issue) => DropdownMenuItem(
                                      value: issue,
                                      child: Text(issue),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (val) {
                            setState(() => selectedTitle = val ?? 'Others');
                          },
                        ),
                      ),
                    ],
                  ),
                  if (isCustomTitle) ...[
                    const GapY(),
                    Row(
                      children: [
                        Expanded(
                          child: YLiftTextField(
                            controller: customTitleController,
                            labelText: 'Other Issue Title',
                          ),
                        ),
                      ],
                    ),
                  ],
                  const GapY(),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: description,
                          decoration: InputDecoration(
                            //labelText: 'Description*',
                            label: Text('Description'),
                            hintText: 'Detailed explanation of the issue',
                          ),

                          maxLines: 5,
                        ),
                      ),
                    ],
                  ),
                  const GapY(),
                  Row(
                    children: [
                      Expanded(
                        child: YLiftTextField(
                          labelText: "Email (Optional)",
                          controller: emailController,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const GapY(),
          Center(
            child: isLoading ? CircularProgressIndicator() : YLiftFilledButton(
              onPressed: submitFeedback,
              child: const Text('Submit Feedback'),
            ),
          ),

        ],
      ),
    );
  }
}