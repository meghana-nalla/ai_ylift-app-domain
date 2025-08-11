import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/presentation/components/z-index_export.dart' hide RoundedFilledButton;
import 'package:flutter/material.dart';

import 'package:galaxy_ui/galaxy_ui.dart';

// Made by Richie
//
// Created at Dec 23, 2024

class TwoGridPromotionBanner extends StatelessWidget {
  final String title;
  final String details;
  final String imageUrl;
  final void Function() onTap;
  final DateTime? expirationDate;

  const TwoGridPromotionBanner({
    super.key,
    required this.title,
    required this.details,
    required this.onTap,
    required this.imageUrl,
    this.expirationDate,
  });

  int get daysLeft {
    final currentDate = DateTime.now();
    return expirationDate!.difference(currentDate).inDays;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: YLiftConstant.pageWidth / 2,
        child: Stack(
          children: [
            GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              children: [
                Container(
                  color: Color(0xFF64D1DE),
                  padding: const EdgeInsets.only(left: 80, right: 80, top: 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(fontSize: 39, color: Colors.white, fontWeight: FontWeight.bold, height: 1.2),
                      ),
                      const SizedBox(height: 32),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.white, width: 4),
                          ),
                        ),
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text('Details', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        details,
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: 280,
                        child: RoundedFilledButton(
                          color: Color(0xFF343434),
                          onPressed: onTap,
                          child: const Text('SHOP NOW'),
                        ),
                      ),
                    ],
                  ),
                ),
                Image.network(imageUrl),
              ],
            ),
            if (expirationDate != null)
              Positioned(
                top: 32,
                left: 32,
                child: CountdownDisplay(expirationDate: expirationDate!),
              ),
          ],
        ),
      ),
    );
  }
}
