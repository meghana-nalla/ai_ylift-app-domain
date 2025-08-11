import 'package:YLift/core/constants/color.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/core/repositories/image_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final _noPromoImageUrl = ImageRepository.getBannerImage('5df8f691-e72c-4be8-bec2-9b0639aad42b');
    // 'https://phantom.ylift.app/media/api/optimized/variant/image/file/5df8f691-e72c-4be8-bec2-9b0639aad42b';

class NoPromotionBanner extends StatelessWidget {
  const NoPromotionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1080,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 96),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'No active promotions are available at the moment. Please check back later or watch for updates in your email.',
                        style: TextStyle(color: Color(0xFFBBBBBB), fontSize: 28, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: 200,
                        child: FilledButton(
                          onPressed: () {
                            final global = Get.find<GlobalController>();
                            global.vroute.navigateTo('/shop');
                          },
                          child: const Text('Keep Shopping'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Image.network(
                  _noPromoImageUrl,
                  height: 400,
                ),
              ),
            ],
          ),
          Divider(color: YLiftColor.grey3),
        ],
      ),
    );
  }
}
