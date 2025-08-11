import 'package:flutter/material.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:galaxy_ui/galaxy_ui.dart';

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({super.key});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void setNewPassword() async {
    if (newPasswordController.text != confirmPasswordController.text) {
      return;
    }
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Create a new password', style: TextStyle(fontSize: 24)),
              const GapY(),
              PasswordField(
                labelText: 'New Password',
                controller: newPasswordController,
              ),
              const SizedBox(height: 16),
              PasswordField(
                labelText: 'Confirm Password',
                controller: confirmPasswordController,
              ),
              const GapY(),
              YLiftFilledButton(
                isExpanded: true,
                onPressed: setNewPassword,
                child: const Text('Set new password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
