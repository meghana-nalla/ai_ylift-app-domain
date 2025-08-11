import 'package:YLift/core/controllers/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthMiddleWare extends GetMiddleware{
  @override
  RouteSettings? redirect(String? route) {
    print('Route: $route');

    final authServer = Get.find<GlobalController>();
    final isAuthenticated = authServer.isAuthenticated.isTrue;
    final isNotAuthenticated = authServer.isAuthenticated.isFalse;
    final isOnboarding = authServer.isOnboarding.isTrue;
    final isMigrationUser = isAuthenticated && authServer.onboardingProcessStep.value == 99;
    final user = authServer.user.value;

    // Restricted pages that require authentication
    final restrictedRoutes = [
      '/profile',
      '/order',
      '/training/videos',
      '/order/checkout',
      '/require_credit_card',
      // '/user/migration',
    ];

    // Redirect unauthenticated users trying to access restricted pages
    if (isNotAuthenticated && restrictedRoutes.contains(route)) {
      print('User must be logged in to access $route');
      return const RouteSettings(name: '/login');
    }

    // Redirect authenticated users who are still onboarding
    if (isAuthenticated && isOnboarding && route != '/onboarding') {
      return const RouteSettings(name: '/onboarding');
    }

    // If user is a migration user, enforce address and card payment in order
    if (isMigrationUser) {
      if (!user.hasAddress && route != '/require_address') {
        return const RouteSettings(name: '/require_address');
      }
      if (!user.hasCardPayment && route != '/require_card_payment' && route != '/require_address') {
        return const RouteSettings(name: '/require_card_payment');
      }
    }

    // Redirect users away from `/require_address` if they already have an address
    if (route == '/require_address' && user.hasAddress) {
      return const RouteSettings(name: '/shop');
    }

    // Redirect users away from `/require_card_payment` if they already have a card payment method
    if (route == '/require_card_payment' && user.hasCardPayment) {
      return const RouteSettings(name: '/shop');
    }

    return null; // No redirection needed
  }

// RouteSettings? redirect(String? route) {
  //   print('Route: $route');
  //   final authServer = Get.find<GlobalController>();
  //   final migrationUserAuthInitialValidationCheck =  (authServer.isAuthenticated.isTrue && authServer.onboardingProcessStep.value == 99);
  //   if (authServer.isAuthenticated.isFalse && (
  //       route == '/profile'
  //       || route == '/order'
  //       || route == '/training/videos'
  //       || route == '/order/checkout'
  //       || route == '/require_credit_card'
  //       || route == '/user/migration'
  //   )) {
  //     print('Here must have acceess');
  //     return const RouteSettings(name: '/login');
  //   }
  //   else if((authServer.isAuthenticated.isTrue && authServer.isOnboarding.isTrue) && route != '/onboarding'){
  //     return const RouteSettings(name: '/onboarding');
  //   }
  //   // else if((migrationUserAuthInitialValidationCheck && !authServer.user.value.hasAddress) && route != '/require_address'){
  //   //   return const RouteSettings(name: '/require_address');
  //   // }
  //   // else if((migrationUserAuthInitialValidationCheck && !authServer.user.value.hasCardPayment) && route != '/require_card_payment'){
  //   //   return const RouteSettings(name: '/require_card_payment');
  //   // }
  //   else if (migrationUserAuthInitialValidationCheck && !authServer.user.value.hasAddress && route != '/require_address') {
  //     return const RouteSettings(name: '/require_address');
  //   }
  //
  //   if (migrationUserAuthInitialValidationCheck &&
  //       !authServer.user.value.hasCardPayment &&
  //       route != '/require_card_payment' &&
  //       route != '/require_address') {
  //     return const RouteSettings(name: '/require_card_payment');
  //   }
  //   return null;
  // }
}