import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/components/buttons/mobile_icon.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_models/core/constants/y_lift_color.dart';
import 'package:get/get.dart';

class MobileLogoutDialog extends StatelessWidget {
  const MobileLogoutDialog({super.key});

  void logOut(BuildContext context) async {
    Navigator.pop(context);

    final global = Get.find<GlobalController>();
    await global.auth.logout();
    await global.blowOutCarts();
    await global.blowOutUserData();
    await global.refreshAppLoadData();
    await global.products.loadAllAuthProducts();
    global.vroute.navigateTo('/shop');
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      insetPadding: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Log Out',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                MobileIcon(
                  onPressed: () => Navigator.pop(context),
                  icon: Icons.close,
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Are you sure you want to log out?',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  // backgroundColor: YLiftColor.orange,
                  foregroundColor: YLiftColor.orange,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  side: const BorderSide(color: YLiftColor.orange, width: 1),
                  textStyle: const TextStyle(fontSize: 14, letterSpacing: 1),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
                onPressed: () => logOut(context),
                child: const Text('Log Out'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
