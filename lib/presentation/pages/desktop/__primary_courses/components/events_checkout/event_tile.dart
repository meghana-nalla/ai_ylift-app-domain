import 'package:flutter/material.dart';

class EventTile extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String unlockMessage;
  final String? additionalMessage;
  final bool isSelected;
  final void Function()? onTap;

  const EventTile({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.unlockMessage,
    this.isSelected = false,
    this.additionalMessage,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFCC2155) : Colors.white,
          border: Border.all(
            color: isSelected ? Color(0xFFCC2155) : Colors.grey.shade300,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        width: 320,
        height: 100,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 13.33, color: fontColor),
                ),
                Text(
                  unlockMessage,
                  style: TextStyle(
                    fontSize: 13.33,
                    fontWeight: FontWeight.w600,
                    color: fontColor,
                  ),
                ),
                const SizedBox(height: 8),
                if (additionalMessage != null)
                  Text(
                    additionalMessage!,
                    style: TextStyle(
                      fontSize: 11.11,
                      color: fontColor,
                      decoration: TextDecoration.underline,
                      decorationColor:
                          isSelected ? Colors.white : Colors.black38,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color get fontColor => isSelected ? Colors.white : Colors.black;
}
