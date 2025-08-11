import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/components/mobile_scaffold.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:get/get.dart';

class MobileUserProfilePage extends StatefulWidget {
  const MobileUserProfilePage({
    super.key,
  });

  @override
  State<MobileUserProfilePage> createState() => _MobileUserProfilePageState();
}

class _MobileUserProfilePageState extends State<MobileUserProfilePage> {
  final global = Get.find<GlobalController>();
  final controller = UserProfileController();

  bool isLoading = false;

  void updateProfile() async {
    try {
      setState(() {
        isLoading = true;
      });
      final updateUserData = UpdateUserProfile(
        firstName: controller.firstNameController.text,
        lastName: controller.lastNameController.text,
        email: controller.emailController.text,
        phone: controller.phoneController.text,
        practiceName: controller.practiceNameController.text,
      );
      await global.userProfile.updateUserBasicInfo(updateUserData);
      await global.auth.performRefreshToken();
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to update user profile, please try again later.',
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
    controller.assignFrom(global.user.value);
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
      title: 'User Profile',
      onBackPressed: () => Navigator.pop(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                      helperText: '',
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? false) {
                        return 'Enter your first name';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.name,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp("[a-zA-Z ]"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: controller.lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                      helperText: '',
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? false) {
                        return 'Enter your last name';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.name,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp("[a-zA-Z ]"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller.emailController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Email',
                helperText: '',
              ),
              validator: (value) {
                if (value?.isEmpty ?? false) {
                  return 'Enter your email';
                }
                if (!EmailValidator.validate(value!)) {
                  return 'Enter a valid email address';
                }

                return null;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller.phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                helperText: '',
              ),
              validator: (value) {
                if (value?.isEmpty ?? false) {
                  return 'Enter your phone number';
                }
                return null;
              },
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller.practiceNameController,
              decoration: const InputDecoration(
                labelText: 'Name of Practice',
                helperText: '',
              ),
              validator: (value) {
                if (value?.isEmpty ?? false) {
                  return 'Enter your practice name';
                }
                return null;
              },
              keyboardType: TextInputType.name,
            ),
          ],
        ),
      ),
      bottomBar: MobileBar(
        padding: const EdgeInsets.all(16),
        child: GalaxyFilledButton(
          backgroundColor: YLiftColor.orange,
          isExpanded: true,
          onPressed: isLoading ? null : updateProfile,
          child: const Text('Update Profile'),
        ),
      ),
    );
  }
}
