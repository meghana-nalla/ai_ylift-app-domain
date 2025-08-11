import 'package:YLift/core/controllers/global.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:YLift/presentation/components/_complex/desktop_view/gap.dart';
import 'package:get/get.dart';
import 'package:device_info_plus/device_info_plus.dart';
class FeedbacksPanel extends StatefulWidget {
  const FeedbacksPanel({super.key});

  @override
  State<FeedbacksPanel> createState() => _FeedbackFormPanelState();
}

class _FeedbackFormPanelState extends State<FeedbacksPanel> {
  final global = Get.find<GlobalController>();
  final formKey = GlobalKey<FormState>();

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
    final title = selectedTitle == 'Others'
        ? customTitleController.text
        : selectedTitle;
    final descriptionText = description.text.trim();
    final typeText = type.trim();
    final deviceInfo = DeviceInfoPlugin();
    final browserInfo = await deviceInfo.webBrowserInfo;
    final infoDevice = await deviceInfo.deviceInfo;


    final feedbackData = {
      "title":title,
      "description": descriptionText,
      "type": typeText,
      "priority": "High",
      "status": "Submitted",
      "category":"Checkout Process",
      "isPublic": true,
      "isAnonymous": false,
      "tags": [
        "string"
      ],
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
  }

  @override
  Widget build(BuildContext context) {
    final bool isCustomTitle = selectedTitle == 'Others';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Feedback Form',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const GapY(),
        Form(
          key: formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Issue Title*',
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
                        labelText: 'Issue Title*',
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
                        label: Text('Description*'),
                        hintText: 'Detailed explanation of the issue',
                      ),

                      maxLines: 5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const GapY(),
        // Row(
        //   children: [
        //     Text('Define the type of the issue:'),
        //     GapX(),
        //     DropdownButton<String>(
        //       value: type,
        //       items:
        //           ['Bug Report', 'Feature Request', 'Improvement','General']
        //               .map(
        //                 (val) => DropdownMenuItem(
        //                   value: val,
        //                   child: Padding(
        //                     padding: const EdgeInsets.all(8.0),
        //                     child: Text(val),
        //                   ),
        //                 ),
        //               )
        //               .toList(),
        //       onChanged: (val) => setState(() => type = val!),
        //     ),
        //   ],
        // ),
        // const GapY(),
        Center(
          child: YLiftFilledButton(
            onPressed: submitFeedback,
            child: const Text('Submit Feedback'),
          ),
        ),
      ],
    );
  }
}
