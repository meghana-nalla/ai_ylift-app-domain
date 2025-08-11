import 'package:YLift/core/controllers/global.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:get/get.dart';
class OrderVirtualItemsSection extends StatelessWidget {
  final List<VirtualItem> items;
  const OrderVirtualItemsSection({super.key, required this.items});

  static final _global = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Video / Training Bundle',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const Divider(height: 32),
        Column(
          spacing: 16,
          children:
              items.map((item) {
                return OrderVirtualItemTile(
                  imageUrl: item.imageUrl,
                  authorName: item.metadata['authorName'],
                  name:
                      item.productName!.isNotEmpty
                          ? item.productName!
                          : item.description,
                  actions: [
                    UnderlinedTextButton(
                      text: 'Available in Courses',
                      onPressed: () {
                        _global.vroute.navigateTo('/courses');
                      },
                      fontSize: 13.33,
                      color: Color(0xFF006AFF),
                    ),
                  ],
                );
              }).toList(),
        ),
      ],
    );
  }
}
