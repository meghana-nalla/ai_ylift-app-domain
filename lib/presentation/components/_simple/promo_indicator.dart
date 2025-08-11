import 'package:flutter/material.dart';

import '../../../core/constants/color.dart';

class PromoIndicator extends StatelessWidget {

  const PromoIndicator({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 25,
      width: 75,
      decoration: BoxDecoration(
        border: Border.all(
          color: YLiftColor.orange,
          width: 1.75,
        ),
      ),
      child: Center(
        child: const Text(
          'PROMO',
          style: TextStyle(
            fontSize: 11.11,
            fontWeight: FontWeight.w700,
            color: YLiftColor.orange,
          )
        ),
      )
    );
  }

}