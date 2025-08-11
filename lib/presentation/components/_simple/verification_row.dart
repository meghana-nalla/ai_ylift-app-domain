import 'package:flutter/material.dart';

class VerificationRow extends StatelessWidget {
  final String content;

  const VerificationRow({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(content, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(
          width: 120,
          child: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.greenAccent,
              ),
              const Text(
                'Recorded',
                style: TextStyle(fontSize: 18, color: Colors.greenAccent),
              ),
            ],
          ),
        ),
      ],
    );
  }
}