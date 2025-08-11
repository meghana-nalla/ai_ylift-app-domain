import 'package:YLift/presentation/components/_complex/desktop_view/gap.dart';
import 'package:flutter/material.dart';

class YulyGorodiskyBio extends StatelessWidget {
  const YulyGorodiskyBio({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.network(
          'https://store.ylift.com/static/img/experts/DrYuly.png',
        ),
        const GapX(),
        const SizedBox(
          width: 320,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dr. Yuly Gorodisky',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              Text(
                'Board-Certified Plastic Surgeon',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 16),
              Text(
                  'Dr. Gorodisky is a board-certified plastic surgeon. He is board-certified in plastic surgery by the American Osteopathic Board of Surgery.\n'
                  'Dr. Gorodisky performs all varieties of plastic, cosmetic, and reconstructive surgery. He specializes in body contouring procedures such as liposuction, laser lipolysis with SlimLipo laser, tummy tuck, thigh and arm lifts. He also uses a full spectrum of injectable products such as Botox, Juvederm, Radiesse, and fat transfer to the face, lips, and other areas. His patients clude those needing breast reconstruction after cancer surgery, face reconstructions after traumatic accidents or cancer, patients with chronic wounds, and burn victims. His extensive and broad experience as a plastic surgeon makes him the ideal candidate for anyone seeking professional help in this field.'),
            ],
          ),
        ),
      ],
    );
  }
}
