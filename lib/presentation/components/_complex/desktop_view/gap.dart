import 'package:YLift/core/constants/constant.dart';
import 'package:flutter/material.dart';

class Gap extends StatelessWidget {
  const Gap({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.square(
      dimension: YLiftConstant.gap,
    );
  }
}

class GapX extends StatelessWidget {
  final double factor;
  const GapX({super.key, this.factor = 1.0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: YLiftConstant.gap * factor);
  }
}

class GapY extends StatelessWidget {
  final double factor;
  const GapY({super.key, this.factor = 1.0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: YLiftConstant.gap * factor);
  }
}
