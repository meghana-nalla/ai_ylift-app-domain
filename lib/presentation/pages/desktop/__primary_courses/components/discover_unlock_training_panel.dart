import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DiscoverUnlockTrainingPanel extends StatelessWidget {
  const DiscoverUnlockTrainingPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: Color(0xFFDFE2FB),
      ),
      width: 440,
      height: 480,
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Unlock Training Videos With ',
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: 'Radiesse Purchase',
                  style: GoogleFonts.metal(fontSize: 33),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: 'Videos unlock with Radiesse purchases. Get'),
                TextSpan(
                  text: ' bonus syringes',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
                TextSpan(text: ' with select bundles.'),
              ],
            ),
            style: TextStyle(fontSize: 13.33),
          ),
          const SizedBox(height: 32),

          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder:
                    (context) => Dialog(
                      child: Image.network(
                        'https://media.stage.ylift.app/api/optimized/variant/image/122335b5-fc2a-4249-b7c2-6ae8cc69db3f',
                      ),
                    ),
              );
            },
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                'https://media.stage.ylift.app/api/optimized/variant/image/122335b5-fc2a-4249-b7c2-6ae8cc69db3f',
              ),
            ),
          ),

          // SizedBox(
          //   width: 240,
          //   child: OutlinedButton(
          //     style: OutlinedButton.styleFrom(
          //       side: const BorderSide(),
          //       shape: const StadiumBorder(),
          //       textStyle: const TextStyle(fontSize: 13.33),
          //     ),
          //     onPressed: () {},
          //     child: const Text('Bonus Syringe Breakdown'),
          //   ),
          // ),
          // const SizedBox(height: 16),
          // SizedBox(
          //   width: 240,
          //   child: FilledButton(
          //     style: FilledButton.styleFrom(
          //       backgroundColor: Color(0xFF006AFF),
          //       foregroundColor: Colors.white,
          //       textStyle: const TextStyle(fontSize: 13.33),
          //     ),
          //     onPressed: () {},
          //     child: const Text('Browse All Courses'),
          //   ),
          // ),
        ],
      ),
    );
  }
}
