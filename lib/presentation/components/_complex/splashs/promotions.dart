import 'package:flutter/material.dart';

class PromotionScreen extends StatelessWidget {
  final VoidCallback onClose;

  PromotionScreen({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Image.network(
              'https://ylift.app/api/v2/mars/file/test/Artboard1_6.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 80,
            right: 20,
            child: ElevatedButton(
              onPressed: onClose,

              child: Text('x'),
            ),
          ),
        ],
      ),
    );
  }
}