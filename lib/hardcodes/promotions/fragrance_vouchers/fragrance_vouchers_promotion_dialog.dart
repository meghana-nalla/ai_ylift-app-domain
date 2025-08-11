
import 'package:YLift/hardcodes/promotions/fragrance_vouchers/fragrance_vouchers_promotion_data.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
class FragranceVouchersPromotionDialog extends StatelessWidget {
  const FragranceVouchersPromotionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 640,
        height: 560,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Text('Fragrance Vouchers Promotion', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    CloseIconButton(),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Image.network(
                FragranceVoucersPromotionData.imageUrl,
              ),
              const SizedBox(height: 32),
              Text('Men\'s Fragrances', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
              Image.network(
                FragranceVoucersPromotionData.mensFragrance,
              ),
              const SizedBox(height: 32),
              Text('Women\'s Fragrances', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
              Image.network(
                FragranceVoucersPromotionData.womensFragrance,
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
      ),
    );
  }
}