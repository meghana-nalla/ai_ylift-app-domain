import 'package:galaxy_models/galaxy_models.dart';
import 'package:flutter/material.dart';

class OrderRuleTile extends StatelessWidget {
  final CartOrderRule orderRule;
  final void Function()? onTap;
  const OrderRuleTile({
    super.key,
    required this.orderRule,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                orderRule.ruleMessage,
                style: TextStyle(color: Colors.white, fontSize: 13.33),
              ),
              if (orderRule.ruleType == 'QUANTITY' &&
                  orderRule.requiredQuantity > 0)
                Text(
                  'Add ${orderRule.requiredQuantity} more >>',
                  style: TextStyle(
                    fontSize: 13.33,
                    color: YLiftColor.orange,
                    decoration: TextDecoration.underline,
                    decorationColor: YLiftColor.orange,
                  ),
                ),
              if (orderRule.spendingLeft != null)
                Text(
                  '${orderRule.spendingLeft!.toCurrency()} left.',
                  style: TextStyle(
                    fontSize: 13.33,
                    color: YLiftColor.orange,
                    decoration: TextDecoration.underline,
                    decorationColor: YLiftColor.orange,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
