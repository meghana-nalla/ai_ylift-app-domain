import 'package:YLift/core/constants/color.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/components/_complex/forms/password_field.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final global = Get.find<GlobalController>();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String? message;

  void resetPassword() async {

    // Example link
    // https://ylift.app/reset_password?token=1087111d188a1e24e3036f5e28f6040ed694f0f51457e709c19fbfacb31ab117&email=meg@meg.com
    // global.auth.resetPassword(token: token, email: email, newPassword: newPassword);
    try {
      final token = Get.parameters['token'];
      final email = Get.parameters['email'];
      final newPassword = passwordController.text;
      final confirmPassword = confirmPasswordController.text;
      if (newPassword != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Passwords do not match')));
        return;
      }
      if (token == null || email == null) return;
      await global.auth.resetPassword(
          token: token, email: email, newPassword: newPassword);

      if(!mounted) return;
      setState(() {
        message = 'Password reset successful';
      });

    } catch (e) {
      if(!mounted) return;
      setState(() {
        message = e.toString();
      });
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
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
              Text('Reset Password', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
              const SizedBox(height: 32),
              YLiftPasswordField(
                controller: passwordController,
                // errorText: passwordError,
                // onFieldSubmitted: (password) => signUp,
                showRequirements: true,
              ),
              const SizedBox(height: 16),
              YLiftPasswordField(
                controller: confirmPasswordController,
                labelText: 'Confirm Password',
                validator: (confirmPassword) {
                  if (confirmPassword == null || confirmPassword!.isEmpty) return 'Enter confirm password';
                  final password = passwordController.text;
                  if (confirmPassword != password) {
                    return 'Confirm password does not match';
                  }
                  return null;
                },
                // onFieldSubmitted: (password) => signUp,
                showRequirements: true,
              ),
              if (message != null)...[
                Text(message!, style: TextStyle(color: YLiftColor.orange)),
                const SizedBox(height: 8),
              ],
              YLiftFilledButton(
                backgroundColor: Colors.black,
                isExpanded: true,
                onPressed: resetPassword,
                child: const Text('Reset Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
