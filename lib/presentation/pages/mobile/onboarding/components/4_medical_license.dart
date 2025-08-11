import 'package:YLift/presentation/components/_simple/us_state_dropdown.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
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

class _MedicalLicensePageState extends State<MedicalLicensePage> with AutomaticKeepAliveClientMixin {
  final _formKey = GlobalKey<FormState>();
  final medicalLicenseController = TextEditingController();
  final otherSpecialtyController = TextEditingController();

  final directorFirstName = TextEditingController();
  final directorLastName = TextEditingController();

  bool isDirectorLicense = false;

  DateTime? expirationDate;
  String? errorMessage;

  USState? usState;

  String? licenseType;
  String? _specialty;
  String? get specialty => otherSpecialtyController.text.isNotEmpty ? otherSpecialtyController.text : _specialty;

  bool get isFilledOrNot {
    // If all fields are empty, allow skipping
    if (medicalLicenseController.text.isEmpty &&
        usState == null &&
        licenseType == null &&
        expirationDate == null) {
      return true;
    }

    // Check required fields
    return medicalLicenseController.text.isNotEmpty &&
        usState != null &&
        expirationDate != null &&
        licenseType != null &&
        (licenseType == 'Physician Assistant (PA)' || specialty != null);
  }

  bool validateForm() {
    bool isFormValid = true;
    //Checks that License Type is selected
    if (licenseType == null) {
      licenseError = 'Select your License Type';
      isFormValid = false;
    }

    if (licenseType != null &&
        licenseType != 'Physician Assistant (PA)' &&
        specialty == null) {
      specialtyError = 'Enter your Specialty';
      isFormValid = false;
    }

    if (usState == null) {
      stateError = 'Enter your State';
      isFormValid = false;
    }
    if (expirationDate == null) {
      expirationError = 'Enter your expiration date';
      isFormValid = false;
    }
    final isFormOk = _formKey.currentState!.validate();
    setState(() {});
    return isFormValid && isFormOk;
  }

  // error states
  String? licenseError;
  String? expirationError;
  String? stateError;
  String? specialtyError;

  void clearErrors() {
    setState(() {
      licenseError = null;
      expirationError = null;
      stateError = null;
      specialtyError = null;
    });
  }
  void initializeFields() {
    medicalLicenseController.text = 'A321445';
    expirationDate = DateTime.now().add(const Duration(days: 365));
    usState = USState.montana;
  }

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      initializeFields();
    }
  }

  void onNext() async {
    if (!validateForm()) return;

    try {
      final payload = <String, dynamic>{
        'licenseNumber': medicalLicenseController.text,
        // 'expirationDate': '${expirationDate!.month}/${expirationDate!.day}/${expirationDate!.year}',
        'expirationDate': expirationDate.toString(),
        'country': "United States",
        'state': usState!.code,
        if (licenseType != 'Physician Assistant (PA)') 'name': _specialty,
        'directorLicense': isDirectorLicense,
        if (isDirectorLicense) 'directorFirstName': directorFirstName.text,
        if (isDirectorLicense) 'directorLastName': directorLastName.text,
        if (licenseType != null) 'licenseType': licenseType,
        if (licenseType != 'Physician Assistant (PA)' && specialty != null) 'specialty': specialty,
      };
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
    otherSpecialtyController.dispose();
    directorFirstName.dispose();
    directorLastName.dispose();
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
            controller: medicalLicenseController,
            decoration: const InputDecoration(
              labelText: 'Medical License #',
              helperText: '',
            ),
            validator: (value) => value?.isEmpty ?? false ? 'Enter your medical license #' : null,
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Radio(
                    value: false,
                    groupValue: isDirectorLicense,
                    onChanged: (value) {
                      setState(() {
                        isDirectorLicense = false;
                      });
                    },
                  ),
                  Text('This is my license'),
                ],
              ),

              const SizedBox(height: 16),
              Row(
                children: [
                  Radio(
                    value: true,
                    groupValue: isDirectorLicense,
                    onChanged: (value) {
                      setState(() {
                        isDirectorLicense = true;
                      });
                    },
                  ),
                  Text('My medical director\'s license'),
                ],
              ),

            ],
          ),
          const Divider(height: 64),
          if (isDirectorLicense) ...[
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: directorFirstName,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      labelText: 'Medical Director First Name',
                      helperText: '',
                    ),
                    validator: (value) => value?.isEmpty ?? false ? 'Enter your medical director first name' : null,
                  ),
                ),


              ],
            ),
            const SizedBox(width: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: directorLastName,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      labelText: 'Medical Director Last Name',
                      helperText: '',
                    ),
                    validator: (value) => value?.isEmpty ?? false ? 'Enter your medical director last name' : null,
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
                date: expirationDate,
                onSelected: (date) {
                  setState(() {
                    expirationDate = date;
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
            value: usState,
            onChanged: (state) {
              setState(() {
                usState = state;
                stateError = null;
              });
            },
            errorText: stateError,
          ),
          const SizedBox(height: 16),
          GenericDropdown(
            items: _licenseTypes,
            value: licenseType,
            onSelected: (license) {
              setState(() {
                // TODO : AIDEN FIX THIS LONG TIME ERROR
                licenseType = license;
                licenseError = null;
                _specialty = null;
              });
            },
            label: 'License Type*',
            hintText: 'Select a license type',
            errorText: licenseError
          ),
          const SizedBox(height: 16),
          if (licenseType == 'Physician (MD, DO)')
            YLiftDropdownMenu<String>(
              labelText: 'Specialty',
              list: _physicianTypes,
              onSelected: (value) {
                setState(() {
                  _specialty = value;
                });
              },
              errorMessage: specialtyError,
            )
          else if (licenseType == 'Nurse (RN, NP, LPN)')
            YLiftDropdownMenu(
              labelText: 'Specialty',
              list: _nurseTypes,
              onSelected: (value) {
                setState(() {
                  _specialty = value;
                });
              },
              errorMessage: specialtyError,
            )
          else if (licenseType == 'Dentist (DDS, DMD)')
            YLiftDropdownMenu(
              labelText: 'Specialty',
              list: _dentistTypes,
              onSelected: (value) {
                setState(() {
                  _specialty = value;
                });
              },
              errorMessage: specialtyError,
            ),
          if (_specialty == 'Other Specialty') ...[
            const SizedBox(height: 16),
            TextFormField(
              controller: otherSpecialtyController,
              decoration: InputDecoration(
                labelText: 'Provide Specialty',
                hintText: 'Specialty here',
                helperText: '',
              ),
              validator: (value) {
                if (_specialty == 'Other Specialty') {
                  if (value == null || value.isEmpty) {
                    return 'Please enter other Specialty';
                  }
                }
                return null;
              }
            ),
          ],
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
                child: const Text('Complete Registration')),
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
              Text('Some medical license information is missing. Complete it to unlock products.'),
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
              )
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