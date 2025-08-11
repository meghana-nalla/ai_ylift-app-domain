import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/core/controllers/z-index_export.dart';

class QuickLinksNav extends StatelessWidget {
  // TODO : Remove controller from here
  final controller = Get.find<GlobalController>();
  final List<QuickLinksSimple> quickLinks;

  QuickLinksNav(this.quickLinks);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: quickLinks.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              onPressed: () {

                controller.vroute.navigateQuickLinksTap(index);
              },
              child: Text(quickLinks[index].name),
            ),
          );
        },
      ),
    );
  }
}