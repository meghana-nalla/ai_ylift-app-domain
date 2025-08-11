import 'package:YLift/core/controllers/global.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:get/get.dart';

const _frontImageUrl =
    'https://d26n8ibxbj8243.cloudfront.net/optimized/custom_images/galderma_may_27.png';
const _infoImageUrl =
    'https://d26n8ibxbj8243.cloudfront.net/optimized/custom_images/galderma_may_27_info.png';

class GaldermaRefreshYourBeautyPromotionDialog extends StatelessWidget {
  const GaldermaRefreshYourBeautyPromotionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 1000,
        height: 800,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Text(
                      'Refresh your Beauty with Restylane Promotion',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Image.network(_frontImageUrl),
              const SizedBox(height: 32),
              Image.network(_infoImageUrl),
              const SizedBox(height: 32),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    RoundedFilledButton(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      onPressed: () {
                        final global = Get.find<GlobalController>();
                        global.selectedBrandId.value = 'brand=81';
                        global.vroute.navigateTo('/shop/all');
                        return;
                      },
                      child: const Text('Go to Restylane Products'),
                    ),
                    // TextButton(
                    //   onPressed: () {
                    //     Navigator.pop(context);
                    //   },
                    //   child: Text('Close'),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
