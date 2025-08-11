import 'package:YLift/models/z-index_export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'order_process.dart';

class CheckOutOrderSummary extends StatefulWidget {
  const CheckOutOrderSummary({Key? key}) : super(key: key);

  @override
  _CheckOutOrderSummaryState createState() => _CheckOutOrderSummaryState();
}

class _CheckOutOrderSummaryState extends State<CheckOutOrderSummary> {
  final GlobalController controller = Get.find<GlobalController>();
  final PageController _pageController = PageController(viewportFraction: 1);
  int _currentPage = 0;
  final NumberFormat currencyFormat = NumberFormat.currency(symbol: '\$');

  // on init, we fetch the cart profile
  @override
  void initState() {
    super.initState();
    // first get address (never null, defaults to first address)
    controller.cart.value.checkout?.address = controller.profile.value.addresses!.first;

    // then get card (sometimes null)
    controller.cart.value.checkout?.card =
    (controller.cart.value.cards!.isNotEmpty ? controller.cart.value.cards!.first : null);

    // call this function with first address, then set state
    _handleAddressSelection(
        controller.profile.value.addresses!.first.id.toString());
    setState(() {});
  }

  // Theme.of(context).colorScheme.surface
  @override
  Widget build(BuildContext context) {
    var (receiptWidget, _) = _buildOrderReceipt();

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 2),
              const Text(
                'Shipping Information',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                  onTap: _openAddressSelectionWindow,
                  child: Card(
                    child: ListTile(
                      leading:
                      const Icon(Icons.location_on, color: Colors.brown),
                      title: Text(
                          controller.cart.value.checkout?.address != null
                              ? _formatAddress(
                              controller.cart.value.checkout!.address!)
                              : _formatAddress(
                              controller.profile.value.addresses!.first)),
                      subtitle: Text(
                          controller.cart.value.checkout?.address != null
                              ? _formatNamePhone(
                              controller.cart.value.checkout!.address!)
                              : _formatNamePhone(
                              controller.profile.value.addresses!.first)),
                      trailing: const Icon(Icons.chevron_right),
                    ),
                  )),
              const SizedBox(height: 16),
              // do we have shipping settings?

              // does the shipping settings have any items?
              if (controller.cart.value.checkout!.shippingInfo.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // if we have more than one shipping setting, show the current page
                    if (controller.cart.value.checkout!.shippingInfo.length >
                        1) ...[
                      Text(
                          'Product Shipment ${_currentPage + 1} of ${controller.cart.value.checkout!.shippingInfo.length}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Row(
                        children: List.generate(
                          controller.cart.value.checkout!.shippingInfo.length,
                              (index) => Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentPage == index
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      const Text(
                        'Product Shipment',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                _buildShippingPanel(),
                const SizedBox(height: 16),
              ],
              const Text(
                'Payment Information',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                  onTap: _openPaymentSelectionWindow,
                  child: Card(
                    child: ListTile(
                      leading: const Icon(Icons.credit_card),
                      title: Text(controller.cart.value.cards!.isNotEmpty
                          ? _formatCard(controller.cart.value.checkout!.card!)
                          : 'Add a new card'),
                      trailing: const Icon(Icons.chevron_right),
                    ),
                  )),
              const SizedBox(height: 16),
              const Text(
                'Summary',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              receiptWidget,
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  child: const Text('Place Your Order'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    _isOrderReady() ?  Colors.brown : Colors.grey,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 50),
                  ),
                  onPressed: _isOrderReady() ? _placeOrder : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _formatAddress(AddressSimple address) {
    return '${address.line1}, ${address.city}, ${address.state} ${address.zip}';
  }

  _formatNamePhone(AddressSimple address) {
    // split name using space and the last split is character with trailing comma
    return '${address.name.split(' ').first} ${address.name.split(' ').last}, ${address.phone}';
  }

  _formatCard(CardInformation card) {
    return 'Ending in ${card.cardNumber}';
  }

  String _formatProductName(ShippingSettings shipment) {
    if (shipment.isProduct) {
      for (var element in controller.cart.value.shoppingItems) {
        if (element.items != null) {
          for (var item in element.items!) {
            if (item.productId == shipment.id) {
              return item.productName ?? 'Product';
            }
          }
        }
      }
    }
    for (var element in controller.cart.value.shoppingItems) {
      if (element.vendorId != null && element.vendorId == shipment.id) {
        return element.brandName ?? 'Vendor';
      }
    }
    return 'Vendor';
  }

  _handleCreditCardSelection(CardInformation card) {
    setState(() {
      controller.cart.value.checkout?.card = card;
    });
    // Navigator.pop(context);
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
      // Handle the error appropriately (e.g., show an error message to the user)
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
      // Handle the error appropriately (e.g., show an error message to the user)
    }
  }

  // Future<void> _addNewAddress() async {
  //   final _formKey = GlobalKey<FormState>();
  //   final newAddressData = {
  //     "name": "",
  //     "phone": "",
  //     "line1": "",
  //     "line2": "",
  //     "city": "",
  //     "state": "",
  //     "zip": ""
  //   };
  //
  //   bool isAdding = false;
  //
  //   await showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         builder: (BuildContext context, StateSetter setState) {
  //           return AlertDialog(
  //             title: Text('Add New Address'),
  //             content: Form(
  //               key: _formKey,
  //               child: SingleChildScrollView(
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     TextFormField(
  //                       decoration: InputDecoration(labelText: 'Name'),
  //                       validator: (value) => value!.isEmpty ? 'Required' : null,
  //                       onSaved: (value) => newAddressData['name'] = value!,
  //                     ),
  //                     TextFormField(
  //                       decoration: InputDecoration(labelText: 'Phone'),
  //                       validator: (value) => value!.isEmpty ? 'Required' : null,
  //                       onSaved: (value) => newAddressData['phone'] = value!,
  //                     ),
  //                     TextFormField(
  //                       decoration: InputDecoration(labelText: 'Address Line 1'),
  //                       validator: (value) => value!.isEmpty ? 'Required' : null,
  //                       onSaved: (value) => newAddressData['line1'] = value!,
  //                     ),
  //                     TextFormField(
  //                       decoration: InputDecoration(labelText: 'Address Line 2'),
  //                       onSaved: (value) => newAddressData['line2'] = value!,
  //                     ),
  //                     TextFormField(
  //                       decoration: InputDecoration(labelText: 'City'),
  //                       validator: (value) => value!.isEmpty ? 'Required' : null,
  //                       onSaved: (value) => newAddressData['city'] = value!,
  //                     ),
  //                     TextFormField(
  //                       decoration: InputDecoration(labelText: 'State'),
  //                       validator: (value) => value!.isEmpty ? 'Required' : null,
  //                       onSaved: (value) => newAddressData['state'] = value!,
  //                     ),
  //                     TextFormField(
  //                       decoration: InputDecoration(labelText: 'ZIP Code'),
  //                       validator: (value) => value!.isEmpty ? 'Required' : null,
  //                       onSaved: (value) => newAddressData['zip'] = value!,
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             actions: [
  //               TextButton(
  //                 child: Text('Cancel'),
  //                 onPressed: () => Navigator.of(context).pop(),
  //               ),
  //               ElevatedButton(
  //                 child: isAdding ? CircularProgressIndicator() : Text('Add'),
  //                 onPressed: isAdding
  //                     ? null
  //                     : () async {
  //                   if (_formKey.currentState!.validate()) {
  //                     _formKey.currentState!.save();
  //                     setState(() => isAdding = true);
  //                     try {
  //                       final response = await controller.api.post(
  //                           ApiUrl.addresses.path, newAddressData);
  //                       if (response.statusCode == 200) {
  //                         Map<String, dynamic> jsonMap = response.data;
  //                         AddressSimple newAddress = AddressSimple.fromJson(jsonMap);
  //                         controller.profile.value.addresses!.add(newAddress);
  //                         ScaffoldMessenger.of(context).showSnackBar(
  //                           SnackBar(content: Text('Address added successfully')),
  //                         );
  //                         Navigator.of(context).pop();
  //                       } else {
  //                         throw Exception('Failed to add address');
  //                       }
  //                     } catch (e) {
  //                       ScaffoldMessenger.of(context).showSnackBar(
  //                         SnackBar(content: Text('Error: Address not added')),
  //                       );
  //                     } finally {
  //                       setState(() => isAdding = false);
  //                     }
  //                   }
  //                 },
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   );
  //
  //   // Refresh the address list
  //   setState(() {});
  // }

  // void _openAddressretireOld() {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (BuildContext context) {
  //       return AddressManagementWidget();
  //     },
  //   );
  // }

  void _openAddressSelectionWindow() {
    bool isEditing = false;
    bool isAdding = false;
    bool enableDeleteAddress = false;
    AddressSimple? editingAddress;
    final _formKey = GlobalKey<FormState>();
    final addressData = {
      "name": "",
      "phone": "",
      "line1": "",
      "line2": "",
      "city": "",
      "state": "",
      "zip": "",
      "allerganId": null,
      "profileId": controller.profile.value.info!.profileId,
    };

    Future<void> deleteAddress(AddressSimple address) async {
      try {
        final response = await controller.api
            .delete(ApiUrl.addresses.withId(address.id.toString()));
        if (response.statusCode == 200) {
          controller.profile.value.addresses!.remove(address);
          setState(() {});
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Address deleted successfully')),
          );
        } else {
          throw Exception('Failed to delete card');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: Address not deleted')),
        );
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
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
                          isEditing || isAdding ? (isEditing ? 'Edit Address': 'Add Address' ) : 'Shipping to',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        if (!isEditing && !isAdding)
                          TextButton(
                            onPressed: () {
                              setModalState(() {
                                enableDeleteAddress = !enableDeleteAddress;
                              });
                            },
                            child: Text('Manage'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: isEditing || isAdding
                        ? SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                initialValue: addressData['name'] != null ? addressData['name'].toString() : '',
                                decoration: InputDecoration(labelText: 'Name'),
                                validator: (value) => value!.isEmpty ? 'Required' : null,
                                onSaved: (value) => addressData['name'] = value!,
                              ),
                              TextFormField(
                                initialValue: addressData['phone'] != null ? addressData['phone'].toString() : '',
                                decoration: InputDecoration(labelText: 'Phone'),
                                validator: (value) => value!.isEmpty ? 'Required' : null,
                                onSaved: (value) => addressData['phone'] = value!,
                              ),
                              TextFormField(
                                initialValue: addressData['line1'] != null ? addressData['line1'].toString() : '',
                                decoration: InputDecoration(labelText: 'Address Line 1'),
                                validator: (value) => value!.isEmpty ? 'Required' : null,
                                onSaved: (value) => addressData['line1'] = value!,
                              ),
                              TextFormField(
                                initialValue: addressData['line2'] != null ? addressData['line2'].toString() : '',
                                decoration: InputDecoration(labelText: 'Address Line 2'),
                                onSaved: (value) => addressData['line2'] = value,
                              ),
                              TextFormField(
                                initialValue: addressData['city'] != null ? addressData['city'].toString() : '',
                                decoration: InputDecoration(labelText: 'City'),
                                validator: (value) => value!.isEmpty ? 'Required' : null,
                                onSaved: (value) => addressData['city'] = value!,
                              ),
                              TextFormField(
                                initialValue: addressData['state'] != null ? addressData['state'].toString() : '',
                                decoration: InputDecoration(labelText: 'State'),
                                validator: (value) => value!.isEmpty ? 'Required' : null,
                                onSaved: (value) => addressData['state'] = value!,
                              ),
                              TextFormField(
                                initialValue: addressData['zip'] != null ? addressData['zip'].toString() : '',
                                decoration: InputDecoration(labelText: 'ZIP Code'),
                                validator: (value) => value!.isEmpty ? 'Required' : null,
                                onSaved: (value) => addressData['zip'] = value!,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                        : ListView.builder(
                      itemCount: controller.profile.value.addresses!.length,
                      itemBuilder: (context, index) {
                        AddressSimple address = controller.profile.value.addresses![index];
                        return ListTile(
                          title: Text(_formatAddress(address)),
                          subtitle: Text(_formatNamePhone(address)),
                          trailing: IconButton(
                            icon: enableDeleteAddress ? Icon(Icons.delete) : Icon(Icons.edit),
                            onPressed: () {
                              if(!enableDeleteAddress) {

                                setModalState(() {
                                  isEditing = true;
                                  editingAddress = address;
                                  addressData['name'] = address.name;
                                  addressData['phone'] = address.phone ?? '';
                                  addressData['line1'] = address.line1;
                                  addressData['line2'] = address.line2 ?? '';
                                  addressData['city'] = address.city;
                                  addressData['state'] = address.state;
                                  addressData['zip'] = address.zip;
                                });
                              }else{
                                deleteAddress(address);
                                Navigator.pop(context);
                                setModalState(() {});
                              }
                            },
                          ),
                          onTap: () {
                            _handleAddressSelection(address.id.toString());
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: isEditing || isAdding
                        ? Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              setModalState(() {
                                isEditing = false;
                                isAdding = false;
                              });
                            },
                            child: Text('Cancel'),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                try {
                                  final response = isEditing
                                      ? await controller.api.put(
                                      ApiUrl.addresses.withId(editingAddress!.id.toString()),
                                      addressData)
                                      : await controller.api.post(ApiUrl.addresses.path, addressData);
                                  if (response.statusCode == 200) {
                                    Map<String, dynamic> jsonMap = response.data;
                                    AddressSimple updatedAddress = AddressSimple.fromJson(jsonMap);
                                    setState(() {
                                      if (isEditing) {
                                        int index = controller.profile.value.addresses!
                                            .indexWhere((a) => a.id == updatedAddress.id);
                                        if (index != -1) {
                                          controller.profile.value.addresses![index] = updatedAddress;
                                        }
                                      } else {
                                        controller.profile.value.addresses!.add(updatedAddress);
                                      }
                                    });
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Address ${isEditing ? 'updated' : 'added'} successfully')),
                                    );
                                  } else {
                                    throw Exception('Failed to ${isEditing ? 'update' : 'add'} address');
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Error: Address not ${isEditing ? 'updated' : 'added'}')),
                                  );
                                }
                              }
                            },
                            child: Text(isEditing ? 'Save' : 'Add'),
                          ),
                        ),
                      ],
                    )
                        : ElevatedButton(
                      onPressed: () {
                        setModalState(() {
                          isAdding = true;
                          addressData.clear();
                          addressData['profileId'] = controller.profile.value.info!.profileId;
                        });
                      },
                      child: Text('+ Add new'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  _openPaymentSelectionWindow() {
    bool isAddingNewCard = false;
    bool isSaving = false;
    bool enableDeleteCard = false;
    final _formKey = GlobalKey<FormState>();
    final newCardData = {
      "addressFirstName": "",
      "addressLastName": "",
      "addressLine": "",
      "addressCity": "",
      "addressState": "",
      "addressZip": "",
      "addressCountry": "US",
      "cardNumber": "",
      "cardExpMonth": null,
      "cardExpYear": null,
      "cardCvc": ""
    };

    final List<String> months =
    List.generate(12, (index) => (index + 1).toString().padLeft(2, '0'));

    final int currentYear = DateTime.now().year;
    final List<String> years =
    List.generate(10, (index) => (currentYear + index).toString());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            void toggleAddNewCard() {
              setModalState(() {
                isAddingNewCard = !isAddingNewCard;
                // Reset form data when toggling
                newCardData['cardExpMonth'] = null;
                newCardData['cardExpYear'] = null;
              });
            }

            Future<void> saveNewCard() async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                setModalState(() {
                  isSaving = true;
                });

                try {
                  final response =
                  await controller.api.post(ApiUrl.cards.path, newCardData);
                  if (response.statusCode == 200) {
                    Map<String, dynamic> jsonMap = response.data;
                    // need to save the JsonMap response to an object
                    // var myTemp
                    CardResponse cardResponse = CardResponse.fromJson(jsonMap);
                    CardInformation newCard = CardInformation(
                      cardNumber: cardResponse.payment!.creditCard!.cardNumber!,
                      cardType: cardResponse.payment!.creditCard!.cardType!,
                      billTo: BillingAddress(
                          firstName: cardResponse.billTo!.firstName!,
                          lastName: cardResponse.billTo!.lastName!,
                          address: cardResponse.billTo!.address!,
                          city: cardResponse.billTo!.city!,
                          state: cardResponse.billTo!.state!,
                          zip: cardResponse.billTo!.zip!,
                          country: cardResponse.billTo!.country!),
                      customerPaymentProfileId:
                      cardResponse.customerPaymentProfileId!,
                    );
                    // make sure to set the default card if there are no cards
                    if (controller.cart.value.cards!.isEmpty)
                      controller.cart.value.checkout!.card = newCard;
                    controller.cart.value.cards!.add(newCard);
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Card added successfully')),
                    );
                    toggleAddNewCard();
                  } else {
                    throw Exception('Failed to add card');
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: Card not added')),
                  );
                } finally {
                  setModalState(() {
                    isSaving = false;
                  });
                }
              }
            }

            Future<void> deleteCard(CardInformation card) async {
              try {
                final response = await controller.api
                    .delete(ApiUrl.cards.withId(card.customerPaymentProfileId));
                if (response.statusCode == 200) {
                  controller.cart.value.cards!.remove(card);
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Card deleted successfully')),
                  );
                } else {
                  throw Exception('Failed to delete card');
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: Card not deleted')),
                );
              }
            }

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
                          'Paying with',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () {
                            setModalState(() {
                              enableDeleteCard = !enableDeleteCard;
                            });
                          },
                          child: Text('Manage'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isAddingNewCard) ...[
                    if (controller.cart.value.cards!.isEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text('No cards on file'),
                      ),
                    ] else ...[
                      Expanded(
                        child: ListView.builder(
                          itemCount: controller.cart.value.cards!.length,
                          itemBuilder: (context, index) {
                            CardInformation card =
                            controller.cart.value.cards![index];
                            bool isSelected =
                                card == controller.cart.value.checkout!.card;

                            return ListTile(
                              title: Row(children: [
                                Icon(Icons.credit_card),
                                SizedBox(width: 16),
                                Text(
                                  card.cardType,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ]),
                              subtitle: Row(children: [
                                Text(_formatCard(card)),
                                if (isSelected) ...[
                                  SizedBox(width: 16),
                                  Icon(Icons.check, color: Colors.blue),
                                ]
                              ]),
                              trailing: enableDeleteCard
                                  ? IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => deleteCard(card),
                              )
                                  : Icon(Icons.edit, color: Colors.grey),
                              onTap: () {
                                if (!enableDeleteCard) {
                                  _handleCreditCardSelection(card);
                                  setModalState(() {});
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: OutlinedButton(
                        onPressed: toggleAddNewCard,
                        child: Text('+ Add new'),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey),
                          minimumSize: Size(double.infinity, 50),
                        ),
                      ),
                    ),
                  ] else ...[
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  decoration:
                                  InputDecoration(labelText: 'First Name'),
                                  validator: (value) =>
                                  value!.isEmpty ? 'Required' : null,
                                  onSaved: (value) =>
                                  newCardData['addressFirstName'] = value!,
                                ),
                                TextFormField(
                                  decoration:
                                  InputDecoration(labelText: 'Last Name'),
                                  validator: (value) =>
                                  value!.isEmpty ? 'Required' : null,
                                  onSaved: (value) =>
                                  newCardData['addressLastName'] = value!,
                                ),
                                TextFormField(
                                  decoration:
                                  InputDecoration(labelText: 'Address'),
                                  validator: (value) =>
                                  value!.isEmpty ? 'Required' : null,
                                  onSaved: (value) =>
                                  newCardData['addressLine'] = value!,
                                ),
                                TextFormField(
                                  decoration:
                                  InputDecoration(labelText: 'City'),
                                  validator: (value) =>
                                  value!.isEmpty ? 'Required' : null,
                                  onSaved: (value) =>
                                  newCardData['addressCity'] = value!,
                                ),
                                TextFormField(
                                  decoration:
                                  InputDecoration(labelText: 'State'),
                                  validator: (value) =>
                                  value!.isEmpty ? 'Required' : null,
                                  onSaved: (value) =>
                                  newCardData['addressState'] = value!,
                                ),
                                TextFormField(
                                  decoration:
                                  InputDecoration(labelText: 'ZIP Code'),
                                  validator: (value) =>
                                  value!.isEmpty ? 'Required' : null,
                                  onSaved: (value) =>
                                  newCardData['addressZip'] = value!,
                                ),
                                DropdownButtonFormField<String>(
                                  decoration:
                                  InputDecoration(labelText: 'Country'),
                                  value: newCardData['addressCountry'],
                                  items: [
                                    DropdownMenuItem(
                                        child: Text('United States'),
                                        value: 'US'),
                                    DropdownMenuItem(
                                        child: Text('Canada'), value: 'CA'),
                                  ],
                                  onChanged: (value) {
                                    setModalState(() {
                                      newCardData['addressCountry'] = value!;
                                    });
                                  },
                                  validator: (value) =>
                                  value == null ? 'Required' : null,
                                ),
                                TextFormField(
                                  decoration:
                                  InputDecoration(labelText: 'Card Number'),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(16),
                                  ],
                                  validator: (value) {
                                    if (value!.isEmpty) return 'Required';
                                    if (value.length < 13 || value.length > 16)
                                      return 'Invalid card number';
                                    return null;
                                  },
                                  onSaved: (value) =>
                                  newCardData['cardNumber'] = value!,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: DropdownButtonFormField<String>(
                                        decoration: InputDecoration(
                                            labelText: 'Exp. Month'),
                                        value: newCardData['cardExpMonth'],
                                        items: months.map((String month) {
                                          return DropdownMenuItem<String>(
                                            value: month,
                                            child: Text(month),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setModalState(() {
                                            newCardData['cardExpMonth'] =
                                            newValue!;
                                          });
                                        },
                                        validator: (value) =>
                                        value == null ? 'Required' : null,
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: DropdownButtonFormField<String>(
                                        decoration: InputDecoration(
                                            labelText: 'Exp. Year'),
                                        value: newCardData['cardExpYear'],
                                        items: years.map((String year) {
                                          return DropdownMenuItem<String>(
                                            value: year,
                                            child: Text(year),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setModalState(() {
                                            newCardData['cardExpYear'] =
                                            newValue!;
                                          });
                                        },
                                        validator: (value) =>
                                        value == null ? 'Required' : null,
                                      ),
                                    ),
                                  ],
                                ),
                                TextFormField(
                                  decoration: InputDecoration(labelText: 'CVC'),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(4),
                                  ],
                                  validator: (value) {
                                    if (value!.isEmpty) return 'Required';
                                    if (value.length < 3 || value.length > 4)
                                      return 'Invalid CVC';
                                    return null;
                                  },
                                  onSaved: (value) =>
                                  newCardData['cardCvc'] = value!,
                                ),
                                SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: isSaving ? null : saveNewCard,
                                  child: isSaving
                                      ? CircularProgressIndicator()
                                      : Text('Save New Card'),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(double.infinity, 50),
                                  ),
                                ),
                                SizedBox(height: 8),
                                TextButton(
                                  onPressed: toggleAddNewCard,
                                  child: Text('Cancel'),
                                  style: TextButton.styleFrom(
                                    minimumSize: Size(double.infinity, 50),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  bool _isOrderReady() {

    bool isMissingShipmentOption = controller.cart.value.checkout!.shippingInfo
        .any((info) => !info.isFlatRate && info.selectedRate == 0);
    bool isAddressSelected = controller.cart.value.checkout?.address != null;
    bool isCardSet = controller.cart.value.checkout?.card != null;

    if(isMissingShipmentOption){
      // print('Missing Shipment Option');
      return false;
    }
    if(!isAddressSelected){
      // print('Missing Address');
      return false;
    }
    if(!isCardSet){
      // print('Missing Card');
      return false;
    }

    return  isAddressSelected && isCardSet && !isMissingShipmentOption;
  }


  (Widget, bool) _buildOrderReceipt() {
    bool isMissingShipmentOption = controller.cart.value.checkout!.shippingInfo
        .any((info) => !info.isFlatRate && info.selectedRate == 0);
    bool isOrderReady = _isOrderReady();

    String warningMessage = isMissingShipmentOption
        ? 'Please select a shipment option for all items.'
        : '';

    Widget receiptWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildOrderReceiptItem(
          'Items (${controller.cart.value.numberOfVendorItems!})',
          currencyFormat
              .format(controller.cart.value.checkout!.subtotal! / 100),
        ),
        _buildOrderReceiptItem(
          'Shipping',
          currencyFormat
              .format(controller.cart.value.checkout!.shipping! / 100),
          disclaimer:
          "Cost of shipping will be charged separately from the purchase order on behalf of the manufacturer as it's contingent on shipment details (ship-to location, standard/rush delivery options, etc.). You will receive a separate notification from Y LIFT of the shipment details once the purchase order is finalized.",
          showWarning: isMissingShipmentOption,
          warningMessage: warningMessage,
        ),
        _buildOrderReceiptItem('Tax',
            currencyFormat.format(controller.cart.value.checkout!.tax! / 100),
            disclaimer: 'Tax paid directly to the drop shipper.'),
        _buildOrderReceiptItem(
          'Discounts',
          currencyFormat
              .format(controller.cart.value.checkout!.discount! / 100),
        ),
        Divider(),
        _buildOrderReceiptItem(
          'Order Total:',
          currencyFormat.format((controller.cart.value.checkout!.total) / 100),
        ),
      ],
    );

    return (receiptWidget, isOrderReady);
  }

  Widget _buildOrderReceiptItem(String title, String price,
      {String? disclaimer,
        bool showWarning = false,
        String warningMessage = 'Warning'}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Expanded(
                //   child: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                // ),
                Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 10),
                if (showWarning) _buildWarningIcon(warningMessage),
                if (disclaimer != null) _buildInfoIcon(disclaimer),
              ],
            ),
          ),
          SizedBox(width: 10),
          Text(price, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildInfoIcon(String disclaimer) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(),
      icon: Icon(Icons.info_outline_rounded, color: Colors.blue, size: 16),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Disclaimer'),
              content: Text(disclaimer),
              actions: <Widget>[
                TextButton(
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildWarningIcon(String warningMessage) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(),
      icon: Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 16),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Warning'),
              content: Text(warningMessage),
              actions: <Widget>[
                TextButton(
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _handleShipmentSelection(String title) {
    setState(() {
      var currentShippingInfo =
      controller.cart.value.checkout!.shippingInfo[_currentPage];
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
      for (var shippingInfo in controller.cart.value.checkout!.shippingInfo) {
        totalShipping += shippingInfo.selectedRate * shippingInfo.boxes!;
      }

      // Update the total shipping cost in the checkout
      controller.cart.value.checkout!.shipping = totalShipping;

      // Recalculate the total order cost
      _recalculateTotal();
    });
    print('Selected: $title');
  }

  void _recalculateTotal() {
    int subtotal = controller.cart.value.checkout!.subtotal!;
    int shipping = controller.cart.value.checkout!.shipping!;
    int tax = controller.cart.value.checkout!.tax!;
    int discount = controller.cart.value.checkout!.discount!;

    int total = subtotal + shipping + tax - discount;
    print('Recalculated total: $total');
  }

  Future<void> _placeOrder() async {
    controller.cart.value.checkout!.ready = _buildOrderObject();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProcessingOrderPage(),
      ),
    );
  }

  Map<String, dynamic> _buildOrderObject() {
    List<Map<String, dynamic>> shippingSelections = [];

    // Ensure that checkout and shippingInfo are not null
    if (controller.cart.value.checkout != null &&
        controller.cart.value.checkout!.shippingInfo.isNotEmpty) {
      for (var shippingInfo in controller.cart.value.checkout!.shippingInfo) {
        String shippingType;
        switch (shippingInfo.selectedRate) {
          case 0:
            shippingType = "FLAT_RATE";
            break;
          case var rate when rate == shippingInfo.regularRate:
            shippingType = "REGULAR";
            break;
          case var rate when rate == shippingInfo.expressRate:
            shippingType = "EXPRESS";
            break;
          case var rate when rate == shippingInfo.overnightRate:
            shippingType = "OVERNIGHT";
            break;
          default:
            shippingType = "REGULAR"; // Default to regular if unknown
        }

        Map<String, dynamic> selection = {
          "shippingType": shippingType,
          "totalPrice": shippingInfo.selectedRate * (shippingInfo.boxes ?? 1),
          "boxesAmount": shippingInfo.boxes ?? 1,
        };

        if (shippingInfo.isProduct) {
          selection["productId"] = shippingInfo.id.toString();
        } else {
          selection["vendorId"] = shippingInfo.id.toString();
          // remove boxesAmount from vendor shipping
          selection.remove("boxesAmount"); //1049203854 //1050155220
        }

        shippingSelections.add(selection);
      }
    }

    return {
      "cardId":
      controller.cart.value.checkout?.card?.customerPaymentProfileId ?? "",
      "addressId": controller.cart.value.checkout?.address?.id.toString() ?? "",
      "shippingSelections": shippingSelections,
    };
  }

  Widget _buildShippingPanel() {
    double viewportFraction =
    controller.cart.value.checkout!.shippingInfo.length == 1 ? 1.0 : 0.80;
    return SizedBox(
      height: 240,
      child: PageView.builder(
        controller: PageController(viewportFraction: viewportFraction),
        itemCount: controller.cart.value.checkout!.shippingInfo.length,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        itemBuilder: (context, index) {
          return Card(
            // margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12),
                  Expanded(
                    flex: 1,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(Icons.image,
                                    size: 20, color: Colors.grey[400]),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _formatProductName(controller
                                    .cart.value.checkout!.shippingInfo[index]),
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Boxes required: ${controller.cart.value.checkout!.shippingInfo[index].boxes}', // boxesAmount
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    controller
                        .cart.value.checkout!.shippingInfo[index].isProduct
                        ? 'This product is shipped separately in boxes of at most ${controller.cart.value.checkout!.shippingInfo[index].groupSize}'
                        : 'This vendor ships items in groups of ${controller.cart.value.checkout!.shippingInfo[index].groupSize}',
                    style: TextStyle(
                        fontSize: 10,
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (controller.cart.value.checkout!
                                  .shippingInfo[index].isFlatRate) ...[
                                _buildShippingOption(
                                    'Flat Rate',
                                    currencyFormat.format(controller
                                        .cart
                                        .value
                                        .checkout!
                                        .shippingInfo[index]
                                        .regularRate /
                                        100),
                                    true),
                              ] else ...[
                                // TODO: Implement logic to select shipping option
                                _buildShippingOption(
                                    'Regular Ground',
                                    currencyFormat.format(controller
                                        .cart
                                        .value
                                        .checkout!
                                        .shippingInfo[index]
                                        .regularRate /
                                        100),
                                    (controller.cart.value.checkout!
                                        .shippingInfo[index].selectedRate ==
                                        controller.cart.value.checkout!
                                            .shippingInfo[index].regularRate)),
                                _buildShippingOption(
                                    'Express 2 Days',
                                    currencyFormat.format(controller
                                        .cart
                                        .value
                                        .checkout!
                                        .shippingInfo[index]
                                        .expressRate /
                                        100),
                                    (controller.cart.value.checkout!
                                        .shippingInfo[index].selectedRate ==
                                        controller.cart.value.checkout!
                                            .shippingInfo[index].expressRate)),
                                _buildShippingOption(
                                    'Overnight',
                                    currencyFormat.format(controller
                                        .cart
                                        .value
                                        .checkout!
                                        .shippingInfo[index]
                                        .overnightRate /
                                        100),
                                    (controller.cart.value.checkout!
                                        .shippingInfo[index].selectedRate ==
                                        controller
                                            .cart
                                            .value
                                            .checkout!
                                            .shippingInfo[index]
                                            .overnightRate)),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShippingOption(String title, String price, bool isSelected) {
    return GestureDetector(
      onTap: () {
        _handleShipmentSelection(title);
      },
      child: Container(
        // padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            Radio<bool>(
              value: isSelected,
              groupValue: true,
              onChanged: (bool? value) {
                _handleShipmentSelection(title);
              },
              activeColor: Colors.brown,
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected
                      ? Colors.green
                      : Theme.of(context).colorScheme.onSurface,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            Text(
              price,
              style: TextStyle(
                color: isSelected
                    ? Colors.green
                    : Theme.of(context).colorScheme.onSurface,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
