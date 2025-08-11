import 'package:YLift/presentation/components/_complex/dialogs/network_benefits_dialog.dart';
import 'package:YLift/presentation/components/buttons/mobile_icon.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_models/core/constants/y_lift_color.dart';

class UnlockGaldermaProductsDialog extends StatefulWidget {
  const UnlockGaldermaProductsDialog({super.key});

  @override
  State<UnlockGaldermaProductsDialog> createState() =>
      _UnlockGaldermaProductsDialogState();
}

class _UnlockGaldermaProductsDialogState
    extends State<UnlockGaldermaProductsDialog> {
  bool signAttestationLetter = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Dialog(
          backgroundColor: Colors.white,
          shape: const Border(),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              // height: 800,
              width: 640,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.lock_rounded),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          'Unlock Galderma Products',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 32,
                    color: YLiftColor.divider,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'To unlock Galderma products, you need to sign our attestation letter or fill out the form.',
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          border: Border.all(
                            color:
                                signAttestationLetter
                                    ? Colors.black
                                    : Colors.grey,
                            width: signAttestationLetter ? 2 : 1,
                          ),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.feed_outlined,
                              color: Colors.black87,
                            ),
                            const SizedBox(width: 16),
                            Expanded(child: Text('Sign Attestation Letter')),
                            if (signAttestationLetter) Icon(Icons.check),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          border: Border.all(
                            color:
                                !signAttestationLetter
                                    ? Colors.black
                                    : Colors.grey,
                            width: !signAttestationLetter ? 2 : 1,
                          ),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.drive_file_rename_outline,
                              color: Colors.black87,
                            ),
                            const SizedBox(width: 16),
                            Expanded(child: Text('Fill Out Form')),
                            if (!signAttestationLetter) Icon(Icons.check),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 64),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 64),
        NetworkBenefitsDialog(),
      ],
    );
  }
}
