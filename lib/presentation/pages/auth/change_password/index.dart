import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final currentPassword = TextEditingController();
  final newPassword = TextEditingController();
  final confirmPassword = TextEditingController();

  @override
  void dispose() {
    currentPassword.dispose();
    newPassword.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text('Create a new password', style: TextStyle(fontSize: 24)),
          GalaxyPasswordField (
            labelText: 'Current Password',
            controller: currentPassword,
          ),
          GalaxyPasswordField (
            labelText: 'New Password',
            controller: newPassword,
          ),
          GalaxyPasswordField (
            labelText: 'Confirm Password',
            controller: confirmPassword,
          ),
        ],
      ),
    );
  }
}
