import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/core/repositories/image_repository.dart';
import 'package:YLift/presentation/pages/desktop/__primary_shopping/components/quick_reorder_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

final _ladyImageUrl = ImageRepository.getBannerImage('c967c02a-f9de-4e34-a736-abf6907b5831');
    // 'https://phantom.ylift.app/media/api/optimized/variant/image/banners/file/c967c02a-f9de-4e34-a736-abf6907b5831';

class ProductDealsBanner extends StatelessWidget {
  ProductDealsBanner({super.key});

  final global = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFFF7F4),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      height: 512.25,
      // width: 420,
      child: Stack(
        children: [
          Positioned(
            bottom: -80,
            right: -40,
            width: 320,
            height: 320,
            child: Image.network(_ladyImageUrl),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                if (global.isAuthenticated.isTrue) ...[
                  Row(
                    children: [
                      Text(
                        'Welcome Back',
                        style: GoogleFonts.metal(fontSize: 33),
                      ),
                      if (global.user.value.name != null)
                        Text(
                          ', ${global.user.value.name?.split(' ').first}',
                          style: GoogleFonts.metal(fontSize: 33),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('How Can We Assist You With Today?', style: textTheme.headlineSmall),
                ] else ...[
                  Text('Y LIFT NETWORK', style: textTheme.bodySmall),
                  const SizedBox(height: 8),
                  Text('Product Deals\nAnd Education', style: textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text('All-In-One', style: GoogleFonts.metal(fontSize: 32)),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  width: 180,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      shape: const StadiumBorder(),
                      // padding:  EdgeInsets.zero,
                    ),
                    onPressed: () {
                      global.vroute.navigateTo('/shop/all', extra: 'query=ALL_PRODUCTS');
                    },
                    child: const Text('Browse Products'),
                  ),
                ),
                const SizedBox(height: 16),
                if (global.isAuthenticated.isTrue)
                  SizedBox(
                    width: 180,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        shape: const StadiumBorder(),
                        backgroundColor: const Color(0xFFFF8C68),
                      ),
                      onPressed: () {
                        global.vroute.navigateTo('/promotions');
                      },
                      child: const Text('Browse Promotions'),
                    ),
                  )
                else
                  SizedBox(
                    width: 180,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        shape: const StadiumBorder(),
                        backgroundColor: const Color(0xFFFF8C68),
                      ),
                      onPressed: () {
                        global.vroute.navigateTo('/signup');
                      },
                      child: const Text('Sign Up Today'),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
