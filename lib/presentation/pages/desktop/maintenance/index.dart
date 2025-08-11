import 'package:flutter/material.dart';

class MaintenancePage extends StatelessWidget {
  const MaintenancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Y Lift Store is under maintenance',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                Text(
                  'Sorry for the inconvenience! We will be back shortly with new features and improvements.',
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'If you need assistance, please contact us at ',
                      ),
                      TextSpan(
                        text: '(212)-861-7787',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ' or '),
                      TextSpan(
                        text: 'info@ylift.com.',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Image.network(
                  'https://raw.githubusercontent.com/Y-LIFT-Store/ylift-app-domain/refs/heads/main/msc/images/maintenance_image.webp?token=GHSAT0AAAAAADAU35OAM5T4U4L3PLQVSXAC2AJKUGA',
                  width: 640,
                  errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
