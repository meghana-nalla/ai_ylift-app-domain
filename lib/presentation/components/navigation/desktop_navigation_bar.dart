import 'package:YLift/core/constants/color.dart';
import 'package:YLift/core/constants/constant.dart';

import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:YLift/core/controllers/global.dart';
import 'package:get/get.dart';

import 'package:YLift/presentation/components/z-index_export.dart';

class DesktopNavBar extends StatelessWidget {
  DesktopNavBar({super.key});
  final GlobalController controller = Get.find<GlobalController>();
  static const textButtonStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white);

  @override
  Widget build(BuildContext context) {


    if(controller.isUserNonMedical) {
      return Obx(
            () => Container(
          color: controller.hasPatchUpdate.value ? YLiftColor.orange : Colors.black,
          alignment: Alignment.center,
          child: Column(
            children: [
              SizedBox(
                width: YLiftConstant.pageWidth,
                height: YLiftConstant.mainNavigationHeight,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () async => await controller.vroute.navigateTo('/shop'),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Row(
                          children: [
                            YLSLogo(size: 28),
                            const SizedBox(width: 16),
                            YLSTitle(isProvider: controller.user.value.isProvider ?? false),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                    TextButton(
                      onPressed: () async {
                        if (controller.isOnboarding.value) {
                          YLiftAlertDialog.show(
                            context,
                            title: 'Onboarding in progress',
                            message: 'Please finish onboarding before navigating to the shop.',
                          );
                        }
                        await controller.vroute.navigateTo('/shop');
                      },
                      child: const Text('SHOP', style: textButtonStyle),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () async {
                        if (controller.isOnboarding.value) {
                          YLiftAlertDialog.show(
                            context,
                            title: 'Onboarding in progress',
                            message: 'Please finish onboarding before navigating to the cart.',
                          );
                        } else {
                          await controller.vroute.goToCartPage();
                        }
                      },
                      icon: (controller.isAuthenticated.isTrue)
                          ? controller.simpleCart.value.cartItems.isEmpty
                          ? const Icon(Icons.shopping_cart)
                          : Badge(
                        label: Text(
                          '${controller.simpleCart.value.cartItems.length}',
                          style: const TextStyle(color: Colors.white, fontSize: 10),
                        ),
                        padding: EdgeInsets.zero,
                        child: const Icon(Icons.shopping_cart),
                      )
                          : const Icon(Icons.shopping_cart),
                      color: Colors.white,
                    ),
                    const AccountButton(),
                    const SizedBox(width: 16),
                    if (controller.isAuthenticated.isTrue)
                      IconButton(
                        tooltip: 'Log out',
                        onPressed: () async {
                          await controller.auth.processLogout();
                        },
                        icon: const Icon(Icons.logout, color: Colors.white),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Obx(
      () => Container(
        color: controller.hasPatchUpdate.value ? YLiftColor.orange :  Colors.black,
        alignment: Alignment.center,
        child: Column(
          children: [
            SizedBox(
              width: YLiftConstant.pageWidth,
              height: YLiftConstant.mainNavigationHeight,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () async => await controller.vroute.navigateTo('/shop'),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Row(
                        children: [
                          YLSLogo(size: 28),
                          const SizedBox(width: 16),
                          YLSTitle(isProvider: controller.user.value.isProvider ?? false),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                  TextButton(
                    onPressed: () async {
                      if (controller.isOnboarding.value) {
                        YLiftAlertDialog.show(
                          context,
                          title: 'Onboarding in progress',
                          message: 'Please finish onboarding before navigating to the shop.',
                        );
                      }
                      await controller.vroute.navigateTo('/shop');
                    },
                    child: const Text('SHOP', style: textButtonStyle),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (controller.isOnboarding.value) {
                        YLiftAlertDialog.show(
                          context,
                          title: 'Onboarding in progress',
                          message: 'Please finish onboarding before navigating to the promotions.',
                        );
                      }
                      await controller.vroute.navigateTo('/promotions');
                    },
                    child: const Text('PROMOTIONS', style: textButtonStyle),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (controller.isOnboarding.value) {
                        YLiftAlertDialog.show(
                          context,
                          title: 'Onboarding in progress',
                          message: 'Please finish onboarding before navigating to the training.',
                        );
                      }
                      await controller.vroute.navigateTo('/training');
                    },
                    child: const Text('HANDS-ON TRAINING', style: textButtonStyle),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (controller.isOnboarding.value) {
                        YLiftAlertDialog.show(
                          context,
                          title: 'Onboarding in progress',
                          message: 'Please finish onboarding before navigating to the shop.',
                        );
                      }
                      await controller.vroute.navigateTo('/courses');
                    },
                    child: const Text('COURSES', style: textButtonStyle),
                  ),
                  const Spacer(),
                  const SizedBox(
                    width: 240,
                    height: 40,
                    child: YLiftSearchBar(),
                  ),
                  const GapX(),
                  IconButton(
                    onPressed: () async {
                      if (controller.isOnboarding.value) {
                        YLiftAlertDialog.show(
                          context,
                          title: 'Onboarding in progress',
                          message: 'Please finish onboarding before navigating to the cart.',
                        );
                      } else {
                        await controller.vroute.goToCartPage();
                      }
                    },
                    icon: (controller.isAuthenticated.isTrue)
                        ? controller.simpleCart.value.cartItems.isEmpty
                            ? const Icon(Icons.shopping_cart)
                            : Badge(
                                label: Text(
                                  '${controller.simpleCart.value.cartItems.length}',
                                  style: const TextStyle(color: Colors.white, fontSize: 10),
                                ),
                                padding: EdgeInsets.zero,
                                child: const Icon(Icons.shopping_cart),
                              )
                        : const Icon(Icons.shopping_cart),
                    color: Colors.white,
                  ),
                  const AccountButton(),
                  const SizedBox(width: 16),
                  if (controller.isAuthenticated.isTrue)
                    IconButton(
                      tooltip: 'Log out',
                      onPressed: () async {
                        await controller.auth.processLogout();
                      },
                      icon: const Icon(Icons.logout, color: Colors.white),
                    ),
                ],
              ),
            ),
            if (global.showingSplash.isFalse)...[
              if (global.display.showSubNavigationBar().isTrue) SubNavigationBar(),
            ]
          ],
        ),
      ),
    );
  }
}
