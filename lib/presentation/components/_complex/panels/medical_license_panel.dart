import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/components/_simple/us_state_dropdown.dart';
import 'package:YLift/presentation/components/fields/npi_field.dart';
import 'package:YLift/presentation/pages/mobile/account/medical_license/medical_license_type_field.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:get/get.dart';

class MedicalLicensePanel extends StatefulWidget {
  const MedicalLicensePanel({
    super.key,
  });

  @override
  State<MedicalLicensePanel> createState() => _MedicalLicensePanelState();
}

class _MedicalLicensePanelState extends State<MedicalLicensePanel>
    with AutomaticKeepAliveClientMixin {
  final _formKey = GlobalKey<FormState>();
  final global = Get.find<GlobalController>();

  final medicalLicenseController = MedicalLicenseController();

  String? errorMessage;

  // error states
  String? licenseError;
  String? expirationError;
  String? stateError;
  String? specialtyError;

  bool validateForm() {
    bool isFormValid = true;

    if (medicalLicenseController.licenseTypeController.text.isNotEmpty &&
        medicalLicenseController.licenseTypeController.text !=
            'Physician Assistant (PA)' &&
        medicalLicenseController.specialtyController.text.isEmpty) {
      specialtyError = 'Enter your specialty';
      isFormValid = false;
    }
    if (medicalLicenseController.state == null) {
      stateError = 'Enter your state';
      isFormValid = false;
    }
    if (medicalLicenseController.expirationDate == null) {
      expirationError = 'Enter your expiration date';
      isFormValid = false;
    }
    setState(() {});
    return isFormValid;
  }

  void clearErrors() {
    setState(() {
      licenseError = null;
      expirationError = null;
      stateError = null;
      specialtyError = null;
    });
  }

  void setInitialValues() {
    final specialtyObject = global.user.value.specialty as MedicalLicense?;
    if (specialtyObject != null) {
      medicalLicenseController.fromData(specialtyObject);
    }
  }

  void onNext() async {
    try {
      final isFormValid = _formKey.currentState!.validate();
      if (!isFormValid) return;
      final license = medicalLicenseController.toModel();
      final msg = await global.userProfile.updateUserMedicalLicense(license);

      if (msg == 'Successfully updated medical license') {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));
        await global.userProfile.fetchProfile();
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'An error occurred while updating medical license info',
          ),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      print('An error occurred in MedicalLicensePanel.onNext(): $e');
    }
  }

  @override
  void initState() {
    super.initState();
    setInitialValues();
  }

  @override
  void dispose() {
    medicalLicenseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (global.isUserNonMedical) {
      return Center(
        child: SelectionArea(
          child: Column(
            children: [
              const SizedBox(height: 64),
              Text('Your account is not associated with any medical license.'),
              const SizedBox(height: 16),
              Text(
                'If you have a medical license, please contact info@ylift.com to or call +1 (212) 861-7787 update your account.',
              ),
            ],
          ),
        ),
      );
    }

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: medicalLicenseController.medicalLicenseNumberController,
            decoration: const InputDecoration(
              labelText: 'Medical License #',
              helperText: '',
            ),
            validator:
                (value) =>
                    value?.isEmpty ?? false
                        ? 'Enter your medical license #'
                        : null,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Radio(
                value: false,
                groupValue: medicalLicenseController.isDirectorsLicense,
                onChanged: (value) {
                  setState(() {
                    medicalLicenseController.isDirectorsLicense = false;
                  });
                },
              ),
              Text('This is my license'),
              const SizedBox(width: 32),
              Radio(
                value: true,
                groupValue: medicalLicenseController.isDirectorsLicense,
                onChanged: (value) {
                  setState(() {
                    medicalLicenseController.isDirectorsLicense = true;
                  });
                },
              ),
              Text('My medical director\'s license'),
            ],
          ),
          const Divider(height: 64),
          if (medicalLicenseController.isDirectorsLicense) ...[
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller:
                        medicalLicenseController.directorFirstNameController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      labelText: 'Medical Director First Name',
                      helperText: '',
                    ),
                    validator:
                        (value) =>
                            value?.isEmpty ?? false
                                ? 'Enter your medical director first name'
                                : null,
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: TextFormField(
                    controller:
                        medicalLicenseController.directorLastNameController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      labelText: 'Medical Director Last Name',
                      helperText: '',
                    ),
                    validator:
                        (value) =>
                            value?.isEmpty ?? false
                                ? 'Enter your medical director last name'
                                : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GalaxyDateField(
                date: medicalLicenseController.expirationDate,
                onSelected: (date) {
                  setState(() {
                    medicalLicenseController.expirationDate = date;
                    if (expirationError != null) {
                      expirationError = null;
                    }
                  });
                },
                errorText: expirationError,
              ),
            ],
          ),
          const SizedBox(height: 16),
          UsStateDropdownMenu(
            value: medicalLicenseController.state,
            onChanged: (state) {
              setState(() {
                medicalLicenseController.state = state;
                stateError = null;
              });
            },
            errorText: stateError,
          ),
          const SizedBox(height: 16),
          MedicalLicenseTypeField(
            licenseTypeController:
                medicalLicenseController.licenseTypeController,
            specialtyController: medicalLicenseController.specialtyController,
            otherSpecialtyController:
                medicalLicenseController.otherSpecialtyController,
          ),
          const SizedBox(height: 8),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Drug Enforcement Administration (DEA) #',
              helperText: '',
            ),
            controller: medicalLicenseController.deaNumberController,
          ),
          const SizedBox(height: 8),
          NPIField(controller: medicalLicenseController.npiNumberController),
          const SizedBox(height: 32),
          if (errorMessage != null)
            Text(
              errorMessage!,
              style: TextStyle(color: YLiftColor.darkOrange),
            ),
          GalaxyFilledButton(
            backgroundColor: Colors.black,
            onPressed: onNext,
            child: const Text('Update Medical License'),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _MissingInformationDialog extends StatelessWidget {
  const _MissingInformationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          width: 640,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info, color: Color(0xFFFF3D00)),
                  const SizedBox(width: 16),
                  Text('Missing Information', style: TextStyle(fontSize: 24)),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Some medical license information is missing. Complete it to unlock products.',
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 50,
                width: 200,
                child: RoundedFilledButton(
                  color: Color(0xFFFF8C68),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
