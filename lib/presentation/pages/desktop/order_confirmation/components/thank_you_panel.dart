import 'package:YLift/core/controllers/z-index_export.dart';
import 'package:YLift/core/repositories/image_repository.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:flutter/material.dart';
import 'package:YLift/core/constants/text_style.dart';
import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import '../../__primary_shopping/components/quick_reorder_dialog.dart';

class ThankYouPanel extends StatelessWidget {
  final OrderSimple order;
  final String? email;
  const ThankYouPanel({
    super.key,
    required this.order,
    required this.email,
  });

  static const _imageRepository = ImageRepository();
  @override
  Widget build(BuildContext context) {
    return GalaxyPanel(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 54,
                    ),
                    const SizedBox(width: YLiftConstant.gap),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Thank you for choosing Y LIFT!', style: YLiftTextStyle.title),
                          // const Text('As a Y LIFT Provider, you just saved \$1,202.08'),
                          const SizedBox(height: YLiftConstant.gap),
                          Padding(
                            padding: const EdgeInsets.only(right: 32),
                            child: Text(
                              'We sent an email to $email with your order confirmation and bill. Looking forward to seeing you again!',
                              style: YLiftTextStyle.descriptionGrey,
                            ),
                          ),
                          const SizedBox(height: YLiftConstant.gap),
                          Text('Time placed: ${DateFormat.yMMMMd().add_jm().format(order.orderDate!,)}'),
                          const GapY(factor: 2),
                          YLiftFilledButton(
                            onPressed: () {

                              showDialog(
                                  context: context,
                                  builder: (context) => QuickReorderDialog(previousOrder: order)
                              );
                            },
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 64),
                            minWidth: 270,
                            child: const Text('Reorder', style: TextStyle(fontWeight: FontWeight.w100)),
                          ),
                          SizedBox(height: 10),
                          YLiftFilledButton(
                            onPressed: () {
                              final controller = Get.find<GlobalController>();
                              controller.vroute.navigateTo('/shop');
                            },
                            minWidth: 270,
                            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 64),
                            child: const Text('Continue Shopping'),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: Image.network(_imageRepository.getImageUrl('351f7916-4a6d-4e78-a7b5-1911a93aa7b1')),
          ),
        ],
      ),
    );
  }
}
