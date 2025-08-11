import 'dart:developer';

import 'package:YLift/core/constants/index.dart';
import 'package:YLift/core/controllers/carts/cart_validator.dart';
import 'package:YLift/core/controllers/z-index_export.dart';
import 'package:YLift/core/services/bearer.dart';
import 'package:YLift/hardcodes/promotions/summer_glow_july_15/summer_glow_promotion.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:YLift/presentation/pages/desktop/cart/components/merz_promotion_dialog.dart';
import 'package:dio/dio.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:get/get.dart';

class LastMinuteItem {
  /// [productId] in here should be 'productId-skuId'
  final String productId;
  final int quantity;

  LastMinuteItem(this.productId, this.quantity) : assert(productId.contains('-'));

  Map<String, dynamic> toJson() {
    return {
      'product': productId,
      'quantity': quantity,
    };
  }
}

/// # CartController
///
class CartController extends GetxController {
  final GlobalController global = Get.find<GlobalController>();

  // ******************************************************************* >
  // *                         CART FUNCTIONS                          *
  // ******************************************************************* >

  Future<void> addToCart({
    required String customerId,
    required int quantity,
    required String product,
    List<LastMinuteItem>? lastMinuteItems,
  }) async {
    try {
      final body = <String, dynamic>{
        'profileId': customerId,
        'quantity': quantity,
        'product': product,
        if (lastMinuteItems != null) 'lastMinuteItems': lastMinuteItems.map((item) => item.toJson()).toList(),
      };
      final apiOptions = Options(validateStatus: (status) => true);
      final response = await global.api.postData(
        ApiUrl.addToCart.path,
        body,
        options: apiOptions,
      );
      print('Phantom Response addToCart : ${response.message}');
      if (!response.isSuccess) {
        throw '${response.message}';
      }
      final rCart = response.data?['cart'] as Map<String, dynamic>?;
      if (rCart != null) {
        // final cartError = CartValidator.validateCartItem(rCart);
        // if (cartError != null) throw cartError;
        final cart = CartSimple.fromJson(rCart);
        global.simpleCart.value = cart;
        global.simpleCart.refresh();
        global.update();
      } else {
        throw 'Please, try again';
      }
    } on CartItemError catch (e) {
      await deleteCartItem(profileId: customerId, productId: e.productId);
      rethrow;
    }
  }

  Future<void> addFreeItem({
    required String product,
    required int quantity,
  }) async {
    final body = <String, dynamic>{
      'product': product,
      'quantity': quantity,
    };
    final response = await global.api.postData(ApiUrl.addFreeItem.path, body);
    print('Phantom Response addFreeItem : ${response.message}');
    if (response.isFailed) {
      throw '${response.message}';
    }
    global.simpleCart.value = CartSimple.fromJson(
      response.data!['cart'] as Map<String, dynamic>,
    );
    global.simpleCart.refresh();
    global.update();
    print('Free item has been added');
  }

  Future<void> clearCart({required String profileId}) async {
    // PhantomResponse response = await global.api.deleteData('${ApiUrl.clearCart.path}/$profileId');
    PhantomResponse response = await global.api.deleteData(
      '${ApiUrl.clearCart.path}/0',
    );
    print('Phantom Response clearCart : ${response.message}');
    if (response.isSuccess) {
      print('Cart has been cleared');
      global.simpleCart.value = CartSimple.fromJson(response.data?['cart']);
      global.simpleCart.value.tradeGoods = <StoreTradeGood>[];
      global.simpleCart.value.virtualItems = <VirtualItem>[];
      global.simpleCart.value.resetCartBillableToZero();
      global.simpleCart.refresh();
      global.update();
    } else {
      throw Exception(response.message);
    }
  }

  Future<OrderSimple> createOrder({
    required String cardId,
  }) async {
    log('Placing an order with cardId: $cardId');
    final profileId = global.user.value.profileId;
    final queryParams = <String, String>{
      'profileId': '$profileId',
      'cardId': cardId,
    };
    final paymentHistory = global.simpleCart.value.paymentHistory;
    if (paymentHistory?.any((history) => history.cardId == cardId && history.paymentStatus == 'PENDING') ?? false) {
      queryParams.remove('cardId');
    }


    // if (SummerGlowPromotion.isEligibleForVEFDiffuser) {
    //   await setNote(title: 'galderma', text: 'Venus et Fleur');
    //   log('User is eligible for Venus et Fleur Diffuser');
    // } else {
    //   final notes = global.simpleCart.value.notes;
    //   if(notes?.any((note) => note.text.contains('Venus et Fleur')) ?? false){
    //     await setNote(title: 'galderma', text: '');
    //     log('Venus et Fleur Diffuser note has been removed');
    //   }
    // }

    final response = await global.api.putData(ApiUrl.placeOrder.withQuery(queryParams), <String, dynamic>{});
    if (response.isSuccess) {
      final rOrder = response.data?['cart'];
      final order = OrderSimple.fromJson(rOrder);

      log('Order has beed made successfully (${order.orderId})');

      await global.blowOutCarts();
      log('Cart has been cleared');

      await global.auth.performRefreshToken();
      log('User token has been refreshed');

      return order;
    } else {
      final notes = global.simpleCart.value.notes;
      // if(notes?.any((note) => note.text.contains('Venus et Fleur')) ?? false){
      //   await setNote(title: 'galderma', text: '');
      //   log('Venus et Fleur Diffuser note has been removed');
     // }
      log('Placing an order failed: ${response.message}');
      throw response.message;
    }
  }

  Future<void> deleteCartItem({
    required String profileId,
    required String productId,
  }) async {
    if (profileId == '0') {
      throw Exception('Profile ID cannot be set to 0');
    }
    final queryParameters = <String, String>{
      'profileId': profileId,
      'product': productId,
    };
    PhantomResponse response = await global.api.deleteData(
      ApiUrl.cartItems.withQuery(queryParameters),
    );
    print('Phantom Response deleteItem : ${response.message}');
    if (response.isSuccess) {
      global.simpleCart.value = CartSimple.fromJson(
        response.data!['cart'] as Map<String, dynamic>,
      );
      final skuId = productId.split('-').last;
      final isMerz = skuId == '2022' || skuId == '2024';
      if (isMerz) await clearMerzFreeItems();
      // if(global.galdermaController.galdermaItems.isNotEmpty){
      //   global.galdermaController.setReward('');
      // }

      print(
        'Item with sku $skuId has been removed from profile $profileId cart',
      );
    } else {
      global.simpleCart.value = CartSimple.fromJson(
        response.data!['cart'] as Map<String, dynamic>,
      );
      print('failed to remove sku $productId');
    }
    global.simpleCart.refresh();
    global.update();
  }

  Future<CartSimple> refreshCart() async {
    PhantomResponse response = await global.api.getData(
      ApiUrl.cartItems.withId('${global.user.value.profileId}'),
    );
    print('Phantom Response refreshCart : ${response.message}');
    if (response.isSuccess) {
      if (response.data?['cart'] != null) {
        global.simpleCart.value = CartSimple.fromJson(
          response.data!['cart'] as Map<String, dynamic>,
        );
      }
      global.simpleCart.refresh();
      global.update();
      return global.simpleCart.value;
    } else {
      throw Exception(response.message);
    }
  }

  Future<void> setCartItemAddress({
    required int profileId,
    required String addressId,
    required String skuId,
  }) async {
    final queryParams = <String, String>{
      'profileId': '$profileId',
      'addressId': addressId,
      'skuId': skuId,
    };
    final response = await global.api.put(
      ApiUrl.setCartItemAddress.withQuery(queryParams),
      <String, dynamic>{},
    );
    print('Phantom Response setCartItemAddress : ${response.data}');
    if (response.statusCode! == 200) {
      global.simpleCart.value = CartSimple.fromJson(
        response.data!['cart'] as Map<String, dynamic>,
      );
      global.simpleCart.refresh();
      global.update();
    } else {
      throw Exception(response.data);
    }
  }

  Future<void> setCartAddress({
    required String profileId,
    required String addressId,
  }) async {
    if (profileId == '0' || addressId == '0') {
      throw Exception('Profile ID cannot be set to 0, nor can Address');
    }
    final queryParams = <String, String>{
      'profileId': profileId,
      'addressId': addressId,
    };
    PhantomResponse response = await global.api.putData(
      ApiUrl.setCartAddress.withQuery(queryParams),
      <String, dynamic>{},
    );
    print('Phantom Response setCartAddress : ${response.message}');
    if (response.isSuccess) {
      global.simpleCart.value = CartSimple.fromJson(
        response.data!['cart'] as Map<String, dynamic>,
      );
      global.simpleCart.refresh();
      global.update();
    } else {
      throw Exception(response.message);
    }
  }

  Future<void> setCartShippingType({
    required String profileId,
    required String skuId,
    required ShippingType type,
  }) async {
    final queryParams = <String, String>{
      'profileId': profileId,
      'skuId': skuId,
      'shippingType': type.name.toUpperCase(),
    };
    PhantomResponse response = await global.api.putData(
      ApiUrl.setCartItemShippingType.withQuery(queryParams),
      <String, dynamic>{},
    );
    print('Phantom Response setCartShippingType : ${response.message}');
    if (response.isSuccess) {
      global.simpleCart.value = CartSimple.fromJson(
        response.data!['cart'] as Map<String, dynamic>,
      );
      global.simpleCart.refresh();
      global.update();
    } else {
      throw Exception(response.message);
    }
  }

  Future<void> toggleCheckOut({
    required String profileId,
    required String skuId,
    required bool isChecked,
  }) async {
    if (profileId == '0') {
      throw Exception('Profile ID cannot be set to 0');
    }
    final queryParameters = <String, String>{
      'profileId': profileId,
      'skuId': skuId,
      'isChecked': isChecked.toString(),
    };
    PhantomResponse response = await global.api.putData(
      ApiUrl.toggleCartItem.withQuery(queryParameters),
      <String, dynamic>{},
    );
    print('Phantom Response toggleCheckOut : ${response.message}');
    if (response.isSuccess) {
      global.simpleCart.value = CartSimple.fromJson(
        response.data!['cart'] as Map<String, dynamic>,
      );
      global.simpleCart.refresh();
      global.update();
      print(response.message);
    } else {
      throw Exception(response.message);
    }
  }

  Future<void> updateCartItemQuantity({
    required String profileId,
    required int quantity,
    required String product,
  }) async {
    if (profileId == '0') {
      throw Exception('Profile ID cannot be set to 0');
    }
    final queryParams = <String, String>{
      'profileId': profileId,
      'product': product,
      'quantity': '$quantity',
    };
    PhantomResponse response = await global.api.putData(
      ApiUrl.cartItems.withQuery(queryParams),
      <String, dynamic>{},
    );
    print('Phantom Response updateCartItemQuantity : ${response.message}');
    if (response.isSuccess) {
      global.simpleCart.value = CartSimple.fromJson(response.data?['cart']);
      global.simpleCart.refresh();
      global.update();

      final skuId = product.split('-').last; // Extracting SKU ID from product
      final isMerz = skuId == '2022' || skuId == '2024';
      final merzPromotion = MerzSyringePromotion.getPromotion(quantity);
      final isOverLimit = global.simpleCart.value.merzTotalFreeQuantity > (merzPromotion?.freeSyringes ?? 0);
      if (isMerz && isOverLimit) {
        await clearMerzFreeItems();
      }
      // if(global.galdermaController.galdermaItems.isNotEmpty){
      //   global.galdermaController.setReward('');
      // }
    } else {
      throw Exception(response.message);
    }
  }

  Future<void> clearMerzFreeItems() async {
    await addFreeItem(product: '449-2022', quantity: 0); // Radiesse (+) 1.5 mL
    await addFreeItem(product: '450-2024', quantity: 0); // Radiesse 1.5 mL
  }

  Future<void> quickReorderAddToCart({
    required String orderId,
  }) async {
    PhantomResponse response = await global.api.putData(
      ApiUrl.quickOrderReplaceCart.path,
      {'orderId': orderId},
    );
    print('Phantom Response quickReorderAddToCart : ${response.message}');
    if (response.isSuccess) {
      try {
        // await global.basket.getCartSimple();
        final cart = CartSimple.fromJson(response.data!['cart']);
        global.simpleCart.value = cart;
        global.simpleCart.refresh();
        global.update();
        await global.vroute.navigateTo('/order/cart');
      } catch (e, s) {
        print('$e\n$s');
      }
    }
    // setState(() {
    //   _errorMessage = 'Failed to add to cart: ${response.message}';
    // });
  }

  Future<void> removeTradeGood(String tradeGoodId) async {
    final profileId = global.user.value.profileId;
    // final queryParams = <String, String>{
    //   'profileId': '$profileId',
    //   'goodsMappingId': tradeGoodId,
    // };
    final queryParameters = <String, String>{
      'product': tradeGoodId,
    };
    // PhantomResponse response = await global.api.deleteData(ApiUrl.cartItems.withQuery(queryParameters));
    final response = await global.api.deleteData(
      ApiUrl.cartItems.withQuery(queryParameters),
    );
    if (response.isSuccess) {
      print('Trade good deleted successfully ${response.data}');
      final cart = CartSimple.fromJson(response.data!['cart']);
      global.simpleCart.value = cart;
      global.simpleCart.refresh();
      global.update();
    } else {
      print('Failed to remove trade good: ${response.message}');
    }
  }

  Future<void> addVirtualItemToCart({
    required String virtualProductId,
    required List<LastMinuteItem> lastMinuteItems,
  }) async {
    final profileId = '${global.user.value.profileId}';
    final body = <String, dynamic>{
      'profileId': profileId,
      'product': virtualProductId,
      'bundledProducts': lastMinuteItems.map((e) => e.toJson()).toList(),
    };
    final apiOptions = Options(validateStatus: (status) => true);
    PhantomResponse response = await global.api.postData(
      ApiUrl.addToCart.path,
      body,
      options: apiOptions,
    );
    print('Phantom Response addToCart : ${response.message}');
    if (!response.isSuccess) {
      throw '${response.message}';
    }
    if (response.data!['cart'] != null) {
      global.simpleCart.value = CartSimple.fromJson(
        response.data!['cart'] as Map<String, dynamic>,
      );
      global.simpleCart.refresh();
      global.update();
    } else
      throw 'Please, try again';
  }

  Future<void> setNote({required String title, required String text}) async {
    final orderId = global.simpleCart.value.orderId;
    try {
      final queryParameters = <String, String>{
        'orderId': orderId!,
        'promotionTitle': title,
        'promotionText': text,
      };
      final url = ApiUrl.setPromotionRewardText.withQuery(queryParameters);
      await global.api.putData(url, {});
    } catch (e) {
      log('Failed to set note (title: $title, text: $text) to order $orderId');
    }
  }

  // ******************************************************************* >
  // *                       CART FUNCTIONS (needs to be checked)      *
  // ******************************************************************* >

  /// determine whether the cart should show additional addresses or not
  RxBool hasAdditionalAddresses = false.obs;
  Future<void> showAdditionalAddresses() async {
    final List<CartItemSimple> cartItems = global.simpleCart.value.cartItems;

    for (CartItemSimple cartItem in cartItems) {
      if (cartItem.shippingAddress != null) {
        hasAdditionalAddresses.value = true;
        return;
      }
    }
    hasAdditionalAddresses.value = false;
  }

  Future<List<AddressSimple>?> getAddresses({required String profileId}) async {
    if (profileId == '0') {
      throw Exception('Profile ID cannot be set to 0');
    }
    final queryParams = <String, String>{'profileId': profileId};
    final url = Uri.parse(ApiUrl.getCartAddresses.withQuery(queryParams));

    final dio = Dio();
    final response = await dio.getUri(url);
    if (response.statusCode == 200) {
      final addresses = AddressSimple.fromList(response.data['addresses']);
      return addresses;
    } else {
      return null;
    }
  }

  Future<void> setCartItemSplitQuantity({
    required String profileId,
    required String skuId,
    required List<Map<String, dynamic>> data,
  }) async {
    if (profileId == '0') {
      throw Exception('Profile ID cannot be set to 0');
    }
    final queryParams = <String, String>{
      'profileId': profileId,
      'skuId': skuId,
    };

    final dio = Dio();
    dio.interceptors.add(BearerTokenInterceptor());

    final response = await dio.put(
      '$API_WEB_LINK/${ApiUrl.setSplitQuantity.withQuery(queryParams)}',
      data: data,
    );
    // final response = await global.api.put(ApiUrl.setSplitQuantity.withQuery(queryParams), data);
    //final statusCode = response.statusCode ?? 0;

    final isSuccess = response.data['message'].contains('success');
    // if (statusCode >= 200 || statusCode < 300) {
    if (isSuccess) {
      final rCart = response.data['cart'] as Map<String, dynamic>;
      final cart = CartSimple.fromJson(rCart);

      global.simpleCart.value = cart;
      // print('SKU $skuId has been split');
    } else {
      throw Exception(response.data);
    }
  }

  Future<void> cancelSplit({
    required String profileId,
    required String skuId,
  }) async {
    if (profileId == '0') {
      throw Exception('Profile ID cannot be set to 0');
    }
    final queryParams = <String, String>{
      'profileId': profileId,
      'skuId': skuId,
    };

    final dio = Dio();
    dio.interceptors.add(BearerTokenInterceptor());

    final response = await dio.put(
      '$API_WEB_LINK/${ApiUrl.setSplitQuantity.withQuery(queryParams)}',
      data: [{}],
    );
    final isSuccess = response.data['message'].contains('success');
    // if (statusCode >= 200 || statusCode < 300) {
    if (isSuccess) {
      final rCart = response.data['cart'] as Map<String, dynamic>;
      final cart = CartSimple.fromJson(rCart);

      global.simpleCart.value = cart;
      // print('SKU $skuId has been split');
    } else {
      throw Exception(response.data);
    }
  }

  Future<List<CardPayment>> getCardPayments({required String profileId}) async {
    if (profileId == '0') {
      throw Exception('Profile ID cannot be set to 0');
    }
    global.showLoadingBar.value = true;
    final queryParams = <String, String>{'profileId': profileId};
    final response = await global.api.get(
      ApiUrl.getCardPayments.withQuery(queryParams),
    );
    final statusCode = response.statusCode ?? 0;

    if (statusCode >= 200 && statusCode < 300) {
      final data = response.data as Map<String, dynamic>;
      final message = data['message'] as String?;
      if (message?.toLowerCase().contains('failed') ?? false) throw Exception(message);
      final cards = CardPayment.fromList(data['cards']);
      global.showLoadingBar.value = false;
      return cards;
    } else {
      global.showLoadingBar.value = false;
      throw Exception(response.data);
    }
  }

  Future<void> setCardPayment({
    required String profileId,
    required String cardId,
  }) async {
    if (profileId == '0') {
      throw Exception('Profile ID cannot be set to 0');
    }
    final queryParams = <String, String>{
      'profileId': profileId,
      'cardId': cardId,
    };

    final response = await global.api.put(
      ApiUrl.setCardPayment.withQuery(queryParams),
      <String, dynamic>{},
    );
    final statusCode = response.statusCode ?? 0;
    if (statusCode >= 200 && statusCode < 300) {
      if (response.data['cart'] == null)
        throw Exception(
          'Failed to add cart, please move cart to checkout first',
        );
      print('adding card successful');
    } else {
      throw Exception(response.data);
    }
  }

  /// # We get the details for a single item thats in the cart
  /// - singleItem: the item we want to get the details for
  /// - returns: the details for the item
  /// - throws: an exception if the request fails
  ///
  Future<CartItems> getSingleCartItem(CartItems singleItem) async {
    late CartItems item = CartItems();

    /// sku info
    if (item.sku == null) {
      throw Exception('Failed to getSingleCartItem due to failure of sku info');
    }

    /// product info
    // item.product = await global.products.getProduct(item.sku!.productId);

    /// -vendor info
    item.vendor = await global.products.getVendor(item.product!.vendorId ?? -1);

    item.quantity = singleItem.quantity; // quantity of the item (ie. 8 bananas)
    item.cartItemId = singleItem.cartItemId; // id of the item in the cartItems table
    return item;
  }

  Future<List<ShoppingItemsByBrands>> getShopItems(
    List<CartItems> items,
    CartInfo info,
  ) async {
    List<ShoppingItemsByBrands> cartItems = [];
    for (CartItems item in items) {
      ShoppingItem shopItem = ShoppingItem(
        productName: item.product!.name,
        // productId: item.product!.productId,
        quantity: item.quantity,
        price: item.sku!.price,
        sku: item.sku!.id.toString(),
        description: item.product!.caption,
        // units: item.sku!.skuProductAttributeDescriptions!.first.units,
        // gauge: item.sku!.skuProductAttributeDescriptions!.first.gauge,
        step: new Quantities(
          min: item.sku!.quantityMin,
          max: item.sku!.quantityMax,
          increment: item.sku!.quantityIncrement,
          current: item.quantity,
        ),
        cartItemId: item.cartItemId,
      );

      // check if the brand exists
      ShoppingItemsByBrands? brand = cartItems.firstWhere(
        (element) => element.brandName == item.vendor!.name,
        orElse:
            () => ShoppingItemsByBrands(
              productId: item.sku!.productId,
              brandName: item.vendor!.name,
              skuId: item.sku?.id,
            ),
      );

      brand.items ??= [];
      brand.vendorRules = false;
      brand.vendorOrderMissingTotal = 0;
      brand.updatingQuantity = false;
      if (info.vendorOrderDifferenceTotalByVendorId != null) {
        if (info.vendorOrderDifferenceTotalByVendorId!.containsKey(
          item.vendor!.id.toString(),
        )) {
          brand.vendorOrderMissingTotal = info.vendorOrderDifferenceTotalByVendorId![item.vendor!.id.toString()];
          brand.vendorRules = true;
        }
      }

      brand.vendorId = item.vendor!.vendorId;
      brand.items!.add(shopItem);

      if (!cartItems.contains(brand)) {
        cartItems.add(brand);
      } else {
        cartItems.remove(brand);
        cartItems.add(brand);
      }
    }
    return cartItems;
  }

  Future<CartInfo> getOrderInfo() async {
    try {
      final response = await global.api.get(ApiUrl.orderInfo.path);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonMap = response.data;
        CartInfo info = CartInfo.fromJson(jsonMap);
        return info;
      } else {
        throw Exception(
          'Failed to load cart info, status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print("Error occurred: $e");
      throw Exception('Failed to load cart info: $e');
    }
  }

  Future<List<CardInformation>> getCards() async {
    try {
      final response = await global.api.get(ApiUrl.cards.path);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonMap = response.data;
        List<dynamic> jsonList = jsonMap['rows'];
        List<CardInformation> cards = jsonList.map((json) => CardInformation.fromJson(json)).toList();
        return cards;
      } else {
        throw Exception(
          'Failed to load card info, status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print("Error occurred: $e");
      throw Exception('Failed to load card info: $e');
    }
  }

  Future<List<ShippingSettings>> handleAddressSelection(
    String addressId,
  ) async {
    var shippingSettings = <ShippingSettings>[];

    try {
      var selectedAddress = global.profile.value.addresses!.firstWhere(
        (element) => element.id == int.parse(addressId),
      );

      global.cart.value.checkout?.address = selectedAddress;

      CartInfo info = await global.api.get(ApiUrl.orderInfoZip.withId(selectedAddress.zip)).then((value) {
        Map<String, dynamic> jsonMap = value.data;
        return CartInfo.fromJson(jsonMap);
      });

      // Update the cart info and tax outside of setState
      global.cart.value.info = info;
      global.cart.value.checkout?.tax = global.cart.value.info!.taxTotal;
      global.cart.value.checkout?.subtotal = global.cart.value.info!.subtotal;
    } on Exception catch (e) {
      throw ('Error in cart/store_password_field.dart:_handleAddressSelection: $e');
    }

    try {
      final response = await global.api.get(ApiUrl.cartShipping.path);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonMap = response.data;
        final cartItemsResponse = CartItemsResponse.fromJson(jsonMap);

        List<dynamic> productShippingSettingsData = jsonMap['productShippingSettings'];
        List<ProductShippingSettings> productShippingSettings =
            productShippingSettingsData.map((item) => ProductShippingSettings.fromJson(item)).toList();
        List<dynamic> vendorShippingSettingsData = jsonMap['vendorShippingSettings'];
        List<VendorShippingSettings> vendorShippingSettings =
            vendorShippingSettingsData.map((item) => VendorShippingSettings.fromJson(item)).toList();

        global.cart.value.productShippingSettings = productShippingSettings;
        global.cart.value.vendorShippingSettings = vendorShippingSettings;

        shippingSettings = ShippingSettingsConverter.convertAll(
          productShippingSettings,
          vendorShippingSettings,
          cartItemsResponse.cartItemsByProduct,
          cartItemsResponse.cartItemsByVendor,
        );
        global.cart.value.checkout!.shippingInfo = shippingSettings;
        return shippingSettings;
      }
      return shippingSettings;
    } catch (e) {
      print('Error fetching shipping settings: $e');
      // Handle the error appropriately (e.g., show an error message to the user)
      return shippingSettings;
    }
  }

  Future<int> getShippingRate(
    List<ShippingSettings> shippingSettings,
    int shippingRate,
  ) async {
    for (var shipping in shippingSettings) {
      if (shipping.isFlatRate == true && shipping.selectedRate == 0) {
        shipping.selectedRate = shipping.regularRate;

        if (shippingRate == 0) {
          shippingRate = shipping.regularRate;
        } else {
          shippingRate += shipping.regularRate;
        }
      }
    }

    return shippingRate;
  }

  Future<void> handleShipmentSelection(String title, int currentIndex) async {
    var currentShippingInfo = global.cart.value.checkout!.shippingInfo[currentIndex];
    if (currentShippingInfo.isFlatRate) return;

    int newRate;
    // Update the selected option for the current shipping info
    switch (title) {
      case 'Regular Ground':
        newRate = currentShippingInfo.regularRate;
        break;
      case 'Express 2 Days':
        newRate = currentShippingInfo.expressRate;
        break;
      case 'Overnight':
        newRate = currentShippingInfo.overnightRate;
        break;
      default:
        return; // If the title doesn't match any option, do nothing
    }

    // Update the selected rate for the current shipping info
    currentShippingInfo.selectedRate = newRate;

    // Recalculate the total shipping cost
    int totalShipping = 0;
    for (var shippingInfo in global.cart.value.checkout!.shippingInfo) {
      totalShipping += shippingInfo.selectedRate * shippingInfo.boxes!;
    }

    // Update the total shipping cost in the checkout
    global.cart.value.checkout!.shipping = totalShipping;
    print(
      'Shipping cost has been updated to \$${global.cart.value.checkout!.shipping! / 100}',
    );
  }

  Future<int> calculateTax({
    required int addressId,
    required int amount,
  }) async {
    final data = <String, dynamic>{
      'addressId': addressId,
      'amount': amount,
    };
    final response = await global.api.postData(ApiUrl.calculateTax.path, data);
    if (response.isSuccess) {
      final json = response.data as Map<String, dynamic>;
      log(json.toString());
      final taxAmount = json['tax'] as int; // The returned tax amount is in dollars
      return taxAmount * 100; // So we convert it to cents
    } else {
      print(response.data);
      throw Exception(
        'Failed to calculate tax, status code: ${response.statusCode}',
      );
    }
  }
}
