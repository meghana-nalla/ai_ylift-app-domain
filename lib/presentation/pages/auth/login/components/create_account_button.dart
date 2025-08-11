import 'package:YLift/core/controllers/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateAccountButton extends StatelessWidget {
  const CreateAccountButton({super.key});

  void _goToCreateAccount() {
    final global = Get.find<GlobalController>();
    global.vroute.navigateTo('/signup');
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _goToCreateAccount,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.shade400,
                blurRadius: 4,
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          child: const Text(
            'Create Your YLS Account',
            style: TextStyle(color: Colors.black, fontSize: 13.33),
          ),
        ),
      ),
    );
  }
}
