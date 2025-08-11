import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:YLift/core/controllers/global.dart';

import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/models/z-index_export.dart';


class AddressManagementWidget extends StatefulWidget {
  @override
  _AddressManagementWidgetState createState() => _AddressManagementWidgetState();
}

class _AddressManagementWidgetState extends State<AddressManagementWidget> {
  final GlobalController controller = Get.find<GlobalController>();
  final _formKey = GlobalKey<FormState>();
  late AddressSimple _editingAddress;
  bool _isEditing = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Shipping to',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    // setState(() {
                    //   _isEditing = false;
                    //   _editingAddress = Address(
                    //     id: 0,
                    //     name: '',
                    //     line1: '',
                    //     city: '',
                    //     state: '',
                    //     zip: '',
                    //     profileId: controller.profile.value.info!.id!,
                    //     createdAt: DateTime.now(),
                    //     updatedAt: DateTime.now(),
                    //   );
                    // });
                    Navigator.pop(context); // Close the bottom sheet
                    _addNewAddress();
                    // _addNewAddress(); // Open the add new address dialog

                  },
                  child: Text('Add New'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isEditing ? _buildAddressForm() : _buildAddressList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressList() {
    return ListView.builder(
      itemCount: controller.profile.value.addresses!.length,
      itemBuilder: (context, index) {
        AddressSimple address = controller.profile.value.addresses![index];
        return ListTile(
          title: Text(_formatAddress(address)),
          subtitle: Text(_formatNamePhone(address)),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = true;
                _editingAddress = address;
              });
            },
          ),
          onTap: () {
            _handleAddressSelection(address.id.toString());
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Widget _buildAddressForm() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.all(16),
        children: [
          TextFormField(
            initialValue: _editingAddress.name,
            decoration: InputDecoration(labelText: 'Name'),
            validator: (value) => value!.isEmpty ? 'Required' : null,
            onSaved: (value) => _editingAddress.name = value!,
          ),
          TextFormField(
            initialValue: _editingAddress.phone,
            decoration: InputDecoration(labelText: 'Phone'),
            validator: (value) => value!.isEmpty ? 'Required' : null,
            onSaved: (value) => _editingAddress.phone = value!,
          ),
          TextFormField(
            initialValue: _editingAddress.line1,
            decoration: InputDecoration(labelText: 'Address Line 1'),
            validator: (value) => value!.isEmpty ? 'Required' : null,
            onSaved: (value) => _editingAddress.line1 = value!,
          ),
          TextFormField(
            initialValue: _editingAddress.line2,
            decoration: InputDecoration(labelText: 'Address Line 2'),
            onSaved: (value) => _editingAddress.line2 = value,
          ),
          TextFormField(
            initialValue: _editingAddress.city,
            decoration: InputDecoration(labelText: 'City'),
            validator: (value) => value!.isEmpty ? 'Required' : null,
            onSaved: (value) => _editingAddress.city = value!,
          ),
          TextFormField(
            initialValue: _editingAddress.state,
            decoration: InputDecoration(labelText: 'State'),
            validator: (value) => value!.isEmpty ? 'Required' : null,
            onSaved: (value) => _editingAddress.state = value!,
          ),
          TextFormField(
            initialValue: _editingAddress.zip,
            decoration: InputDecoration(labelText: 'ZIP Code'),
            validator: (value) => value!.isEmpty ? 'Required' : null,
            onSaved: (value) => _editingAddress.zip = value!,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isLoading ? null : _saveAddress,
            child: _isLoading
                ? CircularProgressIndicator()
                : Text(_editingAddress.id == 0 ? 'Add Address' : 'Save Changes'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _isEditing = false;
              });
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _saveAddress() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      try {
        final response = _editingAddress.id == 0
            ? await controller.api.post(ApiUrl.addresses.path, _editingAddress.toJson())
            : await controller.api.put(ApiUrl.addresses.withId(_editingAddress.id.toString()), _editingAddress.toJson());

        if (response.statusCode == 200) {
          AddressSimple updatedAddress = AddressSimple.fromJson(response.data);
          if (_editingAddress.id == 0) {
            controller.profile.value.addresses!.add(updatedAddress);
          } else {
            int index = controller.profile.value.addresses!.indexWhere((a) => a.id == updatedAddress.id);
            if (index != -1) {
              controller.profile.value.addresses![index] = updatedAddress;
            }
          }
          controller.profile.refresh();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Address saved successfully')),
          );

          setState(() {
            _isEditing = false;
            _isLoading = false;
          });
        } else {
          throw Exception('Failed to save address');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: Failed to save address')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _addNewAddress() async {
    final _formKey = GlobalKey<FormState>();
    final newAddressData = {
      "name": "",
      "phone": "",
      "line1": "",
      "line2": "",
      "city": "",
      "state": "",
      "zip": ""
    };

    bool isAdding = false;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Add New Address'),
              content: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Name'),
                        validator: (value) => value!.isEmpty ? 'Required' : null,
                        onSaved: (value) => newAddressData['name'] = value!,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Phone'),
                        validator: (value) => value!.isEmpty ? 'Required' : null,
                        onSaved: (value) => newAddressData['phone'] = value!,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Address Line 1'),
                        validator: (value) => value!.isEmpty ? 'Required' : null,
                        onSaved: (value) => newAddressData['line1'] = value!,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Address Line 2'),
                        onSaved: (value) => newAddressData['line2'] = value!,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'City'),
                        validator: (value) => value!.isEmpty ? 'Required' : null,
                        onSaved: (value) => newAddressData['city'] = value!,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'State'),
                        validator: (value) => value!.isEmpty ? 'Required' : null,
                        onSaved: (value) => newAddressData['state'] = value!,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'ZIP Code'),
                        validator: (value) => value!.isEmpty ? 'Required' : null,
                        onSaved: (value) => newAddressData['zip'] = value!,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ElevatedButton(
                  child: isAdding ? CircularProgressIndicator() : Text('Add'),
                  onPressed: isAdding
                      ? null
                      : () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      setState(() => isAdding = true);
                      try {
                        final response = await controller.api.post(
                            ApiUrl.addresses.path, newAddressData);
                        if (response.statusCode == 200) {
                          Map<String, dynamic> jsonMap = response.data;
                          AddressSimple newAddress = AddressSimple.fromJson(jsonMap);
                          controller.profile.value.addresses!.add(newAddress);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Address added successfully')),
                          );
                          Navigator.of(context).pop();
                        } else {
                          throw Exception('Failed to add address');
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: Address not added')),
                        );
                      } finally {
                        setState(() => isAdding = false);
                      }
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );

    // Refresh the address list
    setState(() {});
  }


  String _formatAddress(AddressSimple address) {
    return '${address.line1}, ${address.city}, ${address.state} ${address.zip}';
  }

  String _formatNamePhone(AddressSimple address) {
    return '${address.name}, ${address.phone ?? ""}';
  }

  _handleAddressSelection(String addressId) async {
    var selectedAddress = controller.profile.value.addresses!
        .firstWhere((element) => element.id == int.parse(addressId));
    controller.cart.value.checkout?.address = selectedAddress;

    try {
      CartInfo info = await controller.api
          .get(ApiUrl.orderInfoZip.withId(selectedAddress.zip))
          .then((value) {
        Map<String, dynamic> jsonMap = value.data;
        return CartInfo.fromJson(jsonMap);
      });

      // Update the cart info and tax outside of setState
      controller.cart.value.info = info;
      controller.cart.value.checkout?.tax =
          controller.cart.value.info!.taxTotal;
      controller.cart.value.checkout?.subtotal =
          controller.cart.value.info!.subtotal;

      // Trigger a rebuild of the widget tree
      setState(() {});
    } catch (e) {
      print('Error fetching cart info: $e');
      // TODO : Handle the error appropriately (e.g., show an error message to the user)
    }

    try {
      // TODO : move this to a controller
      final response = await controller.api.get(ApiUrl.cartShipping.path);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonMap = response.data;
        final cartItemsResponse = CartItemsResponse.fromJson(jsonMap);

        List<dynamic> productShippingSettingsData =
        jsonMap['productShippingSettings'];
        List<ProductShippingSettings> productShippingSettings =
        productShippingSettingsData
            .map((item) => ProductShippingSettings.fromJson(item))
            .toList();
        List<dynamic> vendorShippingSettingsData =
        jsonMap['vendorShippingSettings'];
        List<VendorShippingSettings> vendorShippingSettings =
        vendorShippingSettingsData
            .map((item) => VendorShippingSettings.fromJson(item))
            .toList();

        controller.cart.value.productShippingSettings = productShippingSettings;
        controller.cart.value.vendorShippingSettings = vendorShippingSettings;
        controller.cart.value.checkout!.shippingInfo =
            ShippingSettingsConverter.convertAll(
              productShippingSettings,
              vendorShippingSettings,
              cartItemsResponse.cartItemsByProduct,
              cartItemsResponse.cartItemsByVendor,
            );
        setState(() {});

        controller.cart.value.checkout!.shipping = 0;

        // check if any of the shipping settings is flat rate
        for (var shipping in controller.cart.value.checkout!.shippingInfo) {
          if (shipping.isFlatRate == true && shipping.selectedRate == 0) {
            shipping.selectedRate = shipping.regularRate;

            if (controller.cart.value.checkout!.shipping == 0 ||
                controller.cart.value.checkout!.shipping == null) {
              controller.cart.value.checkout!.shipping = shipping.regularRate;
            } else {
              controller.cart.value.checkout!.shipping =
                  (controller.cart.value.checkout!.shipping ?? 0) +
                      shipping.regularRate;
            }
          }
        }

        //
      }
    } catch (e) {
      print('Error fetching shipping settings: $e');
      // TODO : Handle the error appropriately (e.g., show an error message to the user)
    }
  }


}