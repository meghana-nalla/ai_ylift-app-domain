import 'package:flutter/material.dart';
import 'package:galaxy_ui/galaxy_ui.dart';

class SinglePromotionBanner extends StatelessWidget {
  final String imageUrl;

  /// The expiration date of the promotion. If null, the banner will not display a countdown.
  final DateTime? expirationDate;
  final void Function() onTap;

  const SinglePromotionBanner({
    super.key,
    required this.imageUrl,
    required this.onTap,
    this.expirationDate,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            Image.network(
              imageUrl,
              // width: double.infinity,
              width: 1080,
              fit: BoxFit.fitWidth,
            ),
            if (expirationDate != null)
              Positioned(
                left: 32,
                top: 32,
                child: CountdownDisplay(expirationDate: expirationDate!),
              ),
          ],
        ),
      ),
    );
  }
}