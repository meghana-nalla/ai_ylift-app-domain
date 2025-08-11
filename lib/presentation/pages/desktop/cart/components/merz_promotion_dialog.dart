import 'package:YLift/core/repositories/image_repository.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
class MerzSyringePromotion {
  final int purchasedSyringes;
  final int freeSyringes;
  final int ratio; // in percentage

  int get freeBoxes => freeSyringes ~/ 2;

  const MerzSyringePromotion._(this.purchasedSyringes, this.freeSyringes, this.ratio);

  static const brandId = 75; // Radiesse brandId
  static const productIds = [450, 449]; // Radiesse product ids
  static const skuIds = [2022, 2024];
  static final bannerImageUrl =
      ImageRepository.getBannerImage('cee1ddf4-8a57-4e5d-9757-63520d6fbd85');
  //5a631d6d-c7c4-477e-9271-26012e30042d. 8d10a812-181d-4537-a424-bbb748f70074

  static String getMessage(int quantity) {
    final totalSyringes = quantity * 2;
    final merz = getNextPromotion(quantity) ?? list.first;
    final quantityLeft = merz.purchasedSyringes - totalSyringes;
    final boxLeft = quantityLeft ~/ 2;
    return 'Add $boxLeft more boxes and get ${merz.freeBoxes} boxes for free!';
  }

  static const list = <MerzSyringePromotion>[
    MerzSyringePromotion._(10, 2, 20),
    MerzSyringePromotion._(20, 6, 30),
    MerzSyringePromotion._(40, 14, 35),
    MerzSyringePromotion._(60, 24, 40),
    MerzSyringePromotion._(80, 36, 45),
    MerzSyringePromotion._(100, 50, 50),
    MerzSyringePromotion._(120, 72, 60),
  ];

  static MerzSyringePromotion? getNextPromotion(int boxQuantity) {
    final totalSyringes = boxQuantity * 2;
    if (totalSyringes >= 120) {
      final limit = (totalSyringes ~/ 20 + 1) * 20;
      final freeSyringe = limit * 0.6;
      return MerzSyringePromotion._(limit, freeSyringe.round(), 60);
    }
    return list.firstWhereOrNull((element) => totalSyringes < element.purchasedSyringes);
  }

  static MerzSyringePromotion? getPromotion(int boxQuantity) {
    final totalSyringes = boxQuantity * 2;
    if (totalSyringes > 120) {
      final limit = totalSyringes ~/ 20 * 20;
      final freeSyringe = limit * 0.6;
      return MerzSyringePromotion._(limit, freeSyringe.round(), 60);
    }
    return list.reversed.firstWhereOrNull((element) => totalSyringes >= element.purchasedSyringes);
  }

  @override
  String toString() => 'MerzSyringePromotion(limit: $purchasedSyringes, freeSyringe: $freeSyringes)';
}

class MerzPromotionDialog extends StatelessWidget {
  const MerzPromotionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 640,
        height: 560,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text('Merz Syringe Promotions'),
                  const Spacer(),
                  CloseIconButton(),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Image.network(
                MerzSyringePromotion.bannerImageUrl,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Close'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
