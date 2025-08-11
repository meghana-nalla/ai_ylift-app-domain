import 'package:flutter/material.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/core/controllers/z-index_export.dart';
import 'package:get/get.dart';

class DesktopQuickLinksNav extends StatelessWidget {
  final controller = Get.find<GlobalController>();
  final List<QuickLinksSimple> quickLinks;

  DesktopQuickLinksNav(this.quickLinks);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        constraints: BoxConstraints(maxWidth: 1000), // Restrict max width for large screens
        child: Wrap(
          alignment: WrapAlignment.center, // Align the quick links in the center
          spacing: 16, // Space between quick link buttons
          runSpacing: 8, // Space between rows if they wrap
          children: quickLinks.map((quickLink) {
            return ElevatedButton(
              onPressed: () {
                controller.vroute.navigateQuickLinksTap(quickLinks.indexOf(quickLink));
              },
              child: Text(quickLink.name),
            );
          }).toList(),
        ),
      ),
    );
  }
}
