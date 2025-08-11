
import 'package:get/get.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:YLift/core/controllers/z-index_export.dart';
import 'package:galaxy_models/galaxy_models.dart';

/// # ProductsController
///
class UserController extends GetxController {
  final GlobalController global = Get.find<GlobalController>();

  Future<AuthProfileUser> getUserProfile() async {
    // deprecated ...
    try {
      final response = await global.api.get(ApiUrl.profiles.path);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonMap = response.data;
        AuthProfileUser user = AuthProfileUser.fromJson(jsonMap);
        return user;
      } else {
        throw Exception('Failed to load product, status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error occurred: $e");
      throw Exception('Failed to load product: $e');
    }
  }

  Future<List<AddressSimple>> getAddresses() async {
    try {
      final response = await global.api.get(ApiUrl.addresses.path);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonMap = response.data;
        List<dynamic> jsonList = jsonMap['rows'];
        List<AddressSimple> addresses = jsonList.map((json) => AddressSimple.fromJson(json)).toList();
        return addresses;
      } else {
        throw Exception('Failed to load products, status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error occurred: $e");
      throw Exception('Failed to load products: $e');
    }
  }

  Future<List<AddressSimple>> getAddressesByProfileId() async {
    try {
      final response = await global.api.get(ApiUrl.addresses.withId(global.user.value.profileId.toString()));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonMap = response.data;
        List<dynamic> jsonList = jsonMap['Addresses'];
        List<AddressSimple> addresses = jsonList.map((json) => AddressSimple.fromJson(json)).toList();
        addresses.sort((a, b) => (a.isValid == b.isValid) ? 0 : (a.isValid ? -1 : 1));
        return addresses;
      } else {
        throw Exception('Failed to load product, status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error occurred: $e");
      throw Exception('Failed to load addresses: $e');
    }
  }

  Future<List<AddressSimple>> getAddressesDynamic({AddressSimpleType? addressType}) async {
    final profileId = global.user.value.profileId.toString();
    final response = await global.api.get(ApiUrl.addresses.withId(profileId));
    if (response.statusCode == 200) {
      final jsonMap = response.data as Map<String, dynamic>;
      final jsonList = jsonMap['Addresses'] as List<dynamic>;
      final allAddresses = jsonList.map((json) => AddressSimple.fromJson(json)).toList();
      allAddresses.sort((a, b) => (a.isValid == b.isValid) ? 0 : (a.isValid ? -1 : 1));

      if(addressType != null){
        final addresses = allAddresses.where((e) => e.type == addressType).toList();
        addresses.sort((a, b) => (a.isValid == b.isValid) ? 0 : (a.isValid ? -1 : 1));
        return addresses;
      }

      return allAddresses;
    } else {
      throw Exception('Failed to load addresses, status code: ${response.statusCode}');
    }
  }

  Future<List<AddressSimple>> getShippingAddressesByProfileId() async {
    try {
      final response = await global.api.get(ApiUrl.addresses.withId(global.user.value.profileId.toString()));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonMap = response.data;
        List<dynamic> jsonList = jsonMap['Addresses'];
        var addresses_nofilter = jsonList.map((json) => AddressSimple.fromJson(json)).toList();
        List<AddressSimple>addresses = addresses_nofilter.where((x) => x.type == AddressSimpleType.SHIPPING).toList();
        addresses.sort((a, b) => (a.isValid == b.isValid) ? 0 : (a.isValid ? -1 : 1));
        return addresses;
      } else {
        throw Exception('Failed to load product, status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error occurred: $e");
      throw Exception('Failed to load addresses: $e');
    }
  }

  /// (LEGACY) add an address to the user
  Future<void> addAddress(AddressSimple address) async {
    try {
      Map<String, dynamic> addressData = address.toJson();
      final response = await global.api.post(
        ApiUrl.addresses.path,
        addressData, // Include the address data as the request body
      );

      if (response.statusCode == 200) {
        print('Address successfully created.');
      }
    } catch (e) {
      print("Error occurred while creating address: $e");
      throw Exception('Failed to create address: $e');
    }
  }

  /// add an address to the user
  /// moved to address book controller

  // here we get the profile of the user ..
  Future<List<Recurring>> getRecurring(String id) async {
    try {
      final response = await global.api.get(ApiUrl.recurrings.withId(id));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonMap = response.data;
        List<dynamic> jsonList = jsonMap['rows'];
        List<Recurring> recurring = jsonList.map((json) => Recurring.fromJson(json)).toList();
        return recurring;
      } else {
        throw Exception('Failed to load products, status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error occurred: $e");
      throw Exception('Failed to load products: $e');
    }
  }

  Future<void> updateProfile(UpdateUserProfile user) async {
    try {
      final response = await global.api.putData(ApiUrl.updateUserProfile.path, user.toJson());
      if (response.statusCode == 200) {
        print('Profile successfully updated.');
      } else {
        throw Exception('Failed to update profile, status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error occurred while updating profile: $e");
      throw Exception('Failed to update profile: $e');
    }
  }

  Future<void> setDefaultCardPayment(String cardId) async {
    try {
      final response = await global.api.putData('${ApiUrl.setUserDefaultCard.path}/$cardId', {});
      if (response.isSuccess) {
        print('Card ID $cardId has been set to default');
        await global.userProfile.fetchProfile();
        // final rCards = response.data!['cards'] as List<dynamic>;
        // final cards = CardPayment.fromList(rCards);
        // global.user.value.wallet?.clear();
        // global.user.value.wallet?.addAll(cards);
        // global.refresh();
      } else {
        throw Exception('Failed to update profile, status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error occurred while updating profile: $e");
      throw Exception('Failed to update profile: $e');
    }
  }

  Future<void> editCardPayment(String cardId) async {
    try {
      final response = await global.api.putData('${ApiUrl.setUserDefaultCard.path}/$cardId', {});
      if (response.isSuccess) {
        print('Card ID $cardId has been set to default');
        global.userProfile.fetchProfile();
        // final rCards = response.data!['cards'] as List<dynamic>;
        // final cards = CardPayment.fromList(rCards);
        // global.user.value.wallet?.clear();
        // global.user.value.wallet?.addAll(cards);
        // global.refresh();
      } else {
        throw Exception('Failed to update profile, status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error occurred while updating profile: $e");
      throw Exception('Failed to update profile: $e');
    }
  }

  Future<void> deleteCardPayment(String cardId) async {
    try {
      final response = await global.api.deleteData('${ApiUrl.deleteCard.path}/$cardId');
      if (response.isSuccess) {
        await global.userProfile.fetchProfile();
      } else {
        throw Exception('Failed to update profile, status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error occurred while updating profile: $e");
      throw Exception('Failed to update profile: $e');
    }
  }


  ///**********************************************************
  /// Virtual Content Videos endpoint
  ///**********************************************************
  Future<VideoTrainingCourse> getVirtualContent(String id) async {
    try {
      PhantomResponse response = await global.api.getData(ApiUrl.trainingVideos.path);
      if (response.isSuccess) {
        var virtualContent = VideoTrainingCourse.fromJson(response.data!['virtual']);
        global.loadedVirtualContent.value = virtualContent;
        return virtualContent;
      }
      else {
        // throw Exception('Falied to load Training Videos ${response.message}');
        return VideoTrainingCourse();
      }
    } catch (e,s) {
      throw Exception('Error fetching Training Videos: $e\n$s');
    }
  }


  ///**********************************************************
  /// Training Course Videos endpoint
  ///**********************************************************
  Future<List<TrainingCourse>> getTrainingCourses() async {
    try {
      PhantomResponse response = await global.api.getData(ApiUrl.trainingVideos.path);
      if (response.isSuccess) {
        var lstTrainingCourse = TrainingCourse.fromJsonList(response.data!['profileVideos']);
        global.trainingCourses.value = lstTrainingCourse;
        return lstTrainingCourse;
      }
      else {
        // throw Exception('Falied to load Training Videos ${response.message}');
        return [];
      }
    } catch (e,s) {
      throw Exception('Error fetching Training Videos: $e\n$s');
    }
  }

  /// ***************************************************
  /// Get all the training subscription that the user has
  /// ***************************************************
  Future<List<TrainingSubscription>> getTrainingSubscription() async {
    try {
      PhantomResponse response = await global.api.getData(ApiUrl.trainingSubscription.path);
      if (response.isSuccess) {
        var lstTraininSubscription = TrainingSubscription.fromJsonList(response.data!['activeTrainings']);
        global.trainingSubscription.value = lstTraininSubscription;
        return lstTraininSubscription;
      } else {
        return [];
      }
    } catch (e, s) {
      throw Exception('Error fetching Training Subscriptions: $e\n$s');
    }
  }

  Future<int?> getStoreCreditBalance() async {
    final response = await global.api.getData(ApiUrl.storeCreditBalance.path);
    if(response.isSuccess) {
      final balance = response.data['balance'];
      if(balance is! int) return null;
      return balance;
    } else {
      throw Exception('Failed to get store credit balance, status code: ${response.statusCode}');
    }
  }

}
