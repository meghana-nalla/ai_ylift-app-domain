import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/presentation/components/_simple/yls_logo.dart';
import 'package:YLift/presentation/components/drawers/mobile_menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:YLift/core/controllers/z-index_export.dart';
import 'package:YLift/presentation/components/z-index_export.dart';

class MobileScreen extends StatefulWidget {
  @override
  _MobileScreenState createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  final controller = Get.find<GlobalController>();

  @override
  void initState() {
    super.initState();

    // Fallback splash hide after 3 seconds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.showingSplash.value) {
        Future.delayed(const Duration(seconds: 3), () {
          controller.showingSplash.value = false;
          controller.siteReady.value = true;
          controller.update();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.showingSplash.value || controller.siteReady.value == false) {
        return const SplashScreen(); // or any custom loading indicator
      }

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          title: YLSLogoBlack(
            isMobile: true,
            text: 'Y LIFT STORE',
            version: YLiftConstant.version,
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            onTap: () async {
              await controller.vroute.navigateTo('/shop');
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () async {
                await controller.vroute.navigateTo('/cart');
              },
            ),
          ],
        ),
        body: AnimatedContainer(
          duration: Durations.short3,
          child: controller.display.getCurrentMobileView(),
        ),
        drawer: const MobileMenuDrawer(),
        // drawer: Drawer(
        //   child: Container(
        //     width: MediaQuery.of(context).size.width * 0.50,
        //     child: _buildNavigationDrawer(),
        //   ),
        // ),
      );
    });
  }

  ListView _buildNavigationDrawer() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        ListTile(title: Center(child: Text('MENU'))),
        ListTile(
          onTap: (){
            global.vroute.navigateTo('/profile');
          },
          title: Text('Account'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              controller.isAuthenticated.isTrue
                  ? TextButton.icon(
                icon: Icon(Icons.logout),
                label: Text('Logout'),
                onPressed: _showLogoutConfirmationDialog,
              )
                  : TextButton.icon(
                icon: Icon(Icons.login, size: 18),
                label: Text(
                  'Sign in / Sign up',
                  style: TextStyle(fontSize: 13.5), // reduced font size
                  overflow: TextOverflow.ellipsis,
                ),
                onPressed: () async {
                  await controller.vroute.navigateTo('/login');
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 4), // reduced padding
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  minimumSize: Size(0, 30), // smaller minimum size
                ),
              ),

            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: GestureDetector(
            onTap: () async {
              if (!controller.isAuthenticated.isTrue) {
                await controller.vroute.navigateTo('/login');
              } else {
                await controller.vroute.navigateTo('/cart');
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Cart',
                  style: TextStyle(
                    color: Color(0xFF343434),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                  ),
                ),
                if (controller.isAuthenticated.isTrue &&
                    controller.simpleCart.value.cartItems.isNotEmpty)
                  Container(
                    width: 19,
                    height: 19,
                    decoration: BoxDecoration(
                      color: Color(0xFFFF8B68),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${controller.simpleCart.value.cartItems.length}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ),

        ListTile(
          title: Text('SHOP', style: TextStyle(fontWeight: FontWeight.bold)),
          onTap: () async {
            await controller.vroute.navigateTo('/shop');
          },
        ),
        ListTile(
          title: Text('PROMOTION', style: TextStyle(fontWeight: FontWeight.bold)),
          onTap: () async {
            print('PROMOTION tapped');
            await controller.vroute.navigateTo('/promotions');
          },
        ),
        ListTile(
          title: Text('TRAINING', style: TextStyle(fontWeight: FontWeight.bold)),
          onTap: () async {
            print('Training tile tapped');
            try {
              print('Attempting to navigate to /training');
              await controller.vroute.navigateTo('/training');
              print('Navigation to /training successful');
            } catch (e) {
              print('Error during navigation to /training: $e');
            }
          },
        ),
        ListTile(
          title: Text('COURSES', style: TextStyle(fontWeight: FontWeight.bold)),
          onTap: () async {
            print('Courses tapped');
            await controller.vroute.navigateTo('/courses');
          },
        ),
        DrawerHeader(
          child: Text(
            'Having trouble with our mobile site? Try our desktop version or contact our office at (212) 861-7787 or info@ylift.com.',
            style: TextStyle(fontSize: 13),
          ),
        ),
      ],
    );
  }

  void _showLogoutConfirmationDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Alert'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await controller.auth.mobileProcessLogout();
              Get.back();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
