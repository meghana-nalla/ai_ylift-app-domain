import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:YLift/presentation/pages/mobile/onboarding/components/1_basic_information.dart';
import 'package:YLift/presentation/pages/mobile/onboarding/components/2_billing_information.dart';
import 'package:YLift/presentation/pages/mobile/onboarding/components/3_shipping_information.dart';
import 'package:YLift/presentation/pages/mobile/onboarding/components/4_medical_license.dart';
import 'package:YLift/presentation/pages/mobile/onboarding/components/stepper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'onboarding_complete.dart';

class MobileOnboardingPage extends StatefulWidget {
  const MobileOnboardingPage({super.key});

  @override
  State<MobileOnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<MobileOnboardingPage> {
  final GlobalController global = Get.find<GlobalController>();
  bool hideOnboarding = false;

  bool isFillingMedicalLicense = false;
  bool get asksForMedicalLicense =>
      global.onboard.process == OnboardingProcess.medicalLicense &&
          !isFillingMedicalLicense;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    if (global.isAuthenticated.isTrue && global.isOnboarding.isFalse) {
      print('Navigating to shop from onboarding since the user is already authenticated and not onboarding');
      await global.vroute.navigateTo('/shop');
      return;
    } else if (global.isAuthenticated.isFalse) {
      print('Navigating to signup from onboarding since the user is not authenticated');
      await global.vroute.navigateTo('/signup');
      return;
    }
    print('Setting onboarding process ... not redirecting');
    final processIndex = global.signUpPayload['onboardingProcess'] ?? global.onboardingProcessStep.value;
    global.onboard.setProcess(OnboardingProcess.values[processIndex]);
  }

  Future<void> _done(navigate) async {
    PhantomResponse response = await global.auth.confirmSignUp();
    if (response.statusCode == 200 && response.message == 'Success') {
      await global.vroute.navigateTo(navigate);
    } else {
      String msg = 'Error occured in _OnboardingPageState._done(): ${response.message} - ${response.errorMessage}';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Colors.red,
        ),
      );
      throw (msg);
      // need to handle this error better..
    }
  }

  // Widget _buildHeader() {
  //   return ColoredBox(
  //     color: Colors.black,
  //     child: SizedBox(
  //       height: YLiftConstant.mainNavigationHeight,
  //       child: Center(
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: const [
  //             Text(
  //               'Y LIFT STORE',
  //               style: TextStyle(
  //                 color: Colors.white,
  //                 fontSize: 24,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildOnboardingProcess() {
    return Center(

      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: (global.onboard.process != OnboardingProcess.confirm) ? 660 : 1000,
          minHeight: MediaQuery.of(context).size.height - YLiftConstant.totalTopNavigation - 240,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (global.onboard.process != OnboardingProcess.confirm) ...[
                OnboardingStepper(process: global.onboard.process),
                const SizedBox(height: 32),
                Text(
                  'Step ${global.onboard.process.index + 1} - ${global.onboard.process.label}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildProcessDescription(),
                const SizedBox(height: 8),
              ],
              if (hideOnboarding)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Onboarding completed!',
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold, color: YLiftColor.orange, letterSpacing: 1.8),
                    ),
                    const SizedBox(height: 16),
                    Text('You will be redirected shortly...'),
                    const SizedBox(height: 240),
                  ],
                )
              else ...[
                _buildOnboardingForm(),
                if (global.onboard.process != OnboardingProcess.confirm) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        global.isOnboarding.value = false;
                        global.auth.processLogout();
                      },
                      child: const Text('Save & Exit'),
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProcessDescription() {
    if (global.onboard.process == OnboardingProcess.medicalLicense) {
      return const Text('Without a medical license, some products may be unavailable');
    }
    return const SizedBox.shrink();
  }

  Widget _buildOnboardingForm() {
    if (asksForMedicalLicense) {
      return _doYouHaveAMedicalLicense();
    }

    return switch (global.onboard.process) {
      OnboardingProcess.basicInformation => BasicInformationPage(
        onSubmit: (formData) async =>
        await global.onboard.goToNextProcess(formData, OnboardingProcess.billingInformation),
        errorMessage: global.onboard.errorMessage,
        onError: (message) => global.onboard.setErrorMessage(message),
      ),
      OnboardingProcess.billingInformation => BillingInformationPage(
        onSubmit: (formData) async =>
        await global.onboard.goToNextProcess(formData, OnboardingProcess.shippingInformation),
        errorMessage: global.onboard.errorMessage,
        onError: (message) => global.onboard.setErrorMessage(message),
      ),
      OnboardingProcess.shippingInformation => ShippingInformationPage(
        onSubmit: (formData) async => {
          await global.onboard.goToNextProcess(formData, OnboardingProcess.medicalLicense),
          print('Navigating to account created'),
        },
        errorMessage: global.onboard.errorMessage,
        onError: (message) => global.onboard.setErrorMessage(message),
      ),
      OnboardingProcess.medicalLicense => MedicalLicensePage(
        onSubmit: (formData) async {
          setState(() {
            hideOnboarding = true;
          });
          await global.onboard.goToNextProcess(formData, OnboardingProcess.confirm);
          print('Navigating to completed onboarding process');
          setState(() {
            hideOnboarding = false;
          });
        },
        errorMessage: global.onboard.errorMessage,
        onError: (message) => global.onboard.setErrorMessage(message),
      ),
      OnboardingProcess.confirm => OnboardingConfirmPage()
    };
  }

  Widget _doYouHaveAMedicalLicense() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: RoundedFilledButton(
            onPressed: () {
              setState(() {
                isFillingMedicalLicense = true;
              });
            },
            child: const Text('I have a medical license'),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () async {
              setState(() {
                hideOnboarding = true;
              });
              global.signUpPayload['signUpProcess'] = 4;

              await global.onboard.goToNextProcess(
                {},
                OnboardingProcess.confirm,
              );
              print('Navigating to completed onboarding process');
              setState(() {
                hideOnboarding = false;
              });
            },
            child: const Text('I do not have a medical license'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  _buildOnboardingProcess(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          //GalaxyFooter(),
        ],

      ),

    );
  }
}
