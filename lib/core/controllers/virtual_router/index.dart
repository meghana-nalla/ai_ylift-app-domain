import 'dart:async';
import 'package:get/get.dart';
import 'package:YLift/core/constants/index.dart';
import 'package:YLift/core/controllers/z-index_export.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web/web.dart' as web;

const _redirectPathKey = 'redirectPath';

/// VirtualRouterController
/// Handles internal navigation state and virtual routing
class VirtualRouterController extends GetxController {
  final GlobalController global = Get.find<GlobalController>();
  final _prefs = SharedPreferencesAsync();

  // Current virtual route index
  final Rx<int> currentRouteIndex = 0.obs;

  // Route history stack for back navigation
  final RxList<int> routeHistory = <int>[].obs;

  // loading state tracking
  final Rx<bool> isNavigating = false.obs;

  // save current route
  final Rx<String> currentRoute = ''.obs;

  // Navigation timeout duration
  static const navigationTimeout = Duration(seconds: 10);

  // Maps route indices to their semantic names for mobile
  // final Map<String, int> routeIndicesMobile = {
  //   'home': 0,
  //   // 'video': 1,
  //   'profile': 2,
  //   'cart': 1,
  //   'menu': 3,
  //   'chat': 5,
  //   'product': 6,
  //   'training': 8,
  //   'videoDetail': 9,
  // };

  // Maps url route indices to their semantic names for mobile
  final Map<String, int> urlToRouteIndexMobile = {
    '/': 0,
    '/home': 0,
    '/shop': 0,
    '/shop/all': 50,
    // '/video': 1,
    // '/know-y': 1,
    // '/profile': 2,
    '/cart': 3,
    '/cart/promotions': 2,
    // '/menu': 4,
    // '/chat': 5,
    '/training':7,
    '/mobile-network-provider':14,
    '/forgot_password': 19,
    '/courses':34,
    '/courses/view': 35,
    '/courses/view/': 35,
    '/promotions':30,
    '/product': 6,
    '/login': 17,
    '/signup': 18,
    '/onboarding': 20,
    '/categories': 9,
    '/checkout': 4,
    '/order/confirm': 5,
    '/user/migration': 13,
    '/profile': 10,
  };

  // Maps url route indices to their semantic names for desktop
  final Map<String, int> urlToRouteIndexDesktop = {
    '/': 0,
    '/home': 0,
    '/video': 1,
    '/developer':33,
    '/courses': 34,
    '/courses/view': 35,
    '/courses/view/': 35,
    '/know-y': 1,
    '/profile': 2,
    '/order/cart': 3,
    '/order/checkout': 4,
    '/order/confirm': 5,
    '/order/schedule': 11,
    '/product': 6,
    '/shop/product': 6,
    '/training': 7,
    '/shop': 8,
    '/shop/categories': 9,
    '/shop/brands': 10,
    '/shop/brand': 50, // map brand route to shop all page
    '/shop/all': 50,   // both shop/all and shop/brand go to the same page
    // '/shop/featured': 11,
    '/network-provider': 14,
    '/y-university': 15,
    '/search': 16,
    '/login': 17,
    '/signup': 18,
    '/signup/for/affiliate': 18,
    '/forgot_password': 19,
    '/onboarding': 20,
    '/two_factor_authentication': 21,
    '/reset_password': 22,
    '/docusign': 23,
    '/user/migration': 24,
    '/training/payment': 25,
    '/email/verification': 27,
    '/account_created': 28,
    '/promotions': 30,
    '/promotion': 31,
    // '/events':32,
    '/require_address': 40,
    '/require_card_payment': 41,
    '/shop/all': 50,
    '/brands/all': 51,
    '/training/register': 70,
    '/bootylift': 71,
    '/training/videos': 72,
    '/logout': 98,
    '/error': 99,
  };

  Future<void> returnToHome() async {
    // First show splash during the transition
    global.showingSplash.value = true;
    global.siteReady.value = false;
    global.update();

    print('Returning to home/shop page');

    // Set the view index first before URL change to prevent flashing
    await navigateToIndex(8); // home is now shop

    // Update route tracking - set to /shop not / to avoid infinite loop
    currentRoute.value = '/shop';
    setPageTitleToDefault();

    // Change URL only after view is already set
    Get.offAllNamed('/shop');

    // Give a short delay before hiding splash to ensure smooth transition
    await Future.delayed(const Duration(milliseconds: 200));

    // Finally hide splash
    global.showingSplash.value = false;
    global.siteReady.value = true;
    global.update();
  }

  void setPageTitle(String title) {
    web.document.title = title;
  }
  void setPageTitleToDefault() {
    web.document.title = SITE_NAME;
  }

  /// Navigate to a virtual route by index
  Future<void> navigateToIndex(int index) async {
    print('Navigating to index: $index');
    if (currentRouteIndex.value == index) {
      print('Already at index $index, skipping');
      return;
    }

    routeHistory.add(currentRouteIndex.value);
    currentRouteIndex.value = index;
    await _updateGlobalState(index);
  }


  Future<String?> getInnerRedirect() async {
    final redirectPath = await _prefs.getString(_redirectPathKey);
    await _prefs.remove(_redirectPathKey);
    return redirectPath;
  }

  Future<void>setInnerRedirect(String redirectPath) async {
    // remove any existing redirect path
    await _prefs.remove(_redirectPathKey);
    await _prefs.setString(_redirectPathKey, redirectPath);
  }

  /// Navigate to a virtual route by name
  Future<void> navigateTo(String route, {String? redirectPath, String? productId, String? extra}) async {
    print('Navigating to route: $route');
    if(global.isMobile.isTrue){
      print('MOBILE ROUTE INDEX: ${global.navigateMobileIndex.value}');
      final mobileRoute = route.split('#').first;
      final mobileIndex = urlToRouteIndexMobile[mobileRoute] ?? 0;
      global.navigateMobileIndex.value = mobileIndex;
    }

    if (isNavigating.value && currentRoute.value == route && currentRoute.value != '/shop/all') {
      print('Navigation already in progress, skipping');
      return;
    }

    if (route == '/shop/all' && extra == 'query=ALL_PRODUCTS') {
      global.recentSearchQuery.value = 'ALL_PRODUCTS';
    }

    currentRoute.value = route;

    final navigationId = 'navigation-${DateTime.now().millisecondsSinceEpoch}';
    try {
      // show splash screen during navigation
      global.showingSplash.value = true;
      global.siteReady.value = false;
      global.update();

      isNavigating.value = true;

      if (extra != null) {
        print('EXTRA IN NAV: $extra');
        await _prefs.setString('extra', extra);
      }

      await global.loading.withLoading<void>(
          operationId: navigationId,
          operation: () async {
            if (redirectPath != null && !global.isAuthenticated.isTrue) {
              await _prefs.setString(_redirectPathKey, redirectPath);
            }
            if (productId != null) {
              await _prefs.setString('productId', productId);
            }

            // Execute navigation steps sequentially
            await _preloadRouteData(route);
            await Get.toNamed(route);
            await handleUrlRoute(route);
            await _waitForViewReady();
          }
      );
    } catch (e) {
      print('Navigation error: $e');
      _handleNavigationError();
    } finally {
      _finalizeNavigation();
    }
  }

  Future<void> _executeNavigation(String route) async {
    try {
      await global.loading.withMultiLoading<void>(
          groupId: 'navigation-tasks',
          operations: [
                () => _preloadRouteData(route),
                () async => await Get.toNamed(route),
                () => handleUrlRoute(route),
                () => _waitForViewReady(),
          ]
      );
    } catch (e) {
      print('Error executing navigation: $e');
      _handleNavigationError();
    } finally {
      print('Navigation execution completed');
    }
  }

  Future<void> _preloadRouteData(String route) async {
    if (route.startsWith('/product/')) {
      final productId = int.tryParse(route.split('/').last);
      if (productId != null) {
        await global.products.getProductSimple(productId);
      }
    }
  }

  Future<void> _waitForViewReady() async {
    await Future.delayed(const Duration(milliseconds: 100));
    global.siteReady.value = true;
  }

  void _handleNavigationError() {
    navigateToIndex(urlToRouteIndexMobile['/']!);
    global.displayHomePage.value = true;
  }

  void _finalizeNavigation() {
    print('Finalizing navigation and hiding splash screen');
    isNavigating.value = false;
    global.showingSplash.value = false;
    global.siteReady.value = true;
    global.update();

    // double-check that splash is off after a small delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (global.showingSplash.value) {
        print('Additional splash cleanup needed');
        global.showingSplash.value = false;
        global.update();
      }
    });

    print('Navigation finalized, splash hidden');
  }

  /// Navigate back to previous virtual route
  void navigateBack() {
    if (routeHistory.isNotEmpty) {
      currentRouteIndex.value = routeHistory.last;
      routeHistory.removeLast();
      _updateGlobalState(currentRouteIndex.value);
    }
  }

  /// Update global state based on route index
  Future<void> _updateGlobalState(int index) async {
    global.navigateMobileIndex.value = index;
    global.navigateDesktopIndex.value = index;

    if (index == urlToRouteIndexMobile['/home']) {
      global.displayHomePage.value = true;
      global.searchBarEnable.value = true;
    } else {
      global.searchBarEnable.value = false;
    }

    global.update();
  }

  /// Navigate softly to product is used inside the single product page
  Future<void> navigateSoftlyToProduct(int productId) async {
    // Update the virtual route tracker to ensure we're in product mode
    currentRoute.value = '/shop/product/$productId';

    // Now change the URL for proper bookmarking and sharing
    // Use toNamed instead of offAndToNamed to avoid rebuilding the entire page
    Get.toNamed('/shop/product/$productId', preventDuplicates: true);
  }

    Future<void> navigateToProduct(int productId) async {
    try {
      // make sure splash is shown during navigation
      isNavigating.value = true;
      global.siteReady.value = false;
      global.showingSplash.value = true;
      global.update();

      print('Starting navigation to product $productId with splash screen');

      // clear any existing product ID and save new one immediately
      await _prefs.remove('productId');
      // await _prefs.setString('productId', productId.toString());

      // First set the view index to product page BEFORE any data loading or URL change
      // This is critical to prevent shop page flashing
      await navigateToIndex(6);

      // Update the virtual route tracker to ensure we're in product mode
      currentRoute.value = '/shop/product/$productId';

      // Now change the URL for proper bookmarking and sharing
      // Use toNamed instead of offAndToNamed to avoid rebuilding the entire page
      Get.toNamed('/shop/product/$productId', preventDuplicates: true);

      // Only after the view is set up, load the product data in the background
      // Find the product in the cache or fetch it
      ProductSimple? productToDisplay = global.allProducts.value.products.firstWhereOrNull((e) {
        return e.productId == productId;
      });

      // If not found in cache, try to fetch it directly
      if (productToDisplay == null) {
        try {
          productToDisplay = await global.products.getProductSimple(productId);
        } catch (e) {
          print('Error fetching product: $e');
          throw('Could not navigate to product. Product not found.');
        }
      }

      if (productToDisplay == null) {
        throw('Could not navigate to product. This needs better error handling');
      }

      // Set the product in global state after navigation is already complete
      global.displayProduct.value = productToDisplay;

      // Ensure the product view has enough time to initialize with the data
      await Future.delayed(const Duration(milliseconds: 200));
    }
    catch (e) {
      print('Error in VirtualRouterController.navigateToProduct() $e');
      return;
    } finally {
      _finalizeNavigation();
      print('Navigation to product completed and finalized');
    }
  }

  Future<void> goToCartPage() async {
    if (global.isAuthenticated.isFalse) {
      await navigateTo('/login');
      return;
    }
    await navigateTo('/order/cart');
  }

  /// Navigate based on quick link tap index
  void navigateQuickLinksTap(int index) {
    global.searchBarEnable.value = false;
    global.displayHomePage.value = false;
    global.navigateQuickLinkIndex.value = index;
    global.display.setDynamicData();
    update();
  }

  /// Handle navigation from URL routes
  Future<void> handleUrlRoute(String route) async {
    if (global.isMobile.isTrue) {
      await _handleUrlRouteMobile(route);
    } else {
      await _handleUrlRouteDesktop(route);
    }
    update();
  }

  /// Handle URL routes for mobile
  Future<void> _handleUrlRouteMobile(String route) async {
    route = route.split('?').first;
    route = route.split('#').first;
    print('Handling URL route for mobile: $route');

    try {
      if (urlToRouteIndexMobile.containsKey(route)) {
        navigateToIndex(urlToRouteIndexMobile[route]!);
        if (route == '/' || route == '/home') {
          global.displayHomePage.value = true;
        }
        return;
      }

      if (route.startsWith('/shop/product/')) {
        await _handleProductRoute(route);
        return;
      }

      if (route.startsWith('/courses/view/')) {
        await _handleVideoViewRoute(route);
        return;
      }

      _handleUnknownRoute();
    } catch (e) {
      print('Error handling URL route: $e');
      _handleUnknownRoute();
    }
  }

  Future<void> _handleUrlRouteDesktop(String route) async {
    var path = route.split('?').first;
    path = path.split('#').first;
    try {
      // shop by brand route: /shop/brand/{brandId}
      if (path.startsWith('/shop/brand/')) {
        // extract the brandId from the route
        final segments = path.split('/');
        if (segments.length >= 4) {
          final brandId = segments[3];

          // Show splash during navigation
          global.showingSplash.value = true;
          global.siteReady.value = false;
          global.update();

          // set the global selected brand ID for filtering
          global.selectedBrandId.value = 'brand=$brandId';

          // navigate to the shop all page route index (50)
          await navigateToIndex(50);

          // set the filter data in prefs
          await _prefs.setString('extra', 'brand=$brandId');

          // Wait for view to be ready, then hide splash
          await Future.delayed(const Duration(milliseconds: 200));
          global.showingSplash.value = false;
          global.siteReady.value = true;
          global.update();
          return;
        }
      }

      if (urlToRouteIndexDesktop.containsKey(path)) {
        navigateToIndex(urlToRouteIndexDesktop[path]!);
        if (route == '/' || route == '/home') {
          global.displayHomePage.value = true;
        }
        return;
      }

      if(route.contains('signup')){
        navigateToIndex(18);
        return;
      }

      if(route.contains('email/verification')){
        navigateToIndex(27);
        return;
      }

      if (route.contains('brands')) {
        navigateToIndex(10);
        return;
      }

      if (route.startsWith('/shop/product/')) {
        await _handleProductRoute(route);
        return;
      }
    } catch (e) {
      print('Error handling URL route: $e');
    }
  }

  Future<void> _handleProductRoute(String route) async {
    // Show the splash screen during product loading
    global.showingSplash.value = true;
    global.siteReady.value = false;

    // Extract the product ID from the route
    String productIdString = route.split('/').last;
    int? productId = int.tryParse(productIdString);

    if (productId != null) {
      // First set the view index to product page BEFORE loading data
      // This prevents the shop page from flashing
      if (global.isMobile.isTrue) {
        navigateToIndex(urlToRouteIndexMobile['/product']!);
      } else {
        navigateToIndex(urlToRouteIndexDesktop['/product']!);
      }

      // Then load and display the product, preserving the URL
      await _loadAndDisplayProduct(productId, originalRoute: route);
    } else {
      _handleUnknownRoute();
      // Hide splash even if we couldn't find the product
      global.showingSplash.value = false;
      global.siteReady.value = true;
    }
  }

  Future<void> _loadAndDisplayProduct(int productId, {String? originalRoute}) async {
    try {
      // load the product data
      var requestedProductSimple = await global.products.getProductSimple(productId);

      // set the product in global state
      global.displayProduct.value = ProductSimple(
          name: requestedProductSimple.name,
          imageUrl: requestedProductSimple.imageUrl.isNotEmpty ? requestedProductSimple.imageUrl : PLACEHOLDER_IMAGE,
          price: requestedProductSimple.price,
          isActive: requestedProductSimple.isActive,
          id: requestedProductSimple.id,
          description: requestedProductSimple.description,
          displayPrice: requestedProductSimple.displayPrice,
          displayRetailPrice: requestedProductSimple.displayRetailPrice,
          caption: requestedProductSimple.caption,
          isOutOfStock: requestedProductSimple.isOutOfStock,
          skus: requestedProductSimple.skus,
          productBrands: requestedProductSimple.productBrands,
          brandName: requestedProductSimple.brandName,
          brandId: requestedProductSimple.brandId,
          productId: productId
      );



      // Update current route to track we're on a product page
      if (originalRoute != null) {
        currentRoute.value = originalRoute;

        // This helps the ProductPageView to initialize with the right product
        await _prefs.setString('productId', productId.toString());

        // Ensure everything is loaded and ready
        await _waitForViewReady();
      }

      // Make sure the splash screen is turned off only after everything is loaded
      await Future.delayed(const Duration(milliseconds: 100));
      global.showingSplash.value = false;
      global.siteReady.value = true;
    } catch (e) {
      print('Error loading product: $e');
      _handleUnknownRoute();
      global.showingSplash.value = false;
      global.siteReady.value = true;
    }
  }

  Future<void> _handleVideoViewRoute(String route) async {
    // Show the splash screen during video loading
    global.showingSplash.value = true;
    global.siteReady.value = false;

    try {
      // First set the view index to video view page
      navigateToIndex(urlToRouteIndexDesktop['/courses/view']!);

      // Extract the video ID from the route
      String videoId = route.split('/').last;

      // Store the videoId for the view page to use
      await _prefs.setString('videoId', videoId);

      // Wait for view to be ready, then hide splash
      await Future.delayed(const Duration(milliseconds: 200));
      global.showingSplash.value = false;
      global.siteReady.value = true;
      global.update();
    } catch (e) {
      print('Error handling video view route: $e');
      _handleUnknownRoute();
      // Hide splash even if there's an error
      global.showingSplash.value = false;
      global.siteReady.value = true;
    }
  }

  void _handleUnknownRoute() {
    navigateToIndex(urlToRouteIndexMobile['/']!);
    global.displayHomePage.value = true;
  }
}