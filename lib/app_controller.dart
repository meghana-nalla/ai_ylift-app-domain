import 'dart:async';
import 'package:YLift/presentation/components/_simple/version_checker/version_updater.dart';
import 'package:YLift/presentation/layouts/desktop_view.dart';
import 'package:YLift/presentation/components/_complex/splashs/promotions.dart';
import 'package:YLift/presentation/components/_complex/splashs/welcome.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/controllers/global.dart';
import 'core/services/device_check.dart';

class AppController extends StatefulWidget {
  @override
  _AppControllerState createState() => _AppControllerState();
}

class _AppControllerState extends State<AppController> {
  final GlobalController controller = Get.find<GlobalController>();
  final deviceService = WebDeviceService();
  late final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  void initState() {
    super.initState();
    scaffoldKey = controller.drawerController.createNewKey();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _handleInitialScreens();
    _handleInitialRoute();
  }

  Future<void> _handleInitialScreens() async {
    if (controller.siteInitLoaded.isTrue) return;

    if (controller.showingPromotion.isTrue) {
      if (mounted) {
        setState(() {
          controller.showingPromotion.value = false;
          controller.update();
        });
      }
    }

    controller.siteInitLoaded.value = true;
    
    // ensure splash is eventually turned off if something went wrong
    // we may want to have a reporting device here that says something
    // unexpected happened..
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && controller.showingSplash.value) {
        setState(() {
          controller.showingSplash.value = false;
          controller.update();
        });
      }
    });
  }

  void _handleInitialRoute() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final currentRoute = Get.currentRoute;
      
      // special route handling for brand detail routes: /shop/brand/{brandId}
      if (currentRoute.startsWith('/shop/brand/')) {
        // extract the brandId from the route
        final segments = currentRoute.split('/');
        if (segments.length >= 4) {
          final brandId = segments[3];
          
          // set the global selected brand ID for filtering
          controller.selectedBrandId.value = 'brand=$brandId';
          
          // hide promotion overlay
          controller.showingPromotion.value = false;
          
          // navigate to shop page content but preserve URL
          controller.vroute.navigateToIndex(50);
          
          // mark site as ready to show content
          controller.siteReady.value = true;
          return;
        }
      }
      
      // special route handling for product detail routes: /product/{productId}
      if (currentRoute.startsWith('/shop/product/')) {
        // extract the productId from the route
        final segments = currentRoute.split('/');
        if (segments.length >= 4) { // Ensure we have enough segments for /shop/product/{id}
          final productId = int.tryParse(segments[3]);
          if (productId != null) {
            // we want to keep splash visible during loading
            controller.showingPromotion.value = false;
            controller.showingSplash.value = true;
            controller.siteReady.value = false;
            
            try {
              // First set the view index to product page before attempting to load data
              // This prevents the shop page from flashing before showing the product
              controller.vroute.navigateToIndex(6);
              
              // Then load the product data
              final product = await controller.products.getProductSimple(productId);
              
              // set the product in global state
              controller.displayProduct.value = product;
              
              // update the route tracking to reflect we're on a product page
              controller.vroute.currentRoute.value = currentRoute;
              
              // immediately hide splash when product data is loaded
              controller.showingSplash.value = false;
              controller.siteReady.value = true;
              controller.update();
              
              // double-check after delay in case it didn't take
              Future.delayed(const Duration(milliseconds: 250), () {
                controller.showingSplash.value = false;
                controller.siteReady.value = true;
                controller.update();
              });
            } catch (e) {
              print('Error loading product: $e');
              controller.showingSplash.value = false;
              controller.siteReady.value = true;
            }
            return;
          }
        }
      }
      
      // special route handling for video detail routes: /courses/view/{videoId}
      if (currentRoute.startsWith('/courses/view/')) {
        // extract the videoId from the route
        final segments = currentRoute.split('/');
        if (segments.length >= 4) { // Ensure we have enough segments for /courses/view/{id}
          final videoId = segments[3];
          
          // we want to keep splash visible during loading
          controller.showingPromotion.value = false;
          controller.showingSplash.value = true;
          controller.siteReady.value = false;
          
          try {
            // First set the view index to video page before attempting to load data
            controller.vroute.navigateToIndex(35);
            
            // Store the videoId for the view page to use
            // We don't need to preload the data here as the ViewVideoCourse component
            // will handle loading the video details
            
            // update the route tracking to reflect we're on a video page
            controller.vroute.currentRoute.value = currentRoute;
            
            // Give the page a moment to initialize before hiding splash
            Future.delayed(const Duration(milliseconds: 200), () {
              controller.showingSplash.value = false;
              controller.siteReady.value = true;
              controller.update();
            });
          } catch (e) {
            print('Error handling video route: $e');
            controller.showingSplash.value = false;
            controller.siteReady.value = true;
          }
          return;
        }
      }
      if (currentRoute.startsWith('/training/videos/')) {
        final segments = currentRoute.split('/');
        if (segments.length >= 4) {
          controller.showingPromotion.value = false;
          controller.showingSplash.value = true;
          controller.siteReady.value = false;

          try {
            controller.vroute.navigateToIndex(72);
            controller.vroute.currentRoute.value = currentRoute;
            Future.delayed(const Duration(milliseconds: 200), () {
              controller.showingSplash.value = false;
              controller.siteReady.value = true;
              controller.update();
            });
          } catch (e) {
            print('Error handling video route: $e');
            controller.showingSplash.value = false;
            controller.siteReady.value = true;
          }
          return;
        }
      }
      
      if (currentRoute == '/') {
        // Handle home route directly without using returnToHome to avoid infinite loop
        controller.showingPromotion.value = false;
        
        // Just set the correct index for shop/home without changing URL
        controller.vroute.navigateToIndex(8); // shop is index 8
        controller.vroute.currentRoute.value = '/';
        controller.displayHomePage.value = true;
        controller.update();
      } else {
        controller.showingPromotion.value = false;
        await controller.vroute.handleUrlRoute(currentRoute);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GlobalController>(
        builder: (controller) {
          return Stack(
            fit: StackFit.expand,
            children: [
              _buildMainLayout(),
              if (controller.showingPromotion.value)
                PromotionScreen(
                  onClose: () {
                    controller.showingPromotion.value = false;
                    controller.update();
                  },
                ),
              if (controller.showingSplash.value) _buildSplash(),
            ],
          );
        }
    );
  }

  Widget _buildSplash() {
    return controller.isAuthenticated.isTrue ? const SplashScreen() : const SplashScreen();
  }

  Widget _buildMainLayout() {
    if (deviceService.isDesktopWeb) {
      return VersionChecker(child: DesktopScreen(scaffoldKey: scaffoldKey));
    } else {
      controller.isMobile.value = true;
      return controller.display.layoutMobile();
    }
  }
}
