import 'dart:async';
import 'dart:developer';

import 'package:YLift/core/constants/index.dart';
import 'package:YLift/core/controllers/galderma_promotion/index.dart';
import 'package:YLift/core/controllers/training/index.dart';
import 'package:YLift/core/controllers/user/onboard.dart';
import 'package:YLift/core/controllers/user/profile.dart';
import 'package:YLift/core/controllers/virtual_router/loading.dart';
import 'package:YLift/core/controllers/z-index_export.dart';
import 'package:YLift/core/services/api.dart';
import 'package:galaxy_models/galaxy_models.dart' hide UserProfileController;
import 'package:YLift/models/z-index_export.dart';
import 'package:YLift/presentation/pages/desktop/grid_shopping/shop_all_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/cookie_service.dart';
import 'carts/drawer.dart';
import 'categories/index.dart';
import 'orders/index.dart';

/// # GlobalController
/// Responsible for managing the global state of the application
/// and initializing all other controllers
///
/// We use this as application logic as well so that we can keep
/// the controllers separate and focused on their own responsibilities
///
class GlobalController extends GetxController {
  // Constants
  final Rx<String> siteName = SITE_NAME.obs;
  final Rx<bool> isProductionMode = false.obs;
  final globalScaffoldKey = GlobalKey<ScaffoldState>();
  
  final RxBool isInMaintenance = false.obs;
  final RxBool hasPatchUpdate = false.obs;

  final RxBool immediateButtonDismiss = false.obs; // cart button for immediate purchase

  // Controllers
  late AddressBookController addressBook; // TODO : this should exist inside user
  late Auth0Controller auth;
  late CartController basket; // cart controller
  late CartDrawerController drawerController;
  late CategoriesController category; // TODO : this should exist inside products
  late CategoriesController subcategory;
  late DisplayController display;
  late OrdersController orders;
  late OnboardController onboard; // TODO : this should exist inside user
  late ProductsController products;
  late PromotionsController promos;
  late QuickLinksController quick;
  late UserController userController;
  late VirtualRouterController vroute;

  late UserProfileController userProfile;

  late TrainingController training;

  late GaldermaController galdermaController;

  // Services
  late ApiService api;
  late LoadingService loading;

  // Authentication & User Data
  final Rx<UserData> profile = UserData().obs;
  final Rx<bool> isAuthenticated = false.obs;
  final RxList<String> grantedScopes = <String>[].obs;
  final Rx<int> onboardingProcessStep = 0.obs;
  final Rx<int> affiliateOnboardingProcessStep = 0.obs;
  final RxMap<String, dynamic> signUpPayload = <String, dynamic>{}.obs;
  final RxList<OrderSimple> quickOrders = <OrderSimple>[].obs;

  bool get isUserNonMedical => isAuthenticated.value && user.value.medicalLicense == null;

  final RxInt totalProductsCount = (-1).obs;

  Rx<AuthToken> authToken = AuthToken.empty().obs;


  Rx<String> bearerToken = ''.obs;
  Rx<AuthProfileUser> user = AuthProfileUser(
    profileId: 0,
    email: '',
  ).obs;

  // Device
  final Rx<bool> isMobile = false.obs;

  // Loading states
  final Rx<bool> siteInitLoaded = false.obs;
  final Rx<bool> showingSplash = true.obs;
  bool _isDisposed = false;
  final Rx<bool> showingPromotion = false.obs;
  final Rx<bool> siteReady = false.obs;
  final Rx<bool> showLoadingBar = false.obs;

  // UI states
  final Rx<bool> searchBarEnabled = true.obs;
  final Rx<bool> searchBarEnable = true.obs;
  final Rx<bool> displayHomePage = true.obs;
  final RxBool isOnboarding = false.obs;
  final RxBool hideTopNavigation = false.obs;

  // Debug state
  final RxBool onboardingDebugMode = true.obs;

  // Navigation
  final Rx<int> navigateMobileIndex = 0.obs;
  final Rx<int> navigateDesktopIndex = 0.obs;
  final Rx<int> navigateQuickLinkIndex = 0.obs;
  final Rx<bool> enteredSubcategory = false.obs;

  // Cookies
  final Rx<bool> showCookies = true.obs;
  final Rx<bool> confirmCookiesDialog = true.obs;


  // Data
  final RxList<GalaxyPromotion> activePromotions = <GalaxyPromotion>[].obs;
  final RxList<QuickLinksSimple> quickLinks = <QuickLinksSimple>[].obs;
  final RxList<ProductSimple> bestSellerProducts = <ProductSimple>[].obs;
  final RxList<ProductSimple> featuredProducts = <ProductSimple>[].obs;
  // final RxList<ProductSimple> allProducts = <ProductSimple>[].obs;
  // final Rx<DateTime> latestProductFetch = DateTime.now().obs;
  final RxList<OrderSimple> orderHistory = <OrderSimple>[].obs;
  final RxInt orderHistoryCount = 0.obs;

  final Rx<BundleProductPrices> bundleProductPrices =  BundleProductPrices().obs;
  final Rx<AllProducts> allProducts = AllProducts(
    products: <ProductSimple>[],
    latestProductsFetch: DateTime.now(),
  ).obs;
  final Rx<AllVirtualProducts> allVirtualProducts = AllVirtualProducts(virtualProducts: []).obs;

  final RxList<ProductSimple> newestProducts = <ProductSimple>[].obs;
  final RxList<ProductSimple> searchResultProducts = <ProductSimple>[].obs;
  final RxList<ProductCategory> categories = <ProductCategory>[].obs;
  final RxList<ProductSubcategory> subcategories = <ProductSubcategory>[].obs;
  final RxList<ProductBrand> brands = <ProductBrand>[].obs;
  final RxList<VendorSimple> vendors = <VendorSimple>[].obs;
  final Rx<SearchResult> recentSearch = SearchResult().obs;
  final Rx<OrderApiResponse> recentOrder = OrderApiResponse().obs;

  final RxList<CardPayment> userCardPayments = <CardPayment>[].obs;

  final Rx<ProductCategory> selectedCategory = ProductCategory.dummy().obs;
  final Rx<ProductBrand> selectedBrand = ProductBrand.dummy().obs;

  final Rx<String> selectedBrandId = ''.obs;

  // final RxMap<String, List<ProductSimple>> categoryProductsMap = <String, List<ProductSimple>>{}.obs;

  // Trainings
  Rx<TrainingInterest> trainingInterest = TrainingInterest(tagName: '', name: '', oneTimeFee: 0).obs;

  final RxList<TrainingCourse> trainingCourses = <TrainingCourse>[].obs;
  final Rx<VideoTrainingCourse> loadedVirtualContent = VideoTrainingCourse().obs;
  Rxn<TrainingCourse?> selectedTrainingCourse = Rxn<TrainingCourse>();
  final RxList<TrainingSubscription> trainingSubscription = <TrainingSubscription>[].obs;

  // Shop all
  final Rx<ShopAllSortBy> shopAllSortBy = ShopAllSortBy.values.first.obs;

  // Carts
  final Rx<CustomerCart> cart = CustomerCart().obs;
  final Rx<CartSimple> simpleCart = CartSimple(
    createdAt: DateTime.now(),
  ).obs;

  // flag for updating widgets
  final Rx<bool> widgetChanged = false.obs;

  // result of most recent search query
  final Rx<String> recentSearchQuery = ''.obs;

  // user's recent searches
  final RxList<String> previousSearches = <String>[].obs;

  /// # Array of simple products
  /// it gets switched out depending on the quick links index
  ///
  /// *note: this can also hold categories and brands
  /// .. categories and brands are not products but we can use the same model*
  final RxList<ProductSimple> dynamicProducts = <ProductSimple>[].obs;
  final RxList<PromotionSimple> promotions = <PromotionSimple>[].obs;
  // final Rx<DisplayProduct> displayProduct = DisplayProduct(product: ProductSimple(name: ''), showPrice: false).obs;
  final Rx<ProductSimple> displayProduct = ProductSimple(name: '').obs;
  // *************************************************************************

  // splash screen logic, avoid data race
  Timer? _splashMinTimer;
  Timer? _splashMaxTimer;
  final _initCompleter = Completer<void>();
  static const splashMinDuration = Duration(milliseconds: 500);
  static const splashMaxDuration = Duration(seconds: 3);

  @override
  void onClose() {
    _isDisposed = true;
    _cleanupSplashTimers();
    super.onClose();
  }

  void _setupSplashTimers() {
    // Start max duration safety timer
    _splashMaxTimer = Timer(splashMaxDuration, () {
      if (!_isDisposed) {
        print('Splash screen max duration exceeded - forcing hide');
        // Only force hide if loading is complete
        if (!loading.isLoading.value) {
          showingSplash.value = false;
        }
      }
    });

    // Set up minimum duration timer
    _splashMinTimer = Timer(splashMinDuration, () {
      if (!_isDisposed && siteInitLoaded.value) {
        // Only hide splash if loading is complete
        if (!loading.isLoading.value) {
          showingSplash.value = false;
        }
      }
    });
  }


  void _cleanupSplashTimers() {
    _splashMinTimer?.cancel();
    _splashMaxTimer?.cancel();
    _splashMinTimer = null;
    _splashMaxTimer = null;
  }

  final Rx<bool> isInitialized = false.obs;

  Future<void> init() async {
    print('GlobalController initialization started');
    bool initSuccess = false;
    siteReady.value = false;
    showingSplash.value = true;
    _setupSplashTimers();

    try {
      // Initialize the loading service first
      loading = Get.put(LoadingService(), permanent: true);

      await loading.withLoading(
          operationId: 'global-init',
          operation: () async {
            // Initialize services
            api = await Get.putAsync(() => ApiService().init());

            // Initialize controllers
            products = Get.put(ProductsController());
            promos = Get.put(PromotionsController());
            quick = Get.put(QuickLinksController());
            display = Get.put(DisplayController());
            basket = Get.put(CartController());
            auth = Get.put(Auth0Controller());
            userController = Get.put(UserController());
            vroute = Get.put(VirtualRouterController());
            addressBook = Get.put(AddressBookController());
            drawerController = Get.put(CartDrawerController());
            category = Get.put(CategoriesController());
            subcategory = Get.put(CategoriesController());
            orders = Get.put(OrdersController());
            onboard = Get.put(OnboardController());
            userProfile = Get.put(UserProfileController());
            training = Get.put(TrainingController());
            galdermaController = Get.put(GaldermaController());

            // check if user is already authenticated
            if (AuthCookieHandler.isAuthenticated()) {
              final authieCookie = AuthCookieHandler.getBearerToken();
              if (authieCookie != null) {
                authToken.value = AuthToken(
                  tokToken: authieCookie,
                  freshTokToken: '',
                  expiration: DateTime.now().add(Duration(days: 1)), // or pull real value if stored
                );
                isAuthenticated.value = true;
                update();
              }
            }

            // Initialize authentication
            if (isAuthenticated.isTrue) await _initializeUser();

            // Load initial data
            await _loadInitialData();

            categories.value = await category.getCategories();
            subcategories.value = await subcategory.getSubcategories();
            bestSellerProducts.value = products.getBestSellerProducts();
            featuredProducts.value = products.getFeaturedProducts();
          });

      // Mark initialization as complete
      isInitialized.value = true;
      siteReady.value = true;
      siteInitLoaded.value = true;
      initSuccess = true;

      // Complete the initialization completer
      if (!_initCompleter.isCompleted) {
        _initCompleter.complete();
      }

      print('GlobalController initialized completely');
    } catch (e) {
      print('Error in GlobalController initialization: $e');
      siteReady.value = true; // Ensure site becomes ready even on error

      if (!_initCompleter.isCompleted) {
        _initCompleter.completeError(e);
      }

      rethrow;
    } finally {
      // Always ensure these are set properly regardless of success/failure
      if (!_isDisposed) {
        // Only hide the splash screen after the minimum display time
        // And when all navigation/loading is complete
        if ((_splashMinTimer == null || !_splashMinTimer!.isActive) && 
            !loading.isLoading.value) {
          showingSplash.value = false;
        }
      }
    }
  }


  Future<void> _initializeUser() async {
    try {
      await auth.performRefreshToken();
    } catch (e) {
      print('Error initializing token for user : $e');
    }
  }

  final RxBool loadAppData = false.obs;

  Future<void> _loadInitialData() async {
    if (loadAppData.isTrue) return;
    if (isAuthenticated.isTrue) {
      await Future.wait([
        quick.assignQuickLinks(), // 👀
        quick.assignBrands(), // 👀
        quick.assignVendors(), // 👀
        quick.assignCategories(), // 👀
        promos.assignActivePromotions(), // 👀
        products.loadAllAuthProducts(), //
        refreshAppLoadData(), //  ✅
      ]);
    }  else {
      await Future.wait([
        quick.assignQuickLinks(), // 👀
        quick.assignBrands(), // 👀
        quick.assignVendors(), // 👀
        quick.assignCategories(), // 👀
        //promos.assignActivePromotions(), // 👀
        products.loadAllAuthProducts(), //
        //userController.getTrainingCourses(),
        refreshAppLoadData(), //  ✅
      ]);
    }
    loadAppData.value = true;
    refresh();
  }

  void updateAuthState() {
    isAuthenticated.value = true;
  }



  Future<SearchResult> searchProducts(String query, {int limit = 50, int offset = 0}) async {
    try {
      final response = await api.get('products/search?query=$query&limit=$limit&offset=$offset');

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonMap = response.data;
        recentSearchQuery.value = query;
        return recentSearch.value = SearchResult.fromJson(jsonMap);
      } else {
        throw Exception('Failed to search products, status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error occurred during search: $e");
      throw Exception('Failed to search products: $e');
    }
  }

  Future<SearchResult> searchCategories(String query, {int limit = 50, int offset = 0}) async {
    try {
      final response = await api.get('search/query=$query&limit=$limit&offset=$offset');

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonMap = response.data;
        return recentSearch.value = SearchResult.fromJson(jsonMap);
      } else {
        throw Exception('Failed to search products, status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error occurred during search: $e");
      throw Exception('Failed to search products: $e');
    }
  }

  // Searches by brand
  Future<SearchResult> searchProductsByBrand(String id, String query, {int limit = 50, int offset = 0}) async {
    try {
      final response = await api.get('products/search?brands=$id&limit=$limit&offset=$offset');

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonMap = response.data;
        return recentSearch.value = SearchResult.fromJson(jsonMap);
      } else {
        throw Exception('Failed to search products, status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error occurred during search: $e");
      throw Exception('Failed to search products: $e');
    }
  }

  Future<void> executeSearch(String query) async {
    try {
      print('Search Query: $query');
      final searchResult = await searchProducts(query);
      dynamicProducts.clear();
      // dynamicProducts.assignAll(searchResult.products!.map((product) => product.toSimpleProduct()).toList());
      // dynamicProducts.assignAll(searchResult.products!.map((product) => product.toSimpleProduct()).toList());

      // We may need to update other parts of the state here, such as:
      categories.value = searchResult.aggregations!['productCategories'];
      // brands.value = searchResult.aggregations['productBrands'];
      // etc. depending on the search result structure and what we want to display
      // TODO: Evaluate after implementing Desktop search UI and decide on the best approach
    } catch (e) {
      handleError('Error executing search', e);
    }
  }

  Future<void> loadShippingSettings() async {
    try {
      final response = await api.get(ApiUrl.cartShipping.path);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonMap = response.data;
        List<dynamic> productShippingSettingsData = jsonMap['productShippingSettings'];
        List<dynamic> vendorShippingSettingsData = jsonMap['vendorShippingSettings'];

        final cartItemsResponse = CartItemsResponse.fromJson(jsonMap);

        List<ProductShippingSettings> productShippingSettings =
        productShippingSettingsData.map((item) => ProductShippingSettings.fromJson(item)).toList();

        List<VendorShippingSettings> vendorShippingSettings =
        vendorShippingSettingsData.map((item) => VendorShippingSettings.fromJson(item)).toList();

        // // Calculate quantities for products and vendors
        // Map<int, int> productQuantities = {};
        // Map<int, int> vendorQuantities = {};
        //
        //
        // for (var item in cartItemsResponse.cartItemsByProduct.values) {
        //   productQuantities[item.id] = item.quantity;
        // }
        //
        // for (var items in cartItemsResponse.cartItemsByVendor.values) {
        //   for (var item in items) {
        //     vendorQuantities[item.id] = item.quantity;
        //   }
        // }

        List<ShippingSettings> allShippingSettings = ShippingSettingsConverter.convertAll(
          productShippingSettings,
          vendorShippingSettings,
          cartItemsResponse.cartItemsByProduct,
          cartItemsResponse.cartItemsByVendor,
        );

        cart.value.updateShippingInfo(allShippingSettings);

        // Initialize shipping for flat rate items
        for (var shipping in cart.value.checkout!.shippingInfo) {
          if (shipping.isFlatRate) {
            shipping.selectedRate = shipping.regularRate;
          }
        }

        cart.value.recalculateShipping();
      }
    } catch (e) {
      print('Error fetching shipping settings: $e');
    }
  }

  // *************************************************************************
  //
  // Managing Application State (SSOT)
  //
  // *************************************************************************

  Future<void> refreshAppLoadData() async {
    try {
      print('Refreshing app load data');
      showingSplash.value = true;
      refresh();
      await loading.withLoading(
        operationId: 'refresh-app-data',
        operation: () async {
          isAuthenticated.isTrue ? await userLoggedInDependencies() : await generalPublicDependencies();
        }
      );
      refresh();
    } catch (e) {
      print('Error refreshing user data: $e');
      showingSplash.value = false; // Ensure splash is hidden on error
    }
  }

  Future<void> refreshAppLoadDataOnboarding() async {
    try{
      showingSplash.value = true;
      await loading.withLoading(
        operationId: 'refresh-app-data-onboarding',
        operation: () async {
          //Loading Agnostic Data
          bestSellerProducts.clear();
          bestSellerProducts.value = await products.getBestSellerProducts(); // 👀
          featuredProducts.clear();
          featuredProducts.value = await products.getFeaturedProducts(); // 👀
          // we need categories map
          // categoryProductsMap.clear();
          // await category.setCategoryMapping(); // ✅
          // load products
          quickOrders.value = [];
          quickOrders.value = await orders.fetchQuickOrders(); // ✅
          await products.loadAllAuthProducts();
          await orders.initializeOrderHistoryData();
          // load addresses
          addressBook.addresses.value = [];
          await addressBook.loadAddresses(); // 👀
        }
      );
      refresh();
    } catch (e) {
      print('Error refreshing user data: $e');
      showingSplash.value = false; // Ensure splash is hidden on error
    }
  }

  Future<void> agnosticDataLoad() async {
    bestSellerProducts.value = await products.getBestSellerProducts(); // 👀
    featuredProducts.value = await products.getFeaturedProducts(); // 👀
    // we need categories map
    // categoryProductsMap.clear();
    // await category.setCategoryMapping(); // ✅
  }

  // we use to get the user data on init load
  // this should happen once the user logs in.
  Future<void> userLoggedInDependencies() async {
    await agnosticDataLoad(); // ✅
    // we need the users quick orders
    quickOrders.value = [];
    quickOrders.value = await orders.fetchQuickOrders(); // ✅
    await products.loadAllAuthProducts();
    await orders.initializeOrderHistoryData();
    // load addresses
    addressBook.addresses.value = [];
    await addressBook.loadAddresses(); // 👀
  }

  // we use to get the general public data on init load
  // or clear user data when user logs out
  Future<void> generalPublicDependencies() async {
    await agnosticDataLoad(); // ✅
    // we need the users quick orders
    quickOrders.value = [];
    addressBook.addresses.value = [];
  }

  Future<void> blowOutCarts() async {
    cart.value = CustomerCart();
    simpleCart.value = CartSimple(createdAt: DateTime.now());
    refresh();
  }

  Future<void> blowOutUserData() async {
    profile.value = UserData();
    isAuthenticated.value = false;
    AuthCookieHandler.clearAuthData();
    grantedScopes.clear();
    user.value = AuthProfileUser(profileId: 0, email: '');
    authToken.value = AuthToken(tokToken: '', freshTokToken: '', expiration: DateTime.fromMillisecondsSinceEpoch(0),);
    bearerToken.value = '';
    refresh();
  }

  // *************************************************************************
  //
  // Development tools
  //
  // *************************************************************************

  /// Set the app to be in debug Mode
  bool setDebugMode() {
    isProductionMode.value = false;
    debugPrint('Debug Mode is on');
    return true;
  }

  void print(value) {
    if (!isProductionMode.value) {
      debugPrint(value);
    }
  }
  
  Future<bool> checkMaintenance() async {
    try{
      final dio = Dio();
      final response = await dio.get('$API_WEB_LINK/health/check/maintenance');
      // final response = await api.getData('health/check/maintenance');
      if(response.statusCode == 200) {
        final isInMaintenance = _getBool(response.data);
        print('Y Lift Store Maintenance: $isInMaintenance');
        this.isInMaintenance.value = isInMaintenance;
        return isInMaintenance;
      } else {
        return false;
      }
    } catch (e, s) {
      print('Error checking maintenance: $e\n $s');
      return false;
    }
  }

  static bool _getBool(dynamic value) {
    if(value is bool) return value;
    if(value is String) return value == 'true';
    return false;
  }

  // *************************************************************************
  //
  // Setup Data Objects
  //
  // *************************************************************************

  void handleError(String message, dynamic error) {
    print('$message: $error');
    // TODO: Implement error handling, showing a user-friendly message
  }

  Future<void> waitForInitialization() => _initCompleter.future;
}