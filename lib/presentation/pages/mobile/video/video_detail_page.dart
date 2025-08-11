import 'package:YLift/presentation/components/_complex/know_y/knowy_popular.video.dart';
import 'package:YLift/presentation/components/_complex/know_y/video_details/components.dart';
import 'package:YLift/presentation/components/_complex/know_y/dynamic_nested_tab_view.dart';
import 'package:YLift/presentation/pages/mobile/training/training_detail_page/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:YLift/core/controllers/global.dart';

// TODO: replace dummy JSON object with real data
final Map<String, dynamic> dummy = {
  'productName': 'Y Lift Video Title',
  'price': 4000.00,
  'numChapters': 2,
  'numQuizzes': 4,
  'description':
      '1) How to perform the various MagnYm® procedures VIRTUAL and LIVE!\n 2) The science behind neuromodulators, growth factors, and exosomes, and their role in male enhancement'
};

class KnowYVideoDetailPage extends StatelessWidget {
  const KnowYVideoDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    // get global controller
    final controller = Get.find<GlobalController>();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Details'),
          leading: IconButton(
            onPressed: () => controller.navigateMobileIndex.value = 1,
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                KnowYDetailVideoDisplayWidget(),
                KnowYDetailTitlePriceWidget(
                  // TODO: replace with real product data
                  productName: dummy['productName'],
                  price: dummy['price'],
                ),
                KnowYDetailCourseDescriptionWidget(
                  // TODO: replace with real product data
                  numChapters: dummy['numChapters'],
                  numQuizzes: dummy['numQuizzes'],
                  description: dummy['description'],
                ),
                SizedBox(height: 20),
                KnowYDetailPurchaseButton(),
                SizedBox(
                  height: 25,
                ),
                // TODO: make this widget general-purpose
                // DynamicNestedTabView(),
                TrainingTabs(
                  tabs: const <Widget>[
                    Text('Chapters'),
                    Text('Q&A'),
                    Text('Materials'),
                  ],
                  pages: <Widget>[
                    // Chapters page
                    ListView.separated(
                      shrinkWrap: true,
                      itemCount: 4,
                      separatorBuilder: (context, index) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        return ListTile(
                          tileColor: Colors.white,
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                          leading: const CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: const Text('MagnYm Preview'),
                          subtitle: const Text('01:12 Mins'),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.play_arrow),
                          ),
                        );
                      },
                    ),

                    // Q&A page
                    ListView.separated(
                      shrinkWrap: true,
                      itemCount: 2,
                      separatorBuilder: (context, index) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        return QuestionTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: Text(
                            'Alex Zayid, MD',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '2 days ago',
                            style: TextStyle(color: Colors.black38),
                          ),
                          content: Text(
                              'Once a patient has come for their monthly follow up after the MAGNYM procedure and subsequently received the repeat treatment at half the dose due to positive result and then had even further positive result, I have recommended follow up in 6-9 months for next treatment as needed. At that time, do you typically recommend dosing at the full 450 units of dysport that gave the great result over 2 treatments from the first round?'),
                        );
                      },
                    ),

                    // Materials
                    ListView.separated(
                      shrinkWrap: true,
                      itemCount: 4,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        return Text('File ${index + 1}');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}

class QuestionTile extends StatelessWidget {
  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget content;
  final Widget? trailing;

  const QuestionTile({
    super.key,
    required this.title,
    required this.content,
    this.leading,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              if (leading != null) leading!,
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title,
                  if (subtitle != null) subtitle!,
                ],
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }
}
