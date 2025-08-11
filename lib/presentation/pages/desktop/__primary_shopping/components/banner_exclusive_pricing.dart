import 'package:YLift/core/controllers/z-index_export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class GetExclusivePricingBanner extends StatelessWidget {
  const GetExclusivePricingBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final global = Get.find<GlobalController>();

    final textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF3F4F3),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      height: 450,
      width: 450,
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Get Exclusive\nTop-Tier Pricing\nOn Products', style: textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text('And More!', style: GoogleFonts.metal(fontSize: 32)),
          const SizedBox(height: 8),
          const Text('After registering for our hands-on /\nvirtual trainings'),
          const SizedBox(height: 32),
          SizedBox(
            width: 180,
            child: FilledButton(
              style: FilledButton.styleFrom(
                shape: const StadiumBorder(),
              ),
              onPressed: () {
                global.vroute.navigateTo('/training', extra: 'scroll');
              },
              child: const Text('How It Works'),
            ),
          ),
        ],
      ),
    );
  }
}
