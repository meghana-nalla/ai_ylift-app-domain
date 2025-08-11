import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/core/repositories/image_repository.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:galaxy_ui/galaxy_ui.dart';

class NetworkBenefitsDialog extends StatelessWidget {
  const NetworkBenefitsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final global = Get.find<GlobalController>();

    return Dialog(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        child: SizedBox(
          width: 820,
          height: 480,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.lock),
                  const SizedBox(width: 16),
                  Text('Complete our training to unlock this product', style: textTheme.titleLarge),
                  const Spacer(),
                  const CloseIconButton(),
                ],
              ),
              const Divider(height: 32),
              const SizedBox(height: 16),
              Expanded(
                child: Row(
                  children: [
                    // LEFT SIDE
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Y LIFT Network Benefits', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(
                              'You will receive all the following benefits after registering for one of our trainings:'),
                          const SizedBox(height: 32),
                          _CheckText('Unlock and receive exclusive top-tier pricing on GALDERMA products'),
                          const SizedBox(height: 12),
                          _CheckText('Patient leads sent to you'),
                          const SizedBox(height: 12),
                          _CheckText('Media kits for marketing'),
                          const SizedBox(height: 12),
                          _CheckText('Education and networking opportunities'),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              global.vroute.navigateTo('/training', extra: 'scroll');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                color: Colors.white,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(color: Colors.black26, blurRadius: 8),
                                ],
                              ),
                              width: double.infinity,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: Text('See How It Works', style: TextStyle(fontSize: 13.33)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 32),

                    // RIGHT SIDE
                    Expanded(
                      child: Column(
                        children: [
                          const Spacer(),
                          SizedBox(
                            height: 160,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  SizedBox.square(
                                    dimension: 160,
                                    child: Image.network(
                                      // 'https://phantom.ylift.app/media/api/optimized/variant/image/file/e2a0a64b-803f-46a6-8dc4-0a75338cf671',
                                      ImageRepository.getBannerImage('e2a0a64b-803f-46a6-8dc4-0a75338cf671'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  SizedBox.square(
                                    dimension: 160,
                                    child: Image.network(
                                      // 'https://phantom.ylift.app/media/api/optimized/variant/image/file/48ead3bb-41d0-4c09-a0ed-bfae305bf993',
                                      ImageRepository.getBannerImage('48ead3bb-41d0-4c09-a0ed-bfae305bf993'),

                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  SizedBox.square(
                                    dimension: 160,
                                    child: Image.network(
                                      // 'https://phantom.ylift.app/media/api/optimized/variant/image/file/fc355ac2-d98e-4385-bd7a-4ee63c93b7ba',
                                      ImageRepository.getBannerImage('fc355ac2-d98e-4385-bd7a-4ee63c93b7ba'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: double.infinity,
                            child: RoundedFilledButton(
                              onPressed: () {
                                global.vroute.navigateTo('/training');
                              },
                              child: const Text('REGISTER NOW'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _AlreadyHaveProviderAccount(
                onLoginNow: () {
                  Navigator.pop(context);
                  global.vroute.navigateTo('/login');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CheckText extends StatelessWidget {
  final String text;
  const _CheckText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 3, right: 8),
          child: Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 16,
          ),
        ),
        Expanded(child: Text(text)),
      ],
    );
  }
}

class _AlreadyHaveProviderAccount extends StatefulWidget {
  final void Function() onLoginNow;

  const _AlreadyHaveProviderAccount({
    super.key,
    required this.onLoginNow,
  });

  @override
  State<_AlreadyHaveProviderAccount> createState() => _AlreadyHaveProviderAccountState();
}

class _AlreadyHaveProviderAccountState extends State<_AlreadyHaveProviderAccount> {
  final logInTapRecognizer = TapGestureRecognizer();

  @override
  void initState() {
    logInTapRecognizer.onTap = widget.onLoginNow;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 13.33, color: Color(0xFF787878)),
        text: 'Already have a provider account? ',
        children: [
          TextSpan(
            mouseCursor: SystemMouseCursors.click,
            recognizer: logInTapRecognizer,
            text: 'Log In Now',
            style: TextStyle(decoration: TextDecoration.underline),
          ),
        ],
      ),
    );
  }
}
