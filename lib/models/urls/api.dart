import 'package:YLift/core/constants/index.dart';

enum ApiUrl {
  base,
  //profile
  profiles,
  cards,
  userOrderHistory,

  getLikedProducts,

  updateUserProfile,
  getUserProfile,
  verifyEmail,

  setUserDefaultAddress,
  setUserDefaultCard,

  deleteCard,

  // addresses
  addresses,
  deleteAddress,
  recurrings,
  // carts
  cartItems,
  cartProfile,
  addToCart,
  toggleCartItem,
  deleteItem,
  clearCart,
  setCartAddress,
  setCartItemAddress,
  setCartItemShippingType,
  setSplitQuantity,
  getCartAddresses,
  getCardPayments,
  setCardPayment,
  addFreeItem,
  setPromotionRewardText,

  doCheckout,
  placeOrder,

  saveForLater,

  // cartEstimate,
  cartShipping, // requires estimate to be called first?
  // orders
  getOrdersClient,
  getSingleOrder,
  orderInfo,
  orderInfoZip,
  calculateTax,

  quickOrders,
  quickOrdersList,
  quickOrderReplaceCart,

  // products
  getProductsPublic,
  getProductsAuth,
  newest,
  getProductSkus,
  // getProductsByCategory,
  getProductsByCategoryLegacy,
  getAllProducts,
  getZeroPriceMessages,
  getVirtualProducts,
  getVideoData,
  deleteTradeGood,
  tradingGoodsProductsPricing,

  // Categories
  categories,
  getCategoryImage,

  brands,
  topics,
  skus,
  sku,
  similar,
  promotions,
  products,
  productsWithPrice,
  vendors,
  productsByBrand,

  // Authentication
  migrationVerifyPasscode,
  forgotPassword, // To send the reset password email
  resetPassword, // To reset the password
  sendEmailVerification, // To send the email verification

  recordDevice,

  // Onboarding
  onboarding,
  onboardingComplete,

  getSubcategories,

  /// ***********
  /// Trainings
  /// ***********
  networkProviderEnroll,
  trainingPayment,
  trainingVideos,
  trainingSubscription,


  // Media: Images and Videos
  getImage,
  getBannerImage,
  getProductImage,
  getVideo,
  signTrainingPDF,
  getTrainingPDF,
  postFeedbacks,
  storeCreditBalance,

  // schedule orders

  scheduleOrder;


  String get path {
    switch (this) {
      case ApiUrl.base:
        return API_WEB_LINK;
      case ApiUrl.getProductsPublic:
        return 'public/general/products';
      case ApiUrl.getProductsAuth:
        return 'public/auth/products';
      case ApiUrl.getZeroPriceMessages:
        return 'public/zero/value/products';
      case ApiUrl.newest:
        return ''; // to avoid cascading // TODO replace with real endpoint (newest)
      case ApiUrl.promotions:
        return 'promotions'; // to avoid cascading
      case ApiUrl.categories:
        return 'public/categories'; // to avoid cascading
      case ApiUrl.getCategoryImage:
        return 'media/api/optimized/variant/image/file';
      case ApiUrl.topics:
        return ''; // to avoid cascading // TODO replace with real endpoint (training topics)
      case ApiUrl.brands:
        return 'brands'; // Changed for phantom
      case ApiUrl.addresses:
      case ApiUrl.deleteAddress:
        return 'address';
      case ApiUrl.getOrdersClient:
        return 'orders/client';
      case ApiUrl.getSingleOrder:
        return 'orders/single';
      case ApiUrl.cartItems:
        return 'cart/items';
      case ApiUrl.toggleCartItem:
        return 'cart/item/toggle';
      case ApiUrl.addToCart:
        return 'cart/items';
      case ApiUrl.deleteItem:
        return 'cart/items/delete';
      case ApiUrl.clearCart:
        return 'cart/clear';
      case ApiUrl.setCartAddress:
        return 'cart/shipping/address';
      case ApiUrl.setCartItemAddress:
        return 'cart/item/custom/shipping/address';
      case ApiUrl.setCartItemShippingType:
        return 'cart/item/shipping/settings';
      case ApiUrl.setSplitQuantity:
        return 'cart/item/quantity/split';
      case ApiUrl.getCartAddresses:
        return 'cart/profile/address';
      case ApiUrl.getCardPayments:
        return 'cart/billing/cards';
      case ApiUrl.setCardPayment:
        return 'cart/billing/card';
      case ApiUrl.doCheckout:
        return 'cart/payment';
      case ApiUrl.placeOrder:
        return 'cart/place/order';
      case ApiUrl.cartShipping:
        return 'cart/item/shipping/settings';
      case ApiUrl.products:
        return 'public/general/products';
      case ApiUrl.getSubcategories:
        return 'public/subcategories';
      case ApiUrl.productsWithPrice:
        return 'public/auth/products';
      case ApiUrl.productsByBrand:
        return 'public/products/by/brand';
      case ApiUrl.userOrderHistory:
        return 'profiles/order/history';
      case ApiUrl.onboarding:
        return 'user/accounts/onboard/user';
      case ApiUrl.onboardingComplete:
        return 'user/accounts/onboard/user/complete';
      case ApiUrl.migrationVerifyPasscode:
        return 'user/migration/verify/passcode';
      case ApiUrl.forgotPassword:
        return 'user/accounts/user/forgot/password';
      case ApiUrl.resetPassword:
        return 'user/accounts/user/reset/password';
      case ApiUrl.getUserProfile:
        return 'profiles/fresh';
      case ApiUrl.networkProviderEnroll:
        return 'trainings/signup/form';
      case ApiUrl.trainingPayment:
        return 'trainings/Payment';
      case ApiUrl.trainingVideos:
        return 'profiles/training/videos';
      case ApiUrl.trainingSubscription:
        return 'profiles/training/subscriptions';
      case ApiUrl.getImage:
        return 'media/api/optimized/variant/image/banners/file';
      case ApiUrl.getProductImage:
        return 'media/api/mapping/image';
      case ApiUrl.getVideo:
        return 'media/api/optimized/variant/video/file';
      case ApiUrl.getProductSkus:
        return 'public/product/skus';
    // case ApiUrl.getProductsByCategory:
    //   return 'public/separate/categories/products';
      case ApiUrl.getProductsByCategoryLegacy:
        return 'public/categories/products';
      case ApiUrl.quickOrders:
        return 'orders/reorder/quick';
      case ApiUrl.quickOrdersList:
        return 'orders/quick/reorder/list';
      case ApiUrl.quickOrderReplaceCart:
        return 'orders/replace/cart';
      case ApiUrl.getLikedProducts:
        return 'profiles/liked/products';
      case ApiUrl.updateUserProfile:
        return 'profiles/update/profile';
      case ApiUrl.saveForLater:
        return 'cart/item/save/for/later';
      case ApiUrl.setUserDefaultAddress:
        return 'address/setDefault';
      case ApiUrl.setUserDefaultCard:
        return 'profiles/credit/cards/set/default';
      case ApiUrl.deleteCard:
        return 'profiles/credit/cards';
      case ApiUrl.getAllProducts:
        return 'public/products/all';
      case ApiUrl.skus:
      case ApiUrl.sku:
      case ApiUrl.vendors:
        return 'vendors';
      case ApiUrl.similar:
      case ApiUrl.orderInfoZip:
      case ApiUrl.recurrings:
      case ApiUrl.orderInfo:
      case ApiUrl.profiles:
      case ApiUrl.cards:
      case ApiUrl.cartProfile:
        return '';
      case ApiUrl.getTrainingPDF:
        return 'profiles/provider/pdf';
      case ApiUrl.signTrainingPDF:
        return 'profiles/provider/needs/to/sign';
      case ApiUrl.addFreeItem:
        return 'cart/items/free';
      case ApiUrl.calculateTax:
        return 'orders/calculate/tax';
      case ApiUrl.getBannerImage:
        return 'media/api/optimized/variant/image/banners/file';
      case ApiUrl.setPromotionRewardText:
        return 'cart/promotion/selection';
      case ApiUrl.recordDevice:
        return 'profiles/user/experience';
      case ApiUrl.verifyEmail:
        return 'user/accounts/email/verify';
      case ApiUrl.sendEmailVerification:
        return 'user/accounts/confirm/email';
      case ApiUrl.getVirtualProducts:
        return 'virtual/products/';
      case ApiUrl.deleteTradeGood:
        return 'virtual/goods/trading/remove/trading/item';
      case ApiUrl.tradingGoodsProductsPricing:
        return 'cart/give/tally/of/items';
      case ApiUrl.getVideoData:
        return 'virtual/products/video';
      case ApiUrl.postFeedbacks:
        return 'user/feedback/submit';
      case ApiUrl.storeCreditBalance:
        return 'orders/store/credit/balance';
      case ApiUrl.scheduleOrder:
        return 'orders/scheduled';
    }
  }

  String withId(String id) {
    if (this == ApiUrl.addresses) {
      return 'address?profileId=$id'; // GET, POST
    }
    if (this == ApiUrl.deleteAddress) {
      return 'address?addressId=$id';
    }
    if (this == ApiUrl.brands) {
      // return 'products/search?brands=$id&limit=50&offset=0'; // GET
      return 'brands/$id';
    }
    if (this == ApiUrl.products) {
      return 'public/products/$id';
    }
    if (this == ApiUrl.getProductsAuth) {
      return 'public/auth/$id';
    }
    if (this == ApiUrl.productsByBrand) {
      return 'public/products/by/brand/$id';
    }
    if (this == ApiUrl.vendors) {
      return 'vendors/$id';
    }
    if (this == ApiUrl.clearCart) {
      return 'cart/items/clear/$id';
    }
    if (this == ApiUrl.cartItems) {
      return 'cart/items?profileId=$id';
    }
    if (this == ApiUrl.getImage) {
      return 'media/api/image/$id';
    }
    return path;
  }

  String withQuery(Map<String, String> params) {
    final queryString = params.entries.map((e) => '${e.key}=${e.value}').join('&');
    return '$path?$queryString';
  }

  String withIdAndQuery(String id, Map<String, String> params) {
    final baseUrl = withId(id);
    final queryString = params.entries.map((e) => '${e.key}=${e.value}').join('&');
    return queryString.isNotEmpty ? '$baseUrl?$queryString' : baseUrl;
  }
}