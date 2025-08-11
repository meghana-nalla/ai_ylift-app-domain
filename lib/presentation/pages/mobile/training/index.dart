import 'package:YLift/presentation/components/_complex/footer.dart';
import 'package:YLift/presentation/components/_complex/know_y/knowy_training_image.dart';
import 'package:YLift/presentation/pages/mobile/video/index.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:flutter/material.dart';
import 'package:YLift/core/constants/index.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:YLift/core/repositories/image_repository.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:get/get.dart';


final _injectingImageUrl =
    '$API_WEB_LINK/${ApiUrl.getImage.path}/22141fc8-ac71-4a56-ac5a-02d5612b374b';
final _productsImageUrl =
    '$API_WEB_LINK/${ApiUrl.getImage.path}/24de809a-c482-4ffa-9ebf-ae64c1accecb';
final _imageRepository = ImageRepository();

class MobileTrainingPage extends StatelessWidget {
  const MobileTrainingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GlobalController>();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Our Trainings',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 19,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 2.37,
                  ),
                ),
              ],
            ),
          ),

          // MobileTrainingBanner(
          //   cards: [
          //     TrainingCardData(
          //       imageUrl: 'https://media.stage.ylift.app/api/optimized/variant/image/file/94776c25-0a89-4674-a45c-67662378a7d1',
          //       title: 'Y LIFT',
          //       subtitle: 'Minimally Invasive\nClosed Facelift®',
          //         onTap: () => controller.vroute.navigateTo('/mobile-network-provider'),
          //     ),
          //     TrainingCardData(
          //       imageUrl: 'https://media.stage.ylift.app/api/optimized/variant/image/file/9298cabf-c555-43d1-bda1-52618eb9160c',
          //       title: 'SurgYlift',
          //       subtitle: 'Minimally Invasive\nFace + Neck Lift',
          //       onTap: () => controller.vroute.navigateTo('/mobile-network-provider'),
          //     ),
          //     TrainingCardData(
          //       imageUrl: 'https://media.stage.ylift.app/api/optimized/variant/image/file/3645919c-64b3-4de5-9159-f09c4fbd87e4',
          //       title: 'UltraThread',
          //       subtitle: 'Non-Surgical\nThread Lift',
          //       onTap: () => controller.vroute.navigateTo('/mobile-network-provider'),
          //     ),
          //   ],
          // ),

          TrainingsMobile(
            cards: [
              TrainingCardData(
                imageUrl: 'https://media.stage.ylift.app/api/optimized/variant/image/file/94776c25-0a89-4674-a45c-67662378a7d1',
                title: 'Y LIFT',
                subtitle: 'Minimally Invasive\nClosed Facelift®',
                onTap: () => controller.vroute.navigateTo('/mobile-network-provider'),
              ),
              TrainingCardData(
                imageUrl: 'https://media.stage.ylift.app/api/optimized/variant/image/file/9298cabf-c555-43d1-bda1-52618eb9160c',
                title: 'SURGYLIFT',
                subtitle: 'Minimally Invasive\nFace + Neck Lift',
                  onTap: () => controller.vroute.navigateTo('/mobile-network-provider'),
              ),
              TrainingCardData(
                imageUrl: 'https://media.stage.ylift.app/api/optimized/variant/image/file/3645919c-64b3-4de5-9159-f09c4fbd87e4',
                title: 'MAGNYM',
                subtitle: 'Minimally Invasive\nFace + Neck Lift',
                onTap: () => controller.vroute.navigateTo('/mobile-network-provider'),
              ),
            ],
          ),
          const SizedBox(height: 16),


          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Provider Network Benefits',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 19,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 2.37,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:[
                  MobileNetworkCard(
                    icon: Icons.payments_outlined,
                    title: 'Exclusive Pricing',
                    description:
                    'Top-tier pricing on dermal fillers, neurotoxins, threads, and more.',
                  ),

                  const SizedBox(width: 16),
                  MobileNetworkCard(icon: Icons.map_outlined,
                    title: 'Patient Leads',
                    description:
                    'Patient leads sent to you through our finder’s map.',
                  ),
                  const SizedBox(width: 16),
                  MobileNetworkCard(icon: Icons.subscriptions_outlined,
                    title: 'Media Kit',
                    description:
                    'Use of all Y LIFT MEDIA KIT promotional materials.',),
                  const SizedBox(width: 16),
                  MobileNetworkCard(icon: Icons.help_outline_outlined,
                    title: 'ASK Y Platform',
                    description:
                    'Access to the ASK Y platform for education and networking.',),
                  const SizedBox(width: 16),
                  MobileNetworkCard(
                    icon: Icons.school_outlined,
                    title: '1-on-1 Mentorship',
                    description:
                    'Have questions after your session? We\'re always here for you.',
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Become a Provider',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 19,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 2.37,
                  ),
                ),
              ],
            ),
          ),
          MobileProviderCard1(
            imageUrl: _injectingImageUrl,
          ),

          SizedBox(height: 32),
          MobileProviderCard2(
            imageUrl:_productsImageUrl ,
         ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Training Experience with us',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 19,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 2.37,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Container(
                    width: 235,
                    height: 142.39,
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image: NetworkImage('$API_WEB_LINK/${ApiUrl.getImage.path}/78242a79-6ec2-4ac4-8eb5-c927f36063b6'),
                        fit: BoxFit.cover,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 235,
                    height: 142.39,
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image: NetworkImage("$API_WEB_LINK/${ApiUrl.getImage.path}/c803b405-4430-4fdc-8abb-bbea3b348ff0"),
                        fit: BoxFit.cover,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 235,
                    height: 142.39,
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image: NetworkImage("$API_WEB_LINK/${ApiUrl.getImage.path}/7260ab10-fa82-4be7-a645-128255e83f50"),
                        fit: BoxFit.cover,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 235,
                    height: 142.39,
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image: NetworkImage("$API_WEB_LINK/${ApiUrl.getImage.path}/4280430d-f644-4f12-9463-f24f40ffeadc"),
                        fit: BoxFit.cover,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 235,
                    height: 142.39,
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image: NetworkImage("$API_WEB_LINK/${ApiUrl.getImage.path}/887c6eee-e15e-4bd7-a55f-f00b685be626"),
                        fit: BoxFit.cover,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 235,
                    height: 142.39,
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image: NetworkImage("$API_WEB_LINK/${ApiUrl.getImage.path}/ce988a5f-7788-40c2-9bad-8706fa678e01"),
                        fit: BoxFit.cover,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 235,
                    height: 142.39,
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image: NetworkImage("$API_WEB_LINK/${ApiUrl.getImage.path}/c84c3b1d-d9f6-4bad-857f-cb40b12266bd"),
                        fit: BoxFit.cover,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 235,
                    height: 142.39,
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image: NetworkImage("$API_WEB_LINK/${ApiUrl.getImage.path}/2d567458-aae6-4309-8fea-87a2264dddae"),
                        fit: BoxFit.cover,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ),
          ),

          // DEBUG this widget tests the scroll view
          const SizedBox(height: 50),
        ],

      ),
    );

  }
}
