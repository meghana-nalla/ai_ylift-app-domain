import 'dart:async';

import 'package:YLift/presentation/components/_simple/us_state_dropdown.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/presentation/components/_complex/desktop_view/gap.dart';
import 'package:YLift/presentation/components/_complex/forms/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:galaxy_ui/galaxy_ui.dart';

class AddressForm extends StatefulWidget {
  final AddressSimple? address;
  final FutureOr<void> Function(AddressSimple address) onSubmit;
  final void Function()? onCancel;

  const AddressForm({
    super.key,
    this.address,
    required this.onSubmit,
    this.onCancel,
    required this.controller,
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
      usState = USState.values.firstWhere((element) => element.code == address.state);
      zipCode.text = address.zip;
      phoneNumber.text = address.phone;
      if (address.type != null) {
        setType(address.type!);
      }
    }
    super.initState();
  }

  AddressSimpleType? addressType;
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
        // addressSimple: createNewAddress(),
        // fullName: '${firstName.text} ${lastName.text}',
        // companyName: companyName.text,
          name: '${firstName.text} ${lastName.text}',
          line1: line1.text,
          line2: line2.text,
          country: 'United States',
          city: city.text,
          state: usState!.code,
          zip: zipCode.text,
          // type: addressType,
          isDefault: isDefault,
          // email: email.text,
          phone: phoneNumber.text,
          createdAt: DateTime.now(),
          type: addressType!
      );

      widget.onSubmit(addressTileData);
    } catch (e) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                child: YLiftFilledButton(
                  backgroundColor: const Color(0xFFD1D3D4),
                  onPressed: widget.onCancel,
                  child: const Text('Cancel'),
                ),
              ),
              const GapX(),
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