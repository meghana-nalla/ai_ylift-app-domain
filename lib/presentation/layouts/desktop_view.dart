import 'package:YLift/presentation/components/_complex/cookie_settings_panel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:YLift/core/controllers/z-index_export.dart';
import 'package:YLift/presentation/components/z-index_export.dart';

class DesktopScreen extends GetView<GlobalController> {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final GlobalController global = Get.find<GlobalController>();

  DesktopScreen({
    super.key,
    required this.scaffoldKey,
  });

  bool get showTopNavigation{
    if(controller.isOnboarding.value) return false;
    final path = Uri.base.path;
    if(path.startsWith('/require_address') || path.startsWith('/require_card_payment')) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GlobalController>(
      builder: (controller) {
        return Stack(
          children: [
            Scaffold(
              key: global.isAuthenticated.isTrue ? scaffoldKey : null,
              backgroundColor: Colors.white,
              endDrawer: global.isAuthenticated.isTrue && global.isOnboarding.isFalse ? _buildCartDrawer(controller) : null,
              body: Stack(
                children: [
                  controller.display.desktopBodyContentScreen(),
                  Obx((){
                    if (showTopNavigation && controller.hideTopNavigation.value == false)
                      return Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            DesktopNavBar(),
                            controller.display.loadingBar(),
                          ],
                        ),
                      );
                    else
                      return const SizedBox(height: 50, width: double.infinity);
                  }),

                  Obx(
                    () {
                      if (controller.confirmCookiesDialog.isFalse) return SizedBox.shrink();
                      return Positioned.fill(
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            IgnorePointer(
                              child: ColoredBox(color: Colors.black12),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: CookieSettingsPanel(
                                onAccept: () async {
                                  await controller.auth.setCookies(true);
                                },
                                onReject: () async {
                                  await controller.auth.setCookies(false);
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
            Obx(() {
              // TODO : find out whats happening in the calls of the application overall before doing any loading state
              final bool shouldShowSplash = controller.showingSplash.value; //controller.loading.isLoading.value << disabled for now
              // print('Should show splash: $shouldShowSplash');
              // print('Loading state: ${controller.loading.isLoading.value}');
              // print('Splash state: ${controller.showingSplash.value}');
              
              // safety timeout to hide splash if it stays on too long
              if (shouldShowSplash) {
                Future.delayed(const Duration(seconds: 3), () {
                  controller.showingSplash.value = false;
                  controller.update();
                });
              }
              return shouldShowSplash ? const SplashScreen() : Container();
            }),
          ],
        );
      },
    );
  }

  Widget _buildCartDrawer(GlobalController controller) {
    return Obx(() => CartDrawer(
          similarProducts: controller.featuredProducts,
          cartItems: controller.simpleCart.value.cartItems,
          subtotalCost: controller.simpleCart.value.subTotal,
          onSimilarProductSelected: (product) {
            if (product.productId != null) {
              controller.vroute.navigateToProduct(product.productId!);
            }
          },
          onSimilarProductQuickAdd: (product) {
            controller.basket.addToCart(
              customerId: controller.user.value.profileId.toString(),
              quantity: 1,
              product: "${product.productId}-${product.skus!.first.skuId}"
            );
          },
          onUpdateQuantity: (cartItem, newQuantity) {
            controller.basket.updateCartItemQuantity(
              profileId: controller.user.value.profileId.toString(),
              quantity: newQuantity,
              product: '${cartItem.productId}-${cartItem.skuId}',
            );
          },
          onDeleteCartItem: (cartItem) {
            controller.basket.deleteCartItem(
              profileId: controller.user.value.profileId.toString(),
              productId: cartItem.combinedId,
            );
          },
          onProceedToCheckout: global.simpleCart.value.isCheckoutable
              ? () {
                  controller.vroute.navigateTo('/order/checkout');
                }
              : null,
          onViewCart: () {
            controller.vroute.navigateTo('/order/cart');
          },
        ));
  }
}
