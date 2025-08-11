import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/pages/mobile/shop_all/shop_all_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final _global = Get.find<GlobalController>();

class MobileFooter extends StatelessWidget {
  const MobileFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.black,
          ),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            spacing: 16,
            children: [
              const Text(
                'Y LIFT STORE',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () {
                  _global.vroute.navigateTo('/shop/all');
                },
                child: const Text(
                  'SHOP ALL',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _global.vroute.navigateTo('/promotions');
                },
                child: const Text(
                  'PROMOTIONS',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _global.vroute.navigateTo('/courses');
                },
                child: const Text(
                  'COURSES',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        const CopyrightFooter(),
      ],
    );
  }
}

class CopyrightFooter extends StatelessWidget {
  const CopyrightFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final currentDate = DateTime.now();
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.white24),
        ),
        color: Colors.black,
      ),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.copyright_rounded,
            color: Colors.white,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            '${currentDate.year} Y Lift Store. All rights reserved.',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
