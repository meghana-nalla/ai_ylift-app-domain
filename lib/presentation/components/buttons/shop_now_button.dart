import 'package:YLift/core/constants/color.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
class ShopNowButton extends StatelessWidget {
  const ShopNowButton({super.key});

  void goToShopPage() {
    final controller = Get.find<GlobalController>();
    controller.vroute.navigateTo('/shop');
  }

  @override
  Widget build(BuildContext context) {
    return YLiftFilledButton(
      backgroundColor: YLiftColor.beige,
      onPressed: goToShopPage,
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
      child: const Text(
        'SHOP NOW',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }
}
