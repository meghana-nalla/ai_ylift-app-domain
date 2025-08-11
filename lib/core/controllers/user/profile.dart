import 'dart:convert';

import 'package:get/get.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'dart:typed_data';

/// controller for managing user profile actions
class UserProfileController extends GetxController {
  final GlobalController global = Get.find<GlobalController>();

  Future<Uint8List> getTrainingPDF() async {
    final response = await global.api.getPdf(ApiUrl.getTrainingPDF.path);
    return response.data as Uint8List;
  }

  /// utilities
  Future<PhantomResponse> fetchProfile() async {
    final PhantomResponse response = await global.api.getData(
      ApiUrl.getUserProfile.path,
    );
    if (response.statusCode == 200) {
      final profileData = response.data!['profile'] as Map<String, dynamic>;
      global.user.value = AuthProfileUser.fromJson(profileData);
      global.refresh();
      return response;
    } else {
      return response;
    }
  }

  // public facing method to return the user's list of liked products
  Future<List<ProductSimple>> updateLikedProducts() async {
    if (!global.isAuthenticated.value) {
      return [];
    }
    try {
      // Get or fetch liked product IDs
      if (global.user.value.likedProducts != null &&
          global.user.value.likedProducts!.isNotEmpty) {
        Set<int> unmatchedIds = Set<int>.from(global.user.value.likedProducts!);
        List<ProductSimple> likedProducts = [];

        if (global.allProducts.value.products.isNotEmpty) {
          for (int id in global.user.value.likedProducts!) {
            ProductSimple? product = global.allProducts.value.products
                .firstWhereOrNull((e) => e.productId! == id);
            if (product != null) {
              likedProducts.add(product);
              unmatchedIds.remove(id);
            }
          }
        }

        // If we have unmatched IDs, fetch them from endpoint
        if (unmatchedIds.isNotEmpty) {
          PhantomResponse response = await global.api.getData(
            ApiUrl.getLikedProducts.path,
          );
          if (response.statusCode != 200 ||
              response.data == null ||
              response.data!['likedProducts'] == null) {
            return [];
          }
          final responseLikedProducts =
              response.data?['likedProducts'] as List<dynamic>;
          List<ProductSimple> products =
              responseLikedProducts
                  .map((e) => ProductSimple.fromJson(e))
                  .toList();
          // Add new products to cache and result list
          for (ProductSimple product in products) {
            if (unmatchedIds.contains(product.productId)) {
              likedProducts.add(product);
              if (!global.allProducts.value.products.contains(product)) {
                global.allProducts.value.products.add(product);
              }
            }
          }
        }
        return likedProducts;
      }
      return [];
    } catch (e) {
      print('Error in UserProfileController.fetchLikedProducts(): $e');
      return [];
    }
  }

  // get a list of user's liked products from a list of product ids
  // this is the preferred method for fetching liked products
  List<ProductSimple>? _getLikedProductsFromIds(List<dynamic> productIds) {
    try {
      if (global.allProducts.value.products.isEmpty) {
        throw ('cannot fetch liked products because global.allProducts.value.products is empty');
      }

      List<ProductSimple> likedProducts = <ProductSimple>[];
      for (int id in productIds) {
        ProductSimple? current = global.allProducts.value.products
            .firstWhereOrNull((e) => e.productId! == id);
        if (current == null) continue;
        likedProducts.add(current);
      }

      return likedProducts;
    } catch (e) {
      print('Error in UserProfileController.getLikedProductsFromIds: $e');
      return null;
    }
  }

  /// addresses

  // set the default address
  Future<void> setUserDefaultAddress(String addressId) async {
    final Map<String, String> query = {
      'addressId': addressId,
      'profileId': global.user.value.profileId.toString(),
    };

    try {
      final response = await global.api.getData(
        ApiUrl.setUserDefaultAddress.withQuery(query),
      );
      if (response.hasError)
        throw (response.errorMessage ?? 'an unknown error occurred');
    } catch (e) {
      print('Error in UserProfileController.setUserDefaultAddress(): $e');
      throw Exception();
    }
  }

  /// save for later

  // create a product to save for later
  Future<int?> saveProductForLater(String product, int quantity) async {
    final int profileId = global.user.value.profileId;

    final Map<String, String> query = {
      'profileId': profileId.toString(),
      'product': product,
      'quantity': quantity.toString(),
    };

    try {
      // TODO : Dany implement delete method for PhantomResponse
      if (false) {
        final PhantomResponse response =
            await global.api.delete(ApiUrl.saveForLater.withQuery(query))
                as PhantomResponse;

        if (response.statusMessage == null ||
            response.statusMessage!.toLowerCase().trim() != 'success') {
          throw ('${response.message ?? 'An error occurred'} with status ${response.statusCode ?? 'unknown status'}');
        }

        print(response.message ?? 'Update completed successfully');
      }

      final response = await global.api.delete(
        ApiUrl.saveForLater.withQuery(query),
      );

      if (response.statusCode == null || response.statusCode! > 299) {
        print(
          'operation returned an invalid response of ${response.statusCode ?? 'unknown response'}',
        );
        throw (response);
      }

      return response.statusCode;
    } catch (e) {
      final response = e as Response;
      print(
        'Error in UserProfileController.saveProductForLater(): ${response.body['message'] ?? 'an unknown error occurred'}',
      );
      return (response.statusCode);
    }
  }

  /// wallets

  // get the user's cards
  Future<List<CardPayment>> getUserCardPayments() async {
    try {
      final customerProfileId = global.user.value.customerId;

      if (customerProfileId == null) {
        throw ('User\'s customer profile ID was null, cannot retrieve payment profile');
      }

      final url = 'profiles/credit/cards';
      PhantomResponse response = await global.api.getData(url);
      final cards = response.data?['cards'] as List<dynamic>;
      final cardPayments = cards.map((e) => CardPayment.fromJson(e)).toList();

      global.userCardPayments.value = cardPayments;

      return cardPayments;
    } catch (e, s) {
      print('Error in UserProfileController.getUserCardPayments: $e');
      print(s);
      rethrow;
    }
  }

  // add new payment method
  Future<PhantomResponse> addUserPaymentCard({
    required Map<String, dynamic> payload,
  }) async {
    final customerProfileId = global.user.value.customerId;
    payload['customerProfileId'] = customerProfileId;

    PhantomResponse response = await global.api.postData(
      'profiles/add/credit/card',
      payload,
    );
    if (response.isSuccess) {
      global.user.value = AuthProfileUser.fromJson(response.data!['profile']);
      global.user.refresh();
      global.update();
    }
    return response;
  }

  /// medical license controller

  // update the user's medical license
  Future<String> updateUserMedicalLicense(MedicalLicense license) async {
    try {
      final PhantomResponse response = await global.api.putData(
        ApiUrl.updateUserProfile.path,
        {"specialty": license.toJson()},
      );

      if (response.statusCode != 200 || response.statusMessage != 'Success') {
        throw ('${response.message} - ${response.errorMessage}');
      }

      return 'Successfully updated medical license';
    } catch (e, s) {
      print('Error in UserProfileController.updateUserMedicalLicense: $e');
      print(s);
      return '$e';
    }
  }

  /// general profile updates

  // perform an update on the User's profile
  Future<String> updateUserBasicInfo(UpdateUserProfile basicInfo) async {
    try {
      final PhantomResponse response = await global.api.putData(
        ApiUrl.updateUserProfile.path,
        {
          "firstName": basicInfo.firstName,
          "lastName": basicInfo.lastName,
          "phone": basicInfo.phone,
          "practiceName": basicInfo.practiceName,
          "email": basicInfo.email,
          "website": basicInfo.website,
        },
      );

      if (response.statusCode != 200 || response.statusMessage != 'Success') {
        throw ('${response.message} - ${response.errorMessage}');
      }

      return 'Successfully updated medical license';
    } catch (e, s) {
      print('Error in UserProfileController.updateUserMedicalLicense: $e');
      print(s);
      return '$e';
    }
  }

  Future<void> verifyEmail() async {
    // final response = await global.api.
  }

  Future<void> postFeedbacks(feedbackData) async {
    final response = await global.api.postData(
      ApiUrl.postFeedbacks.path, feedbackData
    );
    if (response.statusCode != 200 || response.statusMessage != 'Success') {
      throw ('${response.message} - ${response.errorMessage}');
    } else {}
  }
}
