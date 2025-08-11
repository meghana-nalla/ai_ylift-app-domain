import 'dart:developer';

import 'package:get/get.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/core/controllers/z-index_export.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:galaxy_models/galaxy_models.dart';

class AddressBookController extends GetxController {
  final RxList<AddressSimple> addresses = <AddressSimple>[].obs;
  final RxBool isLoading = true.obs;
  final GlobalController controller = Get.find<GlobalController>();

  List<AddressSimple> get validAddresses =>
      addresses.where((element) => element.isValid).toList();

  Future<void> loadAddresses() async {
    try {
      isLoading.value = true;
      addresses.value =
          await controller.userController.getAddressesByProfileId();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addAddress(AddressSimple address) async {
    try {
      final profileId = controller.user.value.profileId;
      // Convert the Address object to a JSON-compatible map
      Map<String, dynamic> addressData = {
        'id': address.id,
        'profileId': profileId,
        'addressId': address.addressId,
        'name': address.name,
        'line1': address.line1,
        'line2': address.line2 ?? '',
        'city': address.city,
        'state': address.state,
        'zip': address.zip,
        'phone': address.phone,
        'allerganId': address.allerganId ?? '',
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': null,
        'deleted': false,

        ///Add new Address Type
        /// Dany requested
        /// 02/07
        'type': address.type?.name,
      };

      final response = await controller.api.post(
        ApiUrl.addresses.withId(profileId.toString()),
        addressData, // Include the address data as the request body
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Address successfully created.');
        controller.addressBook.addresses.add(address);
      } else {
        throw Exception(
          'Failed to create address, status code: ${response.statusCode}',
        );
      }
    } catch (e, s) {
      print("Error occurred while creating address: $e\n$s");
      throw Exception('Failed to create address: $e');
    }
  }

  Future<void> deleteAddress(AddressSimple address) async {
    try {
      final response = await controller.api.delete(
        ApiUrl.deleteAddress.withId(address.addressId.toString()),
      );

      if (response.statusCode == 200) {
        print('Deleted address with line1 ${address.line1}');
        controller.addressBook.addresses.remove(address);
      } else {
        throw Exception(
          'Failed to delete address, status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print("Error occurred while deleting address: $e");
      throw Exception('Failed to delete address: $e');
    }
  }

  Future<void> updateAddress(
    AddressSimple newAddress,
    AddressSimple oldAddress,
  ) async {
    try {
      // for working with the back end
      final Map<String, dynamic> updatedAddressData = {
        // old address fields
        'id': oldAddress.id,
        'profileId': int.parse(oldAddress.profileId),
        'addressId': oldAddress.addressId,
        'createdAt': oldAddress.createdAt.toIso8601String(),

        // newAddress fields
        'name': newAddress.name,
        'line1': newAddress.line1,
        'line2': newAddress.line2 ?? '',
        'city': newAddress.city,
        'state': newAddress.state,
        'zip': newAddress.zip,
        'phone': newAddress.phone,
        'allerganId': newAddress.allerganId,
        'updatedAt': DateTime.now().toIso8601String(),
        'deleted': false,
        'type': newAddress.type?.name,
      };

      final response = await controller.api.put(
        ApiUrl.addresses.path,
        updatedAddressData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Updated address with line1 ${oldAddress.line1}');

        // for representing in the front end
        final AddressSimple updatedAddress = AddressSimple(
          // These do not change from the old address
          id: oldAddress.id,
          addressId: oldAddress.addressId,
          profileId: oldAddress.profileId,
          createdAt: oldAddress.createdAt,

          // these fields are updated from the new address
          name: newAddress.name,
          line1: newAddress.line1,
          line2: newAddress.line2 ?? "",
          city: newAddress.city,
          state: newAddress.state,
          zip: newAddress.zip,
          phone: newAddress.phone,
          country: newAddress.country,
          type: newAddress.type,
          updatedAt: DateTime.now(),
        );

        controller.addressBook.addresses.remove(oldAddress);
        controller.addressBook.addresses.add(updatedAddress);
      } else {
        throw Exception(
          'Failed to delete address, status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print("Error occurred while updating address: $e");
      throw Exception('Failed to update address: $e');
    }
  }

  Future<void> setAsDefault(AddressSimple address) async {
    try {
      // for working with the back end
      final updatedAddress = AddressSimple(
        id: address.id,
        addressId: address.addressId,
        profileId: address.profileId,
        createdAt: address.createdAt,
        name: address.name,
        line1: address.line1,
        line2: address.line2 ?? "",
        city: address.city,
        state: address.state,
        zip: address.zip,
        phone: address.phone,
        country: address.country,
        type: address.type,
        updatedAt: DateTime.now(),
        isDefault: true,
        isValid: address.isValid,
        allerganId: address.allerganId,
      );
      final response = await controller.api.put(
        ApiUrl.addresses.path,
        updatedAddress.toJson(),
      );

      if (response.isSuccess) {
        log('Address ${address.addressId} has been set as default.');
      } else {
        throw Exception(
          'Failed to delete address, status code: ${response.statusCode}',
        );
      }
    } catch (e) {}
  }
}
