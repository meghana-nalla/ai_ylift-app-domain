import 'dart:developer';

import 'package:YLift/core/controllers/galderma_promotion/index.dart';
import 'package:YLift/hardcodes/promotions/fragrance_vouchers/galderma_promotion_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:galaxy_ui/galaxy_ui.dart';

class PracticeLuxurySelectGiftDialog extends StatefulWidget {
  final PracticeLuxuryPromotionData promotion;
  const PracticeLuxurySelectGiftDialog({super.key, required this.promotion});

  @override
  State<PracticeLuxurySelectGiftDialog> createState() =>
      _PracticeLuxurySelectGiftDialogState();
}

class _PracticeLuxurySelectGiftDialogState
    extends State<PracticeLuxurySelectGiftDialog> {
  final galdermaController = Get.find<GaldermaController>();
  String? selectedReward;

  void selectReward(String value) async {
    galdermaController.setReward(value);
    selectedReward = value;
    // galdermaController.selectedRewards.value = [value];
    log('PRACTICE LUXURY SELECTED REWARD: $value');
  }

  @override
  void initState() {
    if (galdermaController.selectedRewards.isNotEmpty) {
      selectedReward = galdermaController.selectedRewards.first;
    } else if (widget.promotion.selectableItems.length == 1) {
      selectedReward = widget.promotion.selectableItems.first;
      selectReward(selectedReward!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 540,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(width: 16),
                  Text(
                    'Practice Luxury Tier ${widget.promotion.tierLevel} Reward',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  const CloseIconButton(),
                  const SizedBox(width: 16),
                ],
              ),
              const SizedBox(height: 16),
              Image.network(widget.promotion.imageUrl),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Select Reward', style: TextStyle(fontSize: 13.33)),
                    const SizedBox(height: 4),
                    DropdownMenu(
                      initialSelection: selectedReward,
                      hintText: 'Select your reward',
                      expandedInsets: EdgeInsets.zero,
                      menuHeight: 400,
                      onSelected: (value) {
                        if (value == null) return;
                        selectReward(value);
                      },
                      dropdownMenuEntries:
                      widget.promotion.selectableItems
                          .map((e) => DropdownMenuEntry(value: e, label: e))
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Upon placing the order, you will be contacted by Y Lift Store to confirm color, size, or other details that is applicable to the selected reward.',
                      style: TextStyle(fontSize: 11.11),
                    ),
                    OverflowBar(
                      alignment: MainAxisAlignment.end,
                      children: [
                        RoundedFilledButton(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 24,
                          ),
                          onPressed: () {
                            selectReward(selectedReward!);
                            Navigator.pop(context);
                          },
                          child: const Text('Select Reward'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}