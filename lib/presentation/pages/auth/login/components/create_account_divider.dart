import 'package:flutter/material.dart';

class CreateAccountDivider extends StatelessWidget {
  const CreateAccountDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Color(0xFFE2E2E2),
            endIndent: 16,
          ),
        ),
        Text(
          'New to Y LIFT Store?',
          style: TextStyle(color: Color(0xFF787878), fontSize: 12),
        ),
        Expanded(
          child: Divider(
            color: Color(0xFFE2E2E2),
            indent: 16,
          ),
        ),
      ],
    );
  }
}
