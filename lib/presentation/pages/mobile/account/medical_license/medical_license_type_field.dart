import 'package:flutter/material.dart';
import 'package:galaxy_ui/galaxy_ui.dart';

class MedicalLicenseTypeField extends StatelessWidget {
  final TextEditingController licenseTypeController;
  final TextEditingController specialtyController;
  final TextEditingController otherSpecialtyController;

  final String? licenseTypeErrorMessage;
  final String? specialtyErrorMessage;

  const MedicalLicenseTypeField({
    super.key,
    required this.licenseTypeController,
    required this.specialtyController,
    required this.otherSpecialtyController,
    this.licenseTypeErrorMessage,
    this.specialtyErrorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: licenseTypeController,
      builder: (context, value, child) {
        return Column(
          children: [
            DropdownMenu(
              controller: licenseTypeController,
              enableSearch: false,
              requestFocusOnTap: false,
              label: Text('License Type'),
              expandedInsets: EdgeInsets.zero,
              menuHeight: 320,
              dropdownMenuEntries: _licenseTypes
                  .map(
                    (licenseType) {
                      return DropdownMenuEntry(
                        value: licenseType,
                        label: licenseType,
                      );
                    },
                  )
                  .toList(growable: false),
              helperText: '',
              errorText: licenseTypeErrorMessage,
            ),
            const SizedBox(height: 8),
            if (value.text == 'Physician (MD, DO)')
              DropdownMenu<String>(
                controller: specialtyController,
                label: Text('Specialty'),
                enableSearch: false,
                requestFocusOnTap: false,
                expandedInsets: EdgeInsets.zero,
                menuHeight: 320,
                dropdownMenuEntries: _physicianTypes
                    .map(
                      (specialty) {
                        return DropdownMenuEntry(
                          value: specialty,
                          label: specialty,
                        );
                      },
                    )
                    .toList(growable: false),
                helperText: '',
                errorText: specialtyErrorMessage,
              )
            else if (value.text == 'Nurse (RN, NP, LPN)')
              DropdownMenu<String>(
                controller: specialtyController,
                label: Text('Specialty'),
                enableSearch: false,
                requestFocusOnTap: false,
                expandedInsets: EdgeInsets.zero,
                menuHeight: 320,

                dropdownMenuEntries: _nurseTypes
                    .map(
                      (specialty) {
                        return DropdownMenuEntry(
                          value: specialty,
                          label: specialty,
                        );
                      },
                    )
                    .toList(growable: false),
                helperText: '',
                errorText: specialtyErrorMessage,
              )
            else if (value.text == 'Dentist (DDS, DMD)')
              DropdownMenu<String>(
                controller: specialtyController,
                enableSearch: false,
                requestFocusOnTap: false,
                label: Text('Specialty'),
                expandedInsets: EdgeInsets.zero,
                menuHeight: 320,

                dropdownMenuEntries: _dentistTypes
                    .map(
                      (specialty) {
                        return DropdownMenuEntry(
                          value: specialty,
                          label: specialty,
                        );
                      },
                    )
                    .toList(growable: false),
                helperText: '',
                errorText: specialtyErrorMessage,
              ),
            ValueListenableBuilder(
              valueListenable: specialtyController,
              builder: (context, value, child) {
                if (value.text == 'Other Specialty') {
                  return Column(
                    children: [
                      const SizedBox(height: 16),
                      NameField(
                        controller: otherSpecialtyController,
                        labelText: 'Provide Specialty',
                        isRequired: true,
                      ),
                      // TextFormField(
                      //   controller: otherSpecialtyController,
                      //   decoration: InputDecoration(
                      //     labelText: 'Provide Specialty',
                      //     hintText: 'Specialty here',
                      //     helperText: '',
                      //   ),
                      //   validator: (value) {
                      //
                      //   },
                      // ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        );
      },
    );
  }
}

const _licenseTypes = <String>[
  'Physician (MD, DO)',
  'Physician Assistant (PA)',
  'Nurse (RN, NP, LPN)',
  'Dentist (DDS, DMD)',
];

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
