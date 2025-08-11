import 'package:flutter/material.dart';
import 'package:YLift/core/services/theme.dart';

class YLiftAppBar extends StatelessWidget implements PreferredSizeWidget {

  const YLiftAppBar({
    super.key,
    this.titleText,
  });

  final String? titleText;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(titleText ?? "Y Lift Store"),
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
      titleTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.onPrimary,
        fontSize: 20.0,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}