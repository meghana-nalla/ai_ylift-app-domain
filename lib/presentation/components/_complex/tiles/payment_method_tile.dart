import 'package:YLift/core/constants/color.dart';
import 'package:YLift/core/constants/constant.dart';
import 'package:flutter/material.dart';

class PaymentMethodTile extends StatelessWidget {
  final Widget? paymentIcon;
  final String methodName;
  final Widget? trailing;
  final Widget? delete;
  final Widget? edit;
  final bool isSelected;
  final DateTime? expirationDate;

  final void Function() onSelected;

  const PaymentMethodTile({
    super.key,
    this.paymentIcon,
    required this.methodName,
    this.trailing,
    this.delete,
    this.edit,
    this.isSelected = false,
    required this.onSelected,
    this.expirationDate,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? YLiftColor.beige : Colors.white,
      shape: RoundedRectangleBorder(
        side:
            isSelected
                ? BorderSide.none
                : const BorderSide(color: YLiftColor.grey, width: 1),
      ),
      child: InkWell(
        onTap: onSelected,
        hoverColor: YLiftColor.beige,
        focusColor: YLiftColor.beige,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
          child: Row(
            children: [
              if (paymentIcon != null) ...[
                paymentIcon!,
                const SizedBox(width: YLiftConstant.gap),
              ],
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(methodName),
                  if (expirationDate != null)
                    Text(
                      'Expire on ${expirationDate!.month}/${expirationDate!.year}',
                      style: const TextStyle(fontSize: 11.11),
                    ),
                ],
              ),
              const Spacer(),
              if (delete != null) delete!,
              if (edit != null) edit!,
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}

class DefaultIcon extends StatelessWidget {
  const DefaultIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const ShapeDecoration(
        color: YLiftColor.beige,
        shape: StadiumBorder(),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: const Text('Default', style: TextStyle(fontSize: 12)),
    );
  }
}
