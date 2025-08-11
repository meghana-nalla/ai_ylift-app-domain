import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/components/_simple/yls_logo.dart';
import 'package:YLift/presentation/components/dialogs/mobile_feedback_submisison_dialog.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_models/core/constants/y_lift_color.dart';
import 'package:get/get.dart';

class MobileMenuDrawer extends StatelessWidget {
  const MobileMenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final global = Get.find<GlobalController>();
    final isAuthenticated = global.isAuthenticated.value;
    final cartItemsLength = global.simpleCart.value.cartItems.length;

    return SelectionArea(
      child: Container(
        color: Colors.white,
        width: 320,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(16),
                child: YLSLogoBlack(
                  isMobile: true,
                  version: YLiftConstant.version,
                ),
              ),
              _MenuTile(
                label: 'HOME',
                onTap: () async {
                  Navigator.pop(context);
                  global.vroute.navigateTo('/shop');
                },
              ),
              Divider(height: 2, color: Colors.grey.shade200),
              _MenuTile(
                label: 'SHOP ALL',
                onTap: () async {
                  Navigator.pop(context);
                  global.vroute.navigateTo('/shop/all');
                },
              ),
              Divider(height: 2, color: Colors.grey.shade200),
              _MenuTile(
                label: 'CART',
                onTap: () async {
                  Navigator.pop(context);

                  if (isAuthenticated) {
                    global.vroute.navigateTo('/cart');
                  } else {
                    global.vroute.navigateTo('/login');
                  }
                },
                trailing:
                    cartItemsLength > 0 && isAuthenticated
                        ? Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: YLiftColor.orange,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            '$cartItemsLength',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        )
                        : null,
              ),
              Divider(height: 2, color: Colors.grey.shade200),
              _MenuTile(
                label: 'PROMOTIONS',
                onTap: () async {
                  Navigator.pop(context);
                  global.vroute.navigateTo('/promotions');
                },
              ),
              Divider(height: 2, color: Colors.grey.shade200),
              _MenuTile(
                label: 'COURSES',
                onTap: () async {
                  Navigator.pop(context);
                  global.vroute.navigateTo('/courses');
                },
              ),
              Divider(height: 2, color: Colors.grey.shade200),
              if (isAuthenticated)
                _MenuTile(
                  label: 'ACCOUNT',
                  onTap: () async {
                    Navigator.pop(context);
                    global.vroute.navigateTo('/profile');
                  },
                )
              else
                _MenuTile(
                  label: 'LOG IN / SIGN UP',
                  onTap: () async {
                    Navigator.pop(context);
                    global.vroute.navigateTo('/login');
                  },
                  trailing: const Icon(Icons.login_rounded),
                ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Having trouble with our mobile site? Try our desktop version or contact our office at ${YLiftConstant.yliftPhoneNumber} or ${YLiftConstant.yliftEmail}.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
              if (isAuthenticated)
                   GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) => MobileFeedbackSubmisisonDialog(),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Submit a feedback or report an issue.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.blue,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final String label;
  final void Function() onTap;
  final Widget? trailing;
  final EdgeInsets padding;

  const _MenuTile({
    super.key,
    required this.label,
    required this.onTap,
    this.trailing,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        width: double.infinity,
        padding: padding,
        height: 56,
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const Spacer(),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
