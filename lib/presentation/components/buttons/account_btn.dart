import 'package:YLift/core/controllers/z-index_export.dart';
import 'package:YLift/presentation/components/_complex/dialogs/alert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
class AccountButton extends StatefulWidget {
  const AccountButton({super.key});

  @override
  State<AccountButton> createState() => _AccountButtonState();
}

class _AccountButtonState extends State<AccountButton> {
  final controller = Get.find<GlobalController>();
  final menuController = MenuController();
  bool showMenu = false;

  void toggleMenu() {
    if (menuController.isOpen) {
      menuController.close();
    } else {
      menuController.open(position: const Offset(-200, 54));
    }
  }

  void logIn() {
    // controller.auth.legacyLogIn();
    controller.vroute.navigateTo('/login');
    menuController.close();
  }

  @override
  void initState() {
    super.initState();
  }

  void signUp() async {
    // controller.auth.legacyLogIn();
    controller.vroute.navigateTo('/signup');

    menuController.close();
  }

  void goToProfilePage() {
    final isNotAuthenticated = controller.isAuthenticated.value == false;
    if (isNotAuthenticated) {
      // Show login sign up popup
      toggleMenu();
      return;
    }

    if (controller.isOnboarding.value) {
      YLiftAlertDialog.show(
        context,
        title: 'Onboarding in process',
        message: 'Please finish onboarding before navigating to the profile page.',
      );
      return;
    }

    // Go to user profile page
    controller.vroute.navigateTo('/profile');
  }

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      menuChildren: [
        SizedBox(
          width: 240,
          child: YLiftFilledButton(
            onPressed: logIn,
            child: const Text('Log in'),
          ),
        ),
        SizedBox(
          width: 240,
          child: YLiftFilledButton(
            onPressed: signUp,
            child: const Text('Sign up'),
          ),
        ),
      ],
      controller: menuController,
      child: IconButton(
        onPressed: goToProfilePage,
        icon: const Icon(Icons.account_circle_outlined),
        color: Colors.white,
      ),
    );
  }
}
