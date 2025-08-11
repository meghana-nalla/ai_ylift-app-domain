import 'package:flutter/widgets.dart';

class MobileNavigationTile extends StatelessWidget {
  final void Function() onTap;
  final String label;
  final Widget? trailing;

  const MobileNavigationTile({
    super.key,
    required this.label,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        color: const Color(0xFFFFFFFF),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 16),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
