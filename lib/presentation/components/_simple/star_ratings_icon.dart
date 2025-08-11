import 'package:flutter/material.dart';

class StarRatingsIcon extends StatelessWidget {
  final double ratings;
  const StarRatingsIcon({
    super.key,
    required this.ratings,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (index) {
          if (ratings > index) {
            if (ratings < index + 1) return const Icon(Icons.star_half);
            return const Icon(Icons.star);
          } else {
            return const Icon(Icons.star_outline);
          }
        },
      ),
    );
  }
}
