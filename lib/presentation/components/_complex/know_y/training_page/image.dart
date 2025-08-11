/*
  The image component to display at the top of the training detail page
*/

import 'package:flutter/material.dart';

class KnowYTrainingPageImage extends StatelessWidget {
  const KnowYTrainingPageImage({
    super.key,
    required this.imageText,
  });

  final String imageText;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[300], // Placeholder color for the image
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 10,
            right: 10,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.image),
              label: Text("View Gallery"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                textStyle: TextStyle(fontSize: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  imageText,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}