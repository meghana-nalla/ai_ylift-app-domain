import 'package:YLift/core/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:YLift/core/controllers/global.dart';

class PromotionCodeField extends StatelessWidget {
  final global = Get.find<GlobalController>();

  final TextEditingController controller;
  PromotionCodeField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('ENTER PROMO CODE', style: TextStyle(fontSize: 12)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  isDense: true,
                  hintText: 'ENTER PROMO CODE',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
              ),
            ),
            Material(
              color: YLiftColor.brown,
              child: InkWell(
                onTap: () async {
                  // await global.auth.getHealth();
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: Text(
                    'Apply',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
