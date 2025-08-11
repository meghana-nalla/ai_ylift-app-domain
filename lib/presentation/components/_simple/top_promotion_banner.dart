import 'package:YLift/core/constants/constant.dart';
import 'package:flutter/material.dart';

class TopPromotionBanner extends StatelessWidget {
  final String message;

  const TopPromotionBanner({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black,
      child: SizedBox(
        width: double.infinity,
        height: YLiftConstant.promotionBannerHeight,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
