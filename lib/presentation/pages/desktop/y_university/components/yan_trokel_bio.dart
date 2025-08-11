import 'package:YLift/presentation/components/_complex/desktop_view/gap.dart';
import 'package:flutter/material.dart';

class YanTrokelBio extends StatelessWidget {
  const YanTrokelBio({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.network(
          'https://store.ylift.com/static/img/experts/DrYan.png',
        ),
        const GapX(),
        const SizedBox(
          width: 320,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dr. Yan Trokel',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              Text(
                'Board-Certified Maxillofacial Surgeon',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 16),
              Text(
                  'Dr. Yan Trokel is a world-renowned New York based board-certified maxillofacial surgeon specializing in non-surgical and minimally-invasive facial rejuvenation treatments has been transforming faces since 2006.\n'
                  'Dr. Trokel\'s unique innovations have earned patents, including for his signature Y LIFT® procedure, dubbed the "Miracle 30-Minute Facelift" by Dr. Oz; SURGYLIFT™ - an innovative non- incisional face and neck lift; MYcrosculpt® - a cannula grip device designed specifically for Dr. Trokel\'s groundbreaking injection techniques; and the FlexYguide® - an anatomically-correct face mapping tool and guide for injection techniques. Dr. Trokel\'s groundbreaking methodology and expertise in facial rejuvenation continues to revolutionize facial aesthetics.'),
            ],
          ),
        ),
      ],
    );
  }
}
