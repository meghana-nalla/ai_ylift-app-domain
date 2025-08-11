import 'package:YLift/core/constants/index.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/core/controllers/z-index_export.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:YLift/presentation/layouts/mobile_view.dart';
import 'package:YLift/presentation/pages/auth/check_passcode/check_passcode_page.dart';
import 'package:YLift/presentation/pages/auth/email_verification/index.dart';
import 'package:YLift/presentation/pages/auth/forgot_password/index.dart';
import 'package:YLift/presentation/pages/auth/login/index.dart';
import 'package:YLift/presentation/pages/auth/logout/index.dart';
import 'package:YLift/presentation/pages/auth/require_address/index.dart';
import 'package:YLift/presentation/pages/auth/require_card_payment/index.dart';
import 'package:YLift/presentation/pages/auth/reset_password/index.dart';
import 'package:YLift/presentation/pages/auth/signup/index.dart';
import 'package:YLift/presentation/pages/auth/signup/mobile_signup.dart';
import 'package:YLift/presentation/pages/auth/two_factor_authentication/index.dart';
import 'package:YLift/presentation/pages/desktop/__primary_courses/online_course_page.dart';
import 'package:YLift/presentation/pages/desktop/__primary_shopping/index.dart';
import 'package:YLift/presentation/pages/desktop/bootylift/index.dart';
import 'package:YLift/presentation/pages/desktop/error_page/index.dart';
import 'package:YLift/presentation/pages/desktop/general_online_course/index.dart';
import 'package:YLift/presentation/pages/desktop/grid_shopping/shop_all_page.dart';
import 'package:YLift/presentation/pages/desktop/individual_promotion/index.dart';
import 'package:YLift/presentation/pages/desktop/network_provider/index.dart';
import 'package:YLift/presentation/pages/desktop/onboarding/index.dart';
import 'package:YLift/presentation/pages/desktop/online_course/index.dart';
import 'package:YLift/presentation/pages/desktop/promotions/index.dart';
import 'package:YLift/presentation/pages/desktop/shop_page_non_medical/index.dart';
import 'package:YLift/presentation/pages/desktop/single_product/index.dart';
import 'package:YLift/presentation/pages/desktop/training_page/index.dart';
import 'package:YLift/presentation/pages/desktop/training_page/onetime_pay/index.dart';
import 'package:YLift/presentation/pages/desktop/training_page/register_training_page/index.dart';
import 'package:YLift/presentation/pages/desktop/user_profile/index.dart';
import 'package:YLift/presentation/pages/desktop/y_university/index.dart';
import 'package:YLift/presentation/pages/desktop/z-index_export.dart';
import 'package:YLift/presentation/pages/mobile/account/account_page.dart';
import 'package:YLift/presentation/pages/mobile/cart/mobile_order_confirmation_page.dart';
import 'package:YLift/presentation/pages/mobile/checkout/mobile_checkout_page.dart';
import 'package:YLift/presentation/pages/mobile/categories/components/filterable_products_page.dart';
import 'package:YLift/presentation/pages/mobile/courses/mobile_course_page.dart';
import 'package:YLift/presentation/pages/mobile/courses/mobile_online_course_page.dart';
import 'package:YLift/presentation/pages/mobile/onboarding/index.dart';
import 'package:YLift/presentation/pages/mobile/product/mobile_product_page.dart';
import 'package:YLift/presentation/pages/mobile/promotion/cart_promotion_page.dart';
import 'package:YLift/presentation/pages/mobile/promotion/index.dart';
import 'package:YLift/presentation/pages/mobile/shop_all/shop_all_page.dart';
import 'package:YLift/presentation/pages/mobile/training/index.dart';
import 'package:YLift/presentation/pages/mobile/training/training_detail_page/index.dart';
import 'package:YLift/presentation/pages/mobile/z-index_export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../presentation/pages/desktop/__primary_courses/online_courses.dart';

/// # Display Controller
/// Main controller for managing the display of the app
/// - Handles the display of the app based on the current screen
/// - Holds functions for switching between screens (no longer moved to virtual router)
/// - Manages the display of the search bar
/// - Manages the index changes for display settings
class DisplayController extends GetxController {
  final GlobalController global = Get.find<GlobalController>();

  // ******************************************************************
  //
  // Screen Elements management
  //
  // ******************************************************************

  // Layout getters
  Widget layoutMobile() => MobileScreen();

  // Screen getters - These maintain existing functionality
  Widget getCurrentMobileView() {
    return Column(
      children: [
        // if (global.searchBarEnable.value) ...[
        //   AnimatedSearchBar(isVisible: global.searchBarEnable.value),
        // ],
        Expanded(
          child: mobileContentScreen(),
        ),
      ],
    );
  }

  Widget mobileContentScreen() {
    // Placeholder that maintains existing screen routing logic
    // This can be refactored later to use virtualRouter
    switch (global.navigateMobileIndex.value) {
      case 0:
        return global.displayHomePage.value ? HomeScreen() : DynamicProductViewScreen();
      // case 1:
      //   return VideoScreen();
      case 3:
        return CartScreen();
      case 2 :
        return MobileCartPromotionPage();
      case 30:
        return MobilePromotionPage();
      // case 5:
      //   return ChatScreen();
      case 34:
        return MobileCoursePage();
      case 35:
        return MobileOnlineCoursePage();
      case 6:
        // return ProductScreen();
        return MobileProductPage();
      // case 7:
      //   return FullSearchResultsScreen(
      //     searchQuery: global.recentSearchQuery.value,
      //     searchResults: global.recentSearch.value,
      //   );
      case 7:
        return MobileTrainingPage();
      case 14:
        return TrainingPage();
      // case 9:
      //   return KnowYVideoDetailPage();
      case 17:
        return LoginPage();
      case 18:
        return MobileSignupPage();
      case 19:
        return const ForgotPasswordPage();
      case 20:
        return MobileOnboardingPage();
      case 13:
        return CheckPasscodePage();
      case 4:
        return MobileCheckoutPage();
      case 5:
        return MobileOrderConfirmationPage();
      case 24:
        return const CheckPasscodePage();
      case 9:
        return FilterableProductsPage();
      case 10:
        return const MobileAccountPage();
      case 50:
        return const MobileShopAllPage();
      default:
        return Container();
    }
  }

  Widget desktopBodyContentScreen() {
    final nonMedicalShop = global.isAuthenticated.value && global.user.value.medicalLicense == null;
    switch (global.navigateDesktopIndex.value) {
      case 0:
        if(nonMedicalShop) return ShopNonMedicalPage();
        return const ShopPage();
      case 1:
        // Video
        return const OnlineCoursesPage();
      case 2:
        // Profile Page
        return const UserProfilePage();
      case 3:
        // Cart
        return const CartPage();
      case 4:
        // Checkout
        return CheckoutPage();
      case 5:
        // Confirm
        return const OrderConfirmationPage();
      case 6:
        // Single Product Page View
        return const ProductPageView();
      case 7:
        // Training Page
        return const DesktopTrainingPage();
      case 8:
        if(nonMedicalShop) return ShopNonMedicalPage();
        return ShopPage();
      case 9:
        // Categories
        return DesktopDynamicGridPage(pageType: 'categories');
      case 10:
        // Brands
        return DesktopDynamicGridPage(pageType: 'brands');
      case 11:
        print("scheduled page reached");
        return ScheduleOrderConfirmationPage();
      // case 11:
      //   // Featured
      //   return Center(child: Text('Pending Create Featured Page'));
      case 14:
        return const NetworkProviderPage();
      case 15:
        return const YUniversityPage();
      case 16:
        return const DesktopDynamicGridPage(pageType: 'search');
      case 17:
        return const LoginPage();
      case 18:
        return const SignupPage();
      case 19:
        return const ForgotPasswordPage();
      case 20:
        return OnboardingPage();
      case 21:
        return const TwoFactorAuthentication();
      case 22:
        return const ResetPasswordPage();
      case 23:
        return Container();
      case 24:
        return const CheckPasscodePage();
      case 25:
        return TrainingPaymentPage();
      case 27:
        return const EmailVerificationPage();
      case 28:
        return Container();
      case 30:
        return const DesktopPromotionPage();
      case 31:
        return const IndividualPromotionPage();
      // case 32:
      //   return HandsOnTrainingPage();
      case 33:
        // developer route
        return OnlineCourses();
      case 34:
        return OnlineCourses();
      case 35:
        // return ViewVideoCourse();
        return const OnlineCoursePage();
        // return const ZoeTrainingVideoPage();
      case 40:
        return const RequireAddressPage(); //require_address
      case 41:
        return const RequireCardPaymentPage(); //require_card_payment
      case 50:
        return const ShopAllPage();
      case 51:
        return const ShopAllPage();
      case 70:
        return const RegisterTrainingPage();
      case 71:
        return const BootYLiftCoursePage();
      case 72:
        return const GeneralOnlineCoursesPage();
      case 98:
        return const LogoutPage();
      case 99:
        return const ErrorPage();
      default:
        return Container();
    }
  }

  // search products via mobile view
  Widget getSearchAppScreen() {
    switch (global.navigateQuickLinkIndex.value) {
      case 0:
        return DynamicProductViewScreen();
      case 1:
        return VideoScreen();
      default:
        return Container();
    }
  }

  Widget loadingBar() {
    return Obx(() {
      if (global.showLoadingBar.value) {
        return Container();
        // return const YLiftHorizontalProgressBar();
      } else {
        return Container();
      }
    });
  }

  List<int> navBarDesktopIndicesToExclude = [
    50, // shop all
    51, // all brands
    7, // Desktop training page
    17, // login
    18, // signup
    28, // account_created
    40, // require address
    41, // require card payment
    98, // logout
    34, // developer route
    35, // video preview
  ];

  // HIDE SUBNAVIGATION BAR
  RxBool showSubNavigationBar() {
    return (!navBarDesktopIndicesToExclude.contains(global.vroute.currentRouteIndex.value)).obs;
  }

  // ******************************************************************
  //
  // Data management
  //
  // ******************************************************************

  // Product display logic
  void setTappedProduct(ProductSimple product) {
    global.displayProduct.value = product;
    update();
  }

  // Private Helper methods for setting dynamic data
  void _setCategories() => global.dynamicProducts.addAll(global.categories.map((category) {
        return ProductSimple(
          name: category.name,
          imageUrl: category.imageUrl,
          productId: category.categoryId,
        );
      }));
  void _setBrands() => global.dynamicProducts.addAll(global.brands.map((brand) {
        return ProductSimple(
          name: brand.name,
          imageUrl: PLACEHOLDER_IMAGE,
          productId: brand.brandId,
        );
      }));
  void _setBestSellers() => global.dynamicProducts.addAll(global.bestSellerProducts);
  void _setNewArrivals() => global.dynamicProducts.addAll(global.newestProducts);
  void _setFeatured() => global.dynamicProducts.addAll(global.featuredProducts);

  // Future<void> _setProductsByCategories() async {
  //   global.dynamicProducts.value = await global.quick.fetchCategoryLinksById();
  // }

  // Set Dynamic data management
  void setDynamicData() {
    global.dynamicProducts.clear();
    switch (global.navigateQuickLinkIndex.value) {
      case 0:
        _setCategories();
        break;
      case 1:
        _setBrands();
        break;
      case 2:
        _setBestSellers();
        break;
      case 3:
        _setNewArrivals();
        break;
      case 4:
        _setFeatured();
        break;
      // case 5:
      //   _setProductsByCategories();
    }
    update();
  }

  // ******************************************************************
  //
  // Data management Ends
  //
  //
}