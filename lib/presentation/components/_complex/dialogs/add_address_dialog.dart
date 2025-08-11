import 'dart:async';
import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/presentation/components/_simple/us_state_dropdown.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:galaxy_models/galaxy_models.dart';

/*
*
* This form handles user address creation from the checkout page
* (and potentially other pages in the future)
* */

class AddAddressDialog extends StatelessWidget {
  const AddAddressDialog({
    super.key,
    // required this.controller,
    required this.onAdd,
    this.onAddressCreated,
    this.isFromProfile = false,
  });

  // final GlobalController controller;
  final bool isFromProfile;
  final FutureOr<void> Function(AddressSimple addressSimple) onAdd;
  final void Function(AddressSimple address)? onAddressCreated;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: const Border(),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(YLiftConstant.gap),
          child: SizedBox(
            width: 800,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Add Address', style: TextStyle(fontSize: 24)),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.clear),
                    ),
                  ],
                ),
                const Divider(height: YLiftConstant.gap * 2),
                AddressForm(
                  isFromBilling: isFromProfile,
                  controller: Get.find<GlobalController>(),
                  onCancel: () {
                    Navigator.pop(context);
                  },
                  onSubmit: (address) async {
                    // TODO: add input validation for address
                    await onAdd(address);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddressForm extends StatefulWidget {
  final bool isFromBilling;
  final AddressSimple? address;
  final FutureOr<void> Function(AddressSimple address) onSubmit;
  final void Function()? onCancel;

  const AddressForm({
    super.key,
    this.address,
    required this.onSubmit,
    this.onCancel,
    required this.controller,
    this.isFromBilling = false,
    // this.onAddressCreated,
  });

  final GlobalController controller;
  // final void Function(Address address)? onAddressCreated;

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  final _formKey = GlobalKey<FormState>();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final companyName = TextEditingController();
  final line1 = TextEditingController();
  final line2 = TextEditingController();
  final city = TextEditingController();
  final zipCode = TextEditingController();
  final phoneNumber = TextEditingController();
  final email = TextEditingController();

  USState? usState;

  String? stateError;

  String? errorMessage;
  AddressSimpleType addressType = AddressSimpleType.SHIPPING;

  @override
  void initState() {
    final address = widget.address;
    if (address != null) {
      final names = address.name.split(' ');
      firstName.text = names.first;
      lastName.text = names.last;
      line1.text = address.line1 ?? '';
      line2.text = address.line2 ?? '';
      city.text = address.city;
      usState = USState.fromJson(address.state);
      zipCode.text = address.zip;
      phoneNumber.text = address.phone;
      if (address.type != null) {
        setType(address.type!);
      }
    }
    super.initState();
  }

  void setType(AddressSimpleType type) {
    setState(() {
      addressType = type;
    });
  }

  bool isDefault = false;

  void toggleDefault(bool? value) {
    if (value == null) return;
    setState(() {
      isDefault = value;
    });
  }

  bool validateForm() {
    bool otherForm = true;

    if (usState == null) {
      stateError = 'Select a state';
      otherForm = false;
    }
    final isFormValid = _formKey.currentState!.validate();
    setState(() {});

    return otherForm && isFormValid;
  }

  // create the address object that gets saved to the user profile
  AddressSimple createNewAddress() {
    try {
      final GlobalController global = Get.find<GlobalController>();
      final AddressSimple address = AddressSimple(
          name: '${firstName.text} ${lastName.text}',
          line1: line1.text,
          line2: (line2.text.isNotEmpty) ? line2.text : null,
          city: city.text,
          state: usState!.code,
          zip: zipCode.text,
          profileId: global.user.value.profileId.toString(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          phone: phoneNumber.text,
          isDefault: isDefault,
          type: addressType
      );
      return address;
    } catch (e) {
      throw ('Error in add_address_dialog:createNewAddress() $e');
    }
  }

  String? _validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an address';
    }
    return null;
  }

  void submit() {
    try {
      final isFormValid = validateForm();
      if (!isFormValid) return;

      // a custom data object to render page data
      final addressTileData = AddressSimple(
        name: '${firstName.text} ${lastName.text}',
        line1: line1.text,
        line2: line2.text,
        country: 'United States',
        city: city.text,
        state: usState!.code,
        zip: zipCode.text,
        isDefault: isDefault,
        // email: email.text,
        phone: phoneNumber.text,
          createdAt: DateTime.now(),
        type: addressType
      );

      widget.onSubmit(addressTileData);
    } catch (e, s) {
      print('$e\n$s');
      setState(() {
        errorMessage = '$e';
      });
    }
  }

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    companyName.dispose();
    line1.dispose();
    line2.dispose();
    city.dispose();
    zipCode.dispose();
    phoneNumber.dispose();
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: YLiftTextFormField(
                  labelText: 'First Name',
                  controller: firstName,
                  validator: (value) {
                    if (value?.isEmpty ?? false) return 'Enter your first name';
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: YLiftTextFormField(
                  labelText: 'Last Name',
                  controller: lastName,
                  validator: (value) {
                    if (value?.isEmpty ?? false) return 'Enter your last name';
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                  ],
                ),
              ),
            ],
          ),
          // Street Address
          YLiftTextFormField(
            labelText: 'Address Line 1',
            controller: line1,
            validator: _validateAddress,
            keyboardType: TextInputType.streetAddress,
            // validator: (value) {
            //   if (value?.isEmpty ?? false) return 'Enter your address line 1';
            //   return null;
            // },
          ),
          const SizedBox(height: 16),

          // Suite Number
          YLiftTextFormField(
            labelText: 'Address Line 2 (Optional)',
            controller: line2,
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: YLiftTextFormField(
                  labelText: 'City',
                  controller: city,
                  validator: (value) {
                    if (value?.isEmpty ?? false) return 'Enter a valid city';
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: UsStateDropdownMenu(
                  value: usState,
                  errorText: stateError,
                  onChanged: (state) {
                    setState(() {
                      usState = state;
                      stateError = null;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: YLiftTextFormField(
                  labelText: 'Zip Code',
                  controller: zipCode,
                  maxLength: 5,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value!.length < 5) return 'Enter a valid zip code';
                    return null;
                  },
                ),
              ),
            ],
          ),
          // const SizedBox(height: 16),
          // Row(
          //   children: [
          //     Expanded(
          //       child: YLiftTextField(
          //         labelText: 'Phone',
          //         controller: phoneNumber,
          //         hintText: 'Phone',
          //       ),
          //     ),
          //     const GapX(),
          //     Expanded(
          //       child: EmailField(
          //         controller: email,
          //       ),
          //     ),
          //   ],
          // ),
          if (widget.isFromBilling)...[
            const GapY(),
            const Text('Address Type', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            OverflowBar(
              alignment: MainAxisAlignment.start,
              spacing: YLiftConstant.gap,
              overflowSpacing: 16,
              children: List.generate(
                AddressSimpleType.values.length,
                (index) {
                  final type = AddressSimpleType.values[index];

                  return OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: type == addressType ? YLiftColor.orange : null,
                      overlayColor: YLiftColor.orange,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      side: const BorderSide(color: Colors.grey, width: 1),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      foregroundColor: YLiftColor.softBlack,
                    ),
                    onPressed: () => setType(type),
                    child: Text(type.name, style:
                      TextStyle(
                        color: type == addressType ? Colors.white : null
                      ),),
                  );
                },
              ),
            ),
          ],
          const GapY(),
          Row(
            children: [
              Checkbox(
                value: isDefault,
                onChanged: toggleDefault,
                activeColor: YLiftColor.brown,
              ),
              const Text('Set this as my default address')
            ],
          ),
          if (errorMessage != null)
            Text(
              errorMessage!,
              style: TextStyle(color: YLiftColor.orange, fontSize: 11.11),
            ),
          const GapY(),
          OverflowBar(
            alignment: MainAxisAlignment.center,
            spacing: 25,
            overflowSpacing: 8,
            children: [
              SizedBox(
                width: 200,
                child: YLiftFilledButton(
                  backgroundColor: const Color(0xFFD1D3D4),
                  onPressed: widget.onCancel,
                  child: const Text('Cancel'),
                ),
              ),
              SizedBox(
                width: 200,
                child: YLiftFilledButton(
                  onPressed: submit,
                  child: const Text('Submit'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
