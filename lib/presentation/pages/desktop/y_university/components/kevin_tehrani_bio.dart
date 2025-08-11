import 'package:YLift/presentation/components/_complex/desktop_view/gap.dart';
import 'package:flutter/material.dart';

class KevinTehraniBio extends StatelessWidget {
  const KevinTehraniBio({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.network(
          'https://store.ylift.com/static/img/experts/DrKevin.png',
        ),
        const GapX(),
        const SizedBox(
          width: 320,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dr. Kevin Tehrani',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              Text(
                'Board-Certified Plastic Surgeon',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 16),
              Text(
                  'Dr. Kevin Tehrani is a Board Certified plastic surgeon and a Diplomat of The American Board of Plastic Surgery. His practice encompasses all aspects of reconstructive and cosmetic plastic surgery.\n'
                  'Dr. Tehrani\'s interests in reconstructive surgery include autologous breast reconstruction after mastectomy and abdominal wall reconstruction.'
                  'His interests in aesthetic plastic surgery include Lateral Tension Abdominoplasy, Trans Umbilical Breast Augmentation and minimal incision face lifts.'
                  'He has been honorably discharged from the Naval Reserves Medical Corps where he served as Lieutenant Commander for 9 years. He volunteers his surgical expertise to underdeveloped countries for children with congenital defects.'),
            ],
          ),
        ),
      ],
    );
  }
}
