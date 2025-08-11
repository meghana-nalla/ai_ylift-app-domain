import 'package:YLift/core/constants/color.dart';
import 'package:YLift/core/constants/index.dart';
import 'package:YLift/core/controllers/z-index_export.dart';
import 'package:YLift/core/repositories/image_repository.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:galaxy_ui/galaxy_ui.dart';

final _yLiftImageUrl = ImageRepository.getBannerImage('e2a0a64b-803f-46a6-8dc4-0a75338cf671');
    // 'https://phantom.ylift.app/media/api/optimized/variant/image/file/e2a0a64b-803f-46a6-8dc4-0a75338cf671';
final _surgYLiftImageUrl = ImageRepository.getBannerImage('48ead3bb-41d0-4c09-a0ed-bfae305bf993');
    // 'https://phantom.ylift.app/media/api/optimized/variant/image/file/48ead3bb-41d0-4c09-a0ed-bfae305bf993';
final _magnYmImageUrl = ImageRepository.getBannerImage('fc355ac2-d98e-4385-bd7a-4ee63c93b7ba');
    // 'https://phantom.ylift.app/media/api/optimized/variant/image/file/fc355ac2-d98e-4385-bd7a-4ee63c93b7ba';

class UnlockPricingDialog extends StatelessWidget {
  final String productImageUrl;
  final void Function() onSeeProduct;
  final void Function() onViewTrainingDetails;

  const UnlockPricingDialog({
    super.key,
    required this.productImageUrl,
    required this.onSeeProduct,
    required this.onViewTrainingDetails,
  });

  static Future<void> show(BuildContext context, ProductSimple product) {
    return showDialog(
      context: context,
      builder: (context) {
        final global = Get.find<GlobalController>();
        return UnlockPricingDialog(
          productImageUrl: product.imageUrl,
          onSeeProduct: () {
            global.vroute.navigateToProduct(product.productId!);
          },
          onViewTrainingDetails: () {
            global.vroute.navigateTo('/training');
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final global = Get.find<GlobalController>();
    final textTheme = Theme.of(context).textTheme;

    return Dialog(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: SizedBox(
        height: 480,
        width: 820,
        child: Row(
          children: [
            // LEFT SIDE
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Image.network(
                      productImageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Divider(height: 2, color: YLiftColor.grey3),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        onSeeProduct();
                      },
                      child: const Center(
                        child: Text('SEE THE PRODUCT'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const VerticalDivider(width: 2, color: YLiftColor.grey3),

            // RIGHT SIDE
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Unlock Top-Tier Pricing',
                                style: textTheme.titleLarge,
                              ),
                              const SizedBox(height: 8),
                              Text('After register for one of the following trainings.'),
                              const Divider(height: 48),
                              Text('Our available trainings:'),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 160,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          global.vroute.navigateTo('/network-provider');
                                        },
                                        child: SizedBox.square(
                                          dimension: 160,
                                          child: Image.network(
                                            _yLiftImageUrl,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      GestureDetector(
                                        onTap: () {
                                          global.vroute.navigateTo('/y-university');
                                        },
                                        child: SizedBox.square(
                                          dimension: 160,
                                          child: Image.network(
                                            _surgYLiftImageUrl,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      GestureDetector(
                                        onTap: () {
                                          global.vroute.navigateTo('/video');
                                        },
                                        child: SizedBox.square(
                                          dimension: 160,
                                          child: Image.network(
                                            _magnYmImageUrl,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Expanded(
                              //   child: Image.network(
                              //     _galdermaPromotionUrl,
                              //     fit: BoxFit.cover,
                              //   ),
                              // ),
                              // Expanded(
                              //   child: Placeholder(), // Put promotion image here
                              // ),
                              const Spacer(),

                              Center(
                                child: TextButton(
                                  onPressed: () {
                                    global.vroute.navigateTo('/training', extra: 'scroll');
                                  },
                                  child: const Text(
                                    'How it works?',
                                    style: TextStyle(color: Color(0xFF787878), decoration: TextDecoration.underline),
                                  ),
                                ),
                              ),
                              // const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: RoundedFilledButton(
                                  onPressed: onViewTrainingDetails,
                                  child: const Text(
                                    'View Training Details',
                                    style: TextStyle(letterSpacing: 1.4),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Positioned(
                    top: 16,
                    right: 16,
                    child: CloseIconButton(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
