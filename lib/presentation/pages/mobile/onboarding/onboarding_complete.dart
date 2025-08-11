import 'package:YLift/core/repositories/image_repository.dart';
import 'package:flutter/material.dart';
import '../../../../core/controllers/global.dart';
import 'package:get/get.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:galaxy_ui/galaxy_ui.dart';

class OnboardingConfirmPage extends StatelessWidget {
  final String _accountCreatedImageUrl = ImageRepository.getBannerImage('48b818c3-390c-4ae5-b2e9-0ce1d6fd32af');
  final global = Get.find<GlobalController>();

  OnboardingConfirmPage({super.key});

  Future<void> _completeOnboarding(String route) async {
    try {
      PhantomResponse response = await global.auth.confirmSignUp();
      if (response.statusCode == 200 && response.statusMessage == 'Success') {
        await global.vroute.navigateTo(route);
      } else {
        throw('Error completing onboarding: ${response.message} - ${response.errorMessage}');
      }
    } catch (e,s) {
      print('Error completing onboarding: $e\n$s');
    }
  }

  Widget _buildCompletedImage() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          await _completeOnboarding('/training');
        },
        child: SizedBox(
          height: 320,
          width: 600,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(25)),
            child: Image.network(
              _accountCreatedImageUrl,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: YLiftColor.grey3, width: 2),
              padding: const EdgeInsets.symmetric(vertical: 24),
            ),
            onPressed: () async {
              await _completeOnboarding('/shop');
            },
            child: const Text(
              'Back To Shop',
              style: TextStyle(color: Color(0xFF787878)),
            ),
          ),
        ),
        const SizedBox(width: 32),
        Expanded(
          child: RoundedFilledButton(
            onPressed: () async {
              await _completeOnboarding('/training');
            },
            // onPressed: () => global.vroute.navigateTo('/training'),
            child: const Text('Go To Trainings'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.white,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Congratulations! Your Account Has Been Created.',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF272343),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            const Text('You\'ve unlocked access to most products in the store.'),
            const SizedBox(height: 48),
            const Text(
              'The best providers also choose to unlock...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF272343),
              ),
            ),
            //const SizedBox(height: 16),
            _buildCompletedImage(),
            //const SizedBox(height: 32),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }
}