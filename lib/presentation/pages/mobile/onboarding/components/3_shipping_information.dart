import 'package:YLift/presentation/components/_simple/us_state_dropdown.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/components/_complex/know_y/knowy_training_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:YLift/presentation/components/_complex/forms/text_form_field.dart';

class ShippingInformationPage extends StatefulWidget {
  final void Function(Map<String, dynamic> formData)? onSubmit;
  final String? errorMessage;
  final void Function(String)? onError;

  const ShippingInformationPage({
    super.key,
    this.onSubmit,
    this.errorMessage,
    this.onError,
  });

  @override
  State<ShippingInformationPage> createState() => _ShippingInformationPageState();
}

class _ShippingInformationPageState extends State<ShippingInformationPage> with AutomaticKeepAliveClientMixin {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.find<GlobalController>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final streetAddressController = TextEditingController();
  final suiteController = TextEditingController();
  final cityController = TextEditingController();
  // final stateController = TextEditingController();
  final zipController = TextEditingController();

  String country = 'United States';
  void setCountry(String? value) {
    if (value == null || value == country) return;
    setState(() {
      country = value;
    });
  }

  USState? usState;

  bool get isCanada => country == 'Canada';

  void initializeFields() {
    firstNameController.text = 'John';
    lastNameController.text = 'Smith';
    phoneController.text = '4065550123';
    streetAddressController.text = '123 Main Street';
    suiteController.text = 'Suite 100';
    cityController.text = 'Helena';
    usState = USState.montana;
    zipController.text = '59601';
  }

  Map<String, dynamic>? payloadFromBackend;

  /// Form validation logic

  String? errorMessage;

  // error states
  String? phoneError;
  String? cityError;
  String? stateError;
  String? zipError;

  void clearErrors() {
    setState(() {
      phoneError = null;
      cityError = null;
      stateError = null;
      zipError = null;
      errorMessage = null;
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

  void onSubmit() {
    final isFormValid = validateForm();
    if (!isFormValid) return;

    final payload = <String, dynamic>{
      "profileId": 0,
      "addressId": 0,
      'name': '${firstNameController.text} ${lastNameController.text}',
      'nameFirst': firstNameController.text,
      'nameLast': lastNameController.text,
      'phone': phoneController.text.replaceAll(RegExp(r'\D'), ''),
      'line1': streetAddressController.text,
      'line2': suiteController.text,
      'city': cityController.text,
      'state': usState!.code,
      'zip': zipController.text,
      'country': 'United States',
      'isSameShipping': sameAsBilling,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      ///Add new Address Type
      /// Dany requested
      /// 02/07
      'type': 'SHIPPING'
    };

    widget.onSubmit?.call(payload);
  }

  bool sameAsBilling = false;

  void toggleSameAsBilling(bool? value) {
    if (value == null) return;

    setState(() {
      sameAsBilling = value;
      sameAsBilling ? assignFieldsFromBilling() : cleanFieldsFromBilling();

    });
  }

  void onFieldChanged(String? value) {
    if (sameAsBilling == true) {
      setState(() {
        sameAsBilling = false;
      });
    }
  }

  void assignFieldsFromBilling() async {
    final payload = global.signUpPayload;
    final billingAddress = payload['billingAddress'] ?? payload['billingSignUpAddress'];
    final names = (billingAddress['name'] as String?)?.split(' ');
    firstNameController.text = names?.first ?? '';
    lastNameController.text = names?.last ?? '';
    streetAddressController.text = billingAddress['line1'] ?? '';
    suiteController.text = billingAddress['line2'] ?? '';
    cityController.text = billingAddress['city'] ?? '';
    // stateController.text = billingAddress['state'] ?? '';
    usState = USState.values.firstWhere((element) => element.code == billingAddress['state']);
    zipController.text = billingAddress['zip'] ?? '';
  }

  void cleanFieldsFromBilling() async {
    firstNameController.clear();
    lastNameController.clear();
    streetAddressController.clear();
    suiteController.clear();
    cityController.clear();
    // stateController.text = billingAddress['state'] ?? '';
    usState = USState.values.first;
    zipController.clear();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    streetAddressController.dispose();
    suiteController.dispose();
    cityController.dispose();
    zipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: YLiftTextFormField(
                  labelText: 'First Name*',
                  controller: firstNameController,
                  validator: (value) {
                    if (value?.isEmpty ?? false) return 'Enter your first name';
                    return null;
                  },
                  onChanged: (value) => onFieldChanged(value),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: YLiftTextFormField(
                  labelText: 'Last Name*',
                  controller: lastNameController,
                  validator: (value) {
                    if (value?.isEmpty ?? false) return 'Enter your last name';
                    return null;
                  },
                  onChanged: (value) => onFieldChanged(value),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Street Address
          YLiftTextFormField(
            labelText: 'Address Line 1*',
            controller: streetAddressController,
            validator: (value) {
              if (value?.isEmpty ?? false) return 'Enter your address line 1';
              return null;
            },
            onChanged: (value) => onFieldChanged(value),
          ),
          const SizedBox(height: 16),

          // Suite Number
          YLiftTextFormField(
            labelText: 'Address Line 2 (Optional)',
            controller: suiteController,
            onChanged: (value) => onFieldChanged(value),
          ),
          const SizedBox(height: 16),
          YLiftTextFormField(
            labelText: 'City*',
            controller: cityController,
            onChanged: (value) => onFieldChanged(value),
            validator: (value) {
              if (value?.isEmpty ?? false) return 'Enter a valid city';
              return null;
            },
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
            ],
          ),
          SizedBox(height: 16,),
          // City, State, and ZIP Code Row
          Row(
            children: [
              Expanded(
                child: UsStateDropdownMenu(
                  value: usState,
                  errorText: stateError,
                  onChanged: (state) {
                    onFieldChanged(state.toString());
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
                  labelText: 'Zip Code*',
                  controller: zipController,
                  maxLength: 5,
                  onChanged: (value) => onFieldChanged(value),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.length < 5) return 'Enter a valid zip code';
                    return null;
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            width: 200,
            child: CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text('Same as billing'),
              value: sameAsBilling,
              onChanged: toggleSameAsBilling,
            ),
          ),
          const SizedBox(height: 32),
          if (widget.errorMessage != null)
            Text(
              widget.errorMessage!,
              style: TextStyle(color: YLiftColor.darkOrange),
            ),
          SizedBox(
            width: double.infinity,
            child: RoundedFilledButton(
              onPressed: onSubmit,
              child: const Text('Proceed to Step 4'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
