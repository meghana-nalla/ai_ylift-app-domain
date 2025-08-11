import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/presentation/components/_complex/desktop_view/gap.dart';
import 'package:YLift/presentation/components/_complex/forms/add_card_form.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
class AddCardPaymentDialog extends StatelessWidget {
  const AddCardPaymentDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Dialog(
        backgroundColor: Colors.white,
        shape: const Border(),
        child: SizedBox(
          width: 640,
          child: Padding(
            padding: const EdgeInsets.all(YLiftConstant.gap),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Add Card', style: TextStyle(fontSize: 24)),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.clear),
                    ),
                  ],
                ),
                const Divider(height: YLiftConstant.gap * 2),
                AddPaymentCardForm(
                  newCard: {},
                  onChanged: (data) {},
                ),
                const GapY(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      child: YLiftFilledButton(
                        backgroundColor: const Color(0xFFD1D3D4),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                    ),
                    const GapX(),
                    SizedBox(
                      width: 200,
                      child: YLiftFilledButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
