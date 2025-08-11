import 'package:YLift/presentation/components/_simple/us_state_dropdown.dart';
import 'package:YLift/presentation/components/fields/npi_field.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:YLift/presentation/pages/mobile/account/medical_license/medical_license_type_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:galaxy_models/galaxy_models.dart';

const _licenseTypes = <String>[
  'Physician (MD, DO)',
  'Physician Assistant (PA)',
  'Nurse (RN, NP, LPN)',
  'Dentist (DDS, DMD)',
];

class MedicalLicensePage extends StatefulWidget {
  final void Function(Map<String, dynamic> formData)? onSubmit;
  final String? errorMessage;
  final void Function(String)? onError;

  const MedicalLicensePage({
    super.key,
    this.onSubmit,
    this.errorMessage,
    this.onError,
  });

  @override
  State<MedicalLicensePage> createState() => _MedicalLicensePageState();
}

class _MedicalLicensePageState extends State<MedicalLicensePage>
    with AutomaticKeepAliveClientMixin {
  final _formKey = GlobalKey<FormState>();
  final medicalLicenseController = MedicalLicenseController();

  String? licenseTypeErrorMessage;
  String? errorMessage;

  bool get isFilledOrNot {
    // If all fields are empty, allow skipping
    if (medicalLicenseController.medicalLicenseNumberController.text.isEmpty &&
        medicalLicenseController.state == null &&
        medicalLicenseController.expirationDate == null) {
      return true;
    }

    // Check required fields
    return medicalLicenseController
            .medicalLicenseNumberController
            .text
            .isNotEmpty &&
        medicalLicenseController.state != null &&
        medicalLicenseController.expirationDate != null;
  }

  bool validateForm() {
    bool isFormValid = true;

    if (medicalLicenseController.state == null) {
      stateError = 'Enter your State';
      isFormValid = false;
    }

    final licenseType = medicalLicenseController.licenseTypeController.text;
    if(licenseType.isEmpty){
      licenseTypeErrorMessage = 'Select your license type';
      isFormValid = false;
    }

    final specialty = medicalLicenseController.specialtyController.text;
    if(licenseType != 'Physician Assistant (PA)' && specialty.isEmpty) {
      specialtyError = 'Select your specialty';
      isFormValid = false;
    }

    if (medicalLicenseController.expirationDate == null) {
      expirationError = 'Enter your expiration date';
      isFormValid = false;
    }

    final isFormOk = _formKey.currentState!.validate();
    setState(() {});
    return isFormValid && isFormOk;
  }

  // error states
  String? expirationError;
  String? stateError;
  String? specialtyError;

  void clearErrors() {
    setState(() {
      expirationError = null;
      licenseTypeErrorMessage = null;
      stateError = null;
      specialtyError = null;
    });
  }

  void initializeFields() {
    medicalLicenseController.medicalLicenseNumberController.text = 'A321445';
    medicalLicenseController.expirationDate = DateTime.now().add(
      const Duration(days: 365),
    );
    medicalLicenseController.state = USState.montana;
  }

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      // initializeFields();
    }
  }

  void onNext() async {
    clearErrors();
    if (!validateForm()) return;

    try {
      final payload = medicalLicenseController.toModel().toJson();
      widget.onSubmit?.call(payload);
    } catch (e) {
      print('User attempted to submit a null payload in medical license');
      final Map<String, dynamic> payload = {};
      widget.onSubmit?.call(payload);
    }
  }

  @override
  void dispose() {
    medicalLicenseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                minDate: DateTime.now().add(Duration(days: 7)),
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
            licenseTypeErrorMessage: licenseTypeErrorMessage,
            specialtyErrorMessage: specialtyError,
          ),
          const SizedBox(height: 8),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Drug Enforcement Administration (DEA) #',
              helperText: 'Optional.',
            ),
            controller: medicalLicenseController.deaNumberController,
          ),
          const SizedBox(height: 8),
          NPIField(controller: medicalLicenseController.npiNumberController),
          const SizedBox(height: 32),
          if (widget.errorMessage != null)
            Text(
              widget.errorMessage!,
              style: TextStyle(color: YLiftColor.darkOrange),
            ),
          SizedBox(
            width: double.infinity,
            child: RoundedFilledButton(
              onPressed: onNext,
              child: const Text('Complete Registration'),
            ),
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
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Color(0xFF787878),
                        side: BorderSide(color: YLiftColor.grey3, width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 24),
                      ),
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: const Text('I\'ll Do It Later'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: RoundedFilledButton(
                      color: Color(0xFFFF8C68),
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: const Text('Back To Edit'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const _physicianTypes = <String>[
  'Anesthesiology',
  'Dermatology',
  'Emergency Medicine',
  'ENT / Facial Plastic Surgery',
  'Family Medicine',
  'Internal Medicine',
  'Obstetrics and Gynecology',
  'Ophthalmology / Oculoplastic Surgery',
  'Plastic and Reconstructive Surgery',
  'Maxillofacial Surgery',
  'Urology',
  'Other Specialty',
];

const _nurseTypes = <String>[
  'Certified Nursing Assistant (CNA)',
  'Licensed Practical Nurse (LPN)',
  'Registered Nurse (RN)',
  'Nurse Practitioner (NP)',
  'Advanced Practice Registered Nurse (APRN)',
  'Doctor of Nursing Practice (DNP)',
];

const _dentistTypes = <String>[
  'General Dentist (DDS)',
  'Cosmetic Dentist',
  'Oral & Maxillofacial Surgeon',
  'Other Specialty',
];
