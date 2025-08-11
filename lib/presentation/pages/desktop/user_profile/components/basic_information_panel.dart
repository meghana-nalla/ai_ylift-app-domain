import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/presentation/components/_complex/desktop_view/gap.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import '../../../../../models/urls/api.dart';
import 'package:galaxy_models/galaxy_models.dart';
import '../../../../components/_complex/know_y/knowy_training_image.dart';

class BasicInformationPanel extends StatefulWidget {
  const BasicInformationPanel({super.key});

  @override
  State<BasicInformationPanel> createState() => _BasicInformationPanelState();
}

class _BasicInformationPanelState extends State<BasicInformationPanel> {
  final formKey = GlobalKey<FormState>();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final phoneNumber = TextEditingController();
  final email = TextEditingController();
  final practiceName = TextEditingController();
  final website = TextEditingController();
  // final medicalLicense = TextEditingController();
  // final specialty = TextEditingController();

  void initState() {
    super.initState();
    setInitialValues();
  }

  void setInitialValues() {
    final profile = global.user.value;
    firstName.text = profile.firstName ?? '';
    lastName.text = profile.lastName ?? '';
    phoneNumber.text = profile.phone ?? '';
    email.text = profile.email ?? '';
    practiceName.text = profile.practiceName ?? '';
    // website.text = profile.website ?? '';
    // medicalLicense.text = profile.licenseNumber ?? '';
    // specialty.text = profile.specialty ?? '';
  }

  void updateInformation() async {
    final isFormValid = formKey.currentState!.validate();
    if (!isFormValid) return;

    final user = UpdateUserProfile(
      firstName: firstName.text,
      lastName: lastName.text,
      phone: phoneNumber.text,
      email: email.text,
      practiceName: practiceName.text,
      website: website.text,
      // licenseNumber: medicalLicense.text,
      // specialty: specialty.text,
    );

    try {
      await global.userProfile.updateUserBasicInfo(user);
      // call fresh profile data
      await global.userProfile.fetchProfile();
      print('Profile successfully updated.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully Updated Profile!')
        )
      );
    } catch (e) {
      print("Error occurred while updating profile: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred while updating user profile.'),
            backgroundColor: Colors.red,
          )
      );
    }
  }

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    phoneNumber.dispose();
    email.dispose();
    practiceName.dispose();
    website.dispose();
    // medicalLicense.dispose();
    // specialty.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Basic Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const GapY(),
        Form(
          key: formKey,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    YLiftTextField(
                      labelText: 'First Name*',
                      controller: firstName,
                      hintText: 'Your First Name',
                    ),
                    const GapY(),
                    YLiftTextField(
                      labelText: 'Phone*',
                      controller: phoneNumber,
                      hintText: 'Your Phone Number',
                    ),
                    const GapY(),
                    YLiftTextField(
                      labelText: 'Name of Practice*',
                      controller: practiceName,
                      hintText: 'Your Practice Name',
                    ),
                    const GapY(),
                    // YLiftTextField(
                    //   labelText: 'Medical License',
                    //   controller: medicalLicense,
                    //   hintText: 'Your License Number',
                    // ),
                  ],
                ),
              ),
              const GapX(),
              Expanded(
                child: Column(
                  children: [
                    YLiftTextField(
                      labelText: 'Last Name*',
                      controller: lastName,
                      hintText: 'Your Last Name',
                    ),
                    const GapY(),
                    YLiftTextField(
                      labelText: 'Primary Email*',
                      controller: email,
                      hintText: 'example@example.com',
                    ),
                    const GapY(),
                    YLiftTextField(
                      labelText: 'Website',
                      controller: website,
                      hintText: 'example.com',
                    ),
                    const GapY(),
                    // YLiftTextField(
                    //   controller: specialty,
                    //   labelText: 'Specialty',
                    //   hintText: 'Your specialty',
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const GapY(),
        Center(
          child: YLiftFilledButton(
            onPressed: updateInformation,
            child: const Text('Update Information'),
          ),
        ),
        // const Divider(height: YLiftConstant.gap * 2),
        // ExpansionTile(
        //   title: const Text('Additional Emails & Promotional Preference'),
        // ),
        // ExpansionTile(
        //   title: const Text('Timezone'),
        //   subtitle: Text('California, PDT (Pacific Daylight Time)'),
        // ),
      ],
    );
  }
}
