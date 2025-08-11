import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/components/dialogs/mobile_dialog.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_models/core/constants/y_lift_color.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:get/get.dart';
import 'package:device_info_plus/device_info_plus.dart';

class MobileFeedbackSubmisisonDialog extends StatefulWidget {
  const MobileFeedbackSubmisisonDialog({super.key});

  @override
  State<MobileFeedbackSubmisisonDialog> createState() =>
      _MobileFeedbackSubmisisonDialogState();
}

class _MobileFeedbackSubmisisonDialogState
    extends State<MobileFeedbackSubmisisonDialog> {
  final global = Get.find<GlobalController>();
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final description = TextEditingController();
  final customTitleController = TextEditingController();

  String selectedTitle = 'Payment failed';
  String type = 'Bug Report';
  final List<String> commonIssues = [
    'Payment failed',
    'Unable to place order',
    'Item not delivered',
    'Incorrect item received',
    'App crashing',
    'Login issues',
    'Cart not updating',
    'Search not working',
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
    });
    try {
      final title =
      selectedTitle == 'Others' ? customTitleController.text : selectedTitle;
      final email = emailController.text;
      final descriptionText =
          description.text.trim();

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
        "category": "Checkout Process",
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

      debugPrint("Submitted Feedback: $feedbackData");

      if (selectedTitle == 'Others') customTitleController.clear();
      description.clear();
      setState(() {
        selectedTitle = 'Payment failed';
        type = 'Bug Report';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Feedback submitted!')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isCustomTitle = selectedTitle == 'Others';
    return MobileDialog(
      title: Text('Submit a Feedback'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          SizedBox(
            width: 500,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 16,),
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
                  SizedBox(height: 16,),
                  if (isCustomTitle) ...[
                    Row(
                      children: [
                        SizedBox(height: 8,),
                        Expanded(
                          child: YLiftTextField(
                            controller: customTitleController,
                            labelText: 'Other Issue Title',
                          ),
                        ),
                      ],
                    ),
                  ],
                  SizedBox(height: 16,),
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
                  // SizedBox(height: 16,),
                  // Row(
                  //
                  //   children: [
                  //
                  //     Expanded(
                  //       child: YLiftTextField(
                  //         labelText: "Email (Optional)",
                  //         controller: emailController,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(height: 32,),
                ],
              ),
            ),
          ),

          GalaxyFilledButton(
            isExpanded: true,
            backgroundColor: YLiftColor.orange,
            onPressed: submitFeedback,
            child: const Text('Submit Feedback'),
          ),
          SizedBox(height: 16,),
        ],
      ),
    );
  }
}
