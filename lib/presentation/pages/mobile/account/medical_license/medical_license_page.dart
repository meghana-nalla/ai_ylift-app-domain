import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/components/fields/npi_field.dart';
import 'package:YLift/presentation/components/mobile_scaffold.dart';
import 'package:YLift/presentation/pages/mobile/account/medical_license/medical_license_type_field.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:get/get.dart';

class MobileMedicalLicensePage extends StatefulWidget {
  const MobileMedicalLicensePage({super.key});

  @override
  State<MobileMedicalLicensePage> createState() =>
      _MobileMedicalLicensePageState();
}

class _MobileMedicalLicensePageState extends State<MobileMedicalLicensePage> {
  final global = Get.find<GlobalController>();
  final controller = MedicalLicenseController();
  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  final expirationDateController = TextEditingController();

  String? stateErrorMessage;
  String? specialtyErrorMessage;

  DateTime? parseTextToDate(String text) {
    final parsedDate = DateTime.tryParse(text);

    if (parsedDate == null) {
      final values = text.split('/');
      if (values.length != 3) return null;
      try {
        return DateTime(
          int.parse(values[2]),
          int.parse(values[0]),
          int.parse(values[1]),
        );
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  void pickDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2200),
      initialDate: parseTextToDate(expirationDateController.text),
    );
    if (selectedDate != null) {
      setState(() {
        expirationDateController.text = selectedDate.format('yMd');
      });
    }
  }

  bool validateForm() {
    bool isValid = true;
    if (controller.state == null) {
      setState(() {
        stateErrorMessage = 'Select a state';
      });
      isValid = false;
    }

    final isPhysicianAssistant =
        controller.licenseTypeController.text == 'Physician Assistant (PA)';

    if (!isPhysicianAssistant && controller.specialtyController.text.isEmpty) {
      setState(() {
        specialtyErrorMessage = 'Select your specialty';
      });
      isValid = false;
    }
    return isValid && formKey.currentState!.validate();
  }

  void updateMedicalLicense() async {
    try {
      setState(() {
        isLoading = true;
      });
      final isFormValid = validateForm();
      if (!isFormValid) return;

      final medicalLicense = controller.toModel();
      await global.userProfile.updateUserMedicalLicense(medicalLicense);
      await global.userProfile.fetchProfile();
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to update medical license, please try again later.',
          ),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    final medicalLicense = global.user.value.medicalLicense;
    if (medicalLicense != null) {
      controller.fromData(medicalLicense);
      expirationDateController.text =
          medicalLicense.expirationDate?.format(
            'yMd',
          ) ??
          '';
    }
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MobileScaffold(
      title: 'Medical License',
      onBackPressed: () => Navigator.pop(context),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NameField(
                controller: controller.medicalLicenseNumberController,
                labelText: 'Medical License Number',
                isRequired: true,
              ),
              const SizedBox(height: 8),

              Row(
                spacing: 16,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        controller.isDirectorsLicense = false;
                      });
                    },
                    child: Row(
                      spacing: 8,
                      children: [
                        getRadioIcon(!controller.isDirectorsLicense),
                        const Text(
                          'My license',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        controller.isDirectorsLicense = true;
                      });
                    },
                    child: Row(
                      spacing: 8,
                      children: [
                        getRadioIcon(controller.isDirectorsLicense),
                        const Text(
                          'My director\'s license',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (controller.isDirectorsLicense) ...[
                Row(
                  children: [
                    Expanded(
                      child: NameField(
                        controller: controller.directorFirstNameController,
                        labelText: 'Director\'s First Name',
                        isRequired: true,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: NameField(
                        controller: controller.directorLastNameController,
                        labelText: 'Director\'s Last Name',
                        isRequired: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
              TextFormField(
                controller: expirationDateController,
                onTap: pickDate,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'License Expiry Date',
                  suffixIcon: const Icon(Icons.calendar_today),
                  helperText: '',
                ),
              ),
              const SizedBox(height: 8),
              DropdownMenu(
                // controller: addressController.stateController,
                menuHeight: 320,
                initialSelection: controller.state,
                expandedInsets: EdgeInsets.zero,
                label: const Text('State'),
                dropdownMenuEntries:
                    USState.values.map(
                      (e) {
                        return DropdownMenuEntry(
                          value: e,
                          label: e.label,
                        );
                      },
                    ).toList(),
                helperText: '',
                onSelected: (value) {
                  setState(() {
                    controller.state = value;
                  });
                },
                // errorText: stateErrorMessage,
              ),
              const SizedBox(height: 8),
              MedicalLicenseTypeField(
                licenseTypeController: controller.licenseTypeController,
                specialtyController: controller.specialtyController,
                otherSpecialtyController: controller.otherSpecialtyController,
                specialtyErrorMessage: specialtyErrorMessage,
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Drug Enforcement Administration (DEA) #',
                  helperText: 'Optional.',
                ),
                controller: controller.deaNumberController,
              ),
              const SizedBox(height: 8),
              NPIField(controller: controller.npiNumberController),
            ],
          ),
        ),
      ),
      bottomBar: MobileBar(
        padding: const EdgeInsets.all(16),
        child: GalaxyFilledButton(
          backgroundColor: YLiftColor.orange,
          isExpanded: true,
          onPressed: isLoading ? null : updateMedicalLicense,
          child: const Text('Update Medical License'),
        ),
      ),
    );
  }

  Widget getRadioIcon(bool isSelected) {
    if (isSelected) {
      return const Icon(
        Icons.radio_button_checked,
        color: YLiftColor.orange,
        size: 20,
      );
    } else {
      return const Icon(
        Icons.radio_button_unchecked,
        color: Colors.black,
        size: 20,
      );
    }
  }
}
