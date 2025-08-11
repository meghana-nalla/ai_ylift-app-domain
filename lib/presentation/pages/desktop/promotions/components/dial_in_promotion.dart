import 'dart:async';

import 'package:YLift/core/constants/hardcoded_id.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/hardcodes/constants/ids.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DialInPromotion extends StatefulWidget {
  const DialInPromotion({super.key});

  @override
  State<DialInPromotion> createState() => _DialInPromotionState();
}

class _DialInPromotionState extends State<DialInPromotion> {
  final endDate = DateTime(2025, 6, 20, 18);
  late Timer timer;
  late Duration duration;
  late DateTime targetDateTime;

  void updateDuration() {
    final now = DateTime.now();
    final difference = endDate.difference(now);

    setState(() {
      duration = difference.isNegative ? Duration.zero : difference;
    });
  }

  @override
  void initState() {
    updateDuration();
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        updateDuration();
        if (duration.inSeconds <= 0) {
          timer.cancel();
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  Widget buildTimeBox(String value) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 4),
      decoration: const BoxDecoration(
        color: Color(0xFF7DCDE0),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      width: 32,
      alignment: Alignment.center,
      child: Text(
        value,
        style: GoogleFonts.inter(
          fontSize: 32,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildColon() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        ":",
        style: TextStyle(
          fontSize: 32,
          color: Colors.lightBlueAccent,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String get countdown {
    final days = twoDigits(duration.inDays);
    final hours = twoDigits(duration.inHours.remainder(24));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$days:$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'This Week Only: Call for Bonus Discounts!',
          style: GoogleFonts.inter(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Call us to unlock a custom deal--on top of our already low prices on Galderma.',
          style: GoogleFonts.inter(fontSize: 20),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    buildTimeBox(countdown.split(':')[0][0]),
                    buildTimeBox(countdown.split(':')[0][1]),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Days',
                  style: TextStyle(fontSize: 13.33),
                ),
              ],
            ),

            buildColon(),
            Column(
              children: [
                Row(
                  children: [
                    buildTimeBox(countdown.split(':')[1][0]),
                    buildTimeBox(countdown.split(':')[1][1]),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Hours',
                  style: TextStyle(fontSize: 13.33),
                ),
              ],
            ),
            buildColon(),
            Column(
              children: [
                Row(
                  children: [
                    buildTimeBox(countdown.split(':')[2][0]),
                    buildTimeBox(countdown.split(':')[2][1]),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Minutes',
                  style: TextStyle(fontSize: 13.33),
                ),
              ],
            ),
            buildColon(),
            Column(
              children: [
                Row(
                  children: [
                    buildTimeBox(countdown.split(':')[3][0]),
                    buildTimeBox(countdown.split(':')[3][1]),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Seconds',
                  style: TextStyle(fontSize: 13.33),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            final global = Get.find<GlobalController>();
            final brands = global.brands.where(
              (brand) => [
                BrandId.restylane,
                BrandId.dysport,
                BrandId.sculptra,
              ].contains(brand.brandId),
            );
            final brandIds = brands.map((e) => e.brandId!).toList();
            global.selectedBrandId.value = 'brand=${brandIds.join(',')}';
            global.vroute.navigateTo('/shop/all');
            return;
          },
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            child: Image.network(
              'https://media.stage.ylift.app/api/optimized/variant/image/3095d51c-1081-4523-8ccd-1bb6e65d2f9f',
            ),
          ),
        ),
      ],
    );
  }
}
