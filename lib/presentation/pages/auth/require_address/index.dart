import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/components/_simple/us_state_dropdown.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/presentation/components/_complex/know_y/knowy_training_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/presentation/components/_complex/forms/text_form_field.dart';

class RequireAddressPage extends StatefulWidget {
  final String? errorMessage;
  final void Function(String)? onError;

  const RequireAddressPage({super.key, this.errorMessage, this.onError});

  @override
  State<RequireAddressPage> createState() => _RequireAddressPageState();
}

class _RequireAddressPageState extends State<RequireAddressPage> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.find<GlobalController>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final streetAddressController = TextEditingController();
  final suiteController = TextEditingController();
  final cityController = TextEditingController();
  final zipController = TextEditingController();
  USState? usState;

  bool isAddingAddress = false;

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

  void onSubmit() async {
    try {
      setState(() {
        isAddingAddress = true;
      });

      final isFormValid = validateForm();
      if (!isFormValid) return;

      final shippingAddress = AddressSimple(
        profileId: '${global.user.value.profileId}',
        name: '${firstNameController.text} ${lastNameController.text}',
        line1: streetAddressController.text,
        line2: suiteController.text.isNotEmpty ? suiteController.text : null,
        city: cityController.text,
        state: usState!.code,
        zip: zipController.text,
        phone: phoneController.text,
        country: 'United States',
        isDefault: true,
        type: AddressSimpleType.SHIPPING,
        createdAt: DateTime.now(),
      );

      final billingAddress = AddressSimple(
        profileId: '${global.user.value.profileId}',
        name: '${firstNameController.text} ${lastNameController.text}',
        line1: streetAddressController.text,
        line2: suiteController.text.isNotEmpty ? suiteController.text : null,
        city: cityController.text,
        state: usState!.code,
        zip: zipController.text,
        phone: phoneController.text,
        country: 'United States',
        isDefault: true,
        type: AddressSimpleType.BILLING,
        createdAt: DateTime.now(),
      );

      await global.addressBook.addAddress(shippingAddress);
      await global.addressBook.addAddress(billingAddress);
      var response = await global.userProfile.fetchProfile();
      if (response.statusCode == 200) {
        global.vroute.navigateTo('/shop');
      } else {
        errorMessage = response.errorMessage;
      }
    } catch (e) {
      print('$e');
    } finally {
      setState(() {
        isAddingAddress = false;
      });
    }
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
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Column(
                  children: [
                    SizedBox(
                      width: 640,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Address Required', style: TextStyle(fontSize: 23)),
                            Text(
                              'Before accessing Y Lift Store, your account needs to have an address',
                              style: TextStyle(fontSize: 13.33),
                            ),
                            const SizedBox(height: 32),
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
                                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))],
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
                                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))],
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
                            ),
                            const SizedBox(height: 16),

                            // Suite Number
                            YLiftTextFormField(labelText: 'Address Line 2 (Optional)', controller: suiteController),
                            const SizedBox(height: 16),

                            // City, State, and ZIP Code Row
                            Row(
                              children: [
                                Expanded(
                                  child: YLiftTextFormField(
                                    labelText: 'City*',
                                    controller: cityController,
                                    validator: (value) {
                                      if (value?.isEmpty ?? false) return 'Enter a valid city';
                                      return null;
                                    },
                                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))],
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
                                    labelText: 'Zip Code*',
                                    controller: zipController,
                                    maxLength: 5,
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value!.length < 5) return 'Enter a valid zip code';
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            // SizedBox(
                            //   width: 200,
                            //   child: CheckboxListTile(
                            //     contentPadding: EdgeInsets.zero,
                            //     controlAffinity: ListTileControlAffinity.leading,
                            //     title: const Text('Same as billing'),
                            //     value: sameAsBilling,
                            //     onChanged: toggleSameAsBilling,
                            //   ),
                            // ),
                            const SizedBox(height: 32),
                            if (widget.errorMessage != null)
                              Text(widget.errorMessage!, style: TextStyle(color: YLiftColor.darkOrange)),
                            SizedBox(
                              width: double.infinity,
                              child: RoundedFilledButton(
                                onPressed: isAddingAddress ? null : onSubmit,
                                child: const Text('Add address'),
                              ),
                            ),
                            if (global.isAuthenticated.value) ...[
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () {
                                    global.auth.processLogout();
                                  },
                                  child: const Text('Log out'),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildHeader() {
  return ColoredBox(
    color: Colors.black,
    child: SizedBox(
      height: 54,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Y LIFT STORE', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    ),
  );
}
