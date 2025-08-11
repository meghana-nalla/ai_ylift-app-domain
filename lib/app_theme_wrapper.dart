import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/services/theme.dart';

class AppThemeWrapper extends StatelessWidget {
  final Widget child;

  const AppThemeWrapper({Key? key, required this.child}) : super(key: key);

  TextTheme _createTextTheme(BuildContext context) {
    return Theme.of(context).textTheme.apply(
      fontFamily: GoogleFonts.inter().fontFamily, // Default Material font as base
      displayColor: Theme.of(context).colorScheme.onBackground,
      bodyColor: Theme.of(context).colorScheme.onBackground,
    );
  }

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    final textTheme = _createTextTheme(context);
    final materialTheme = MaterialTheme(textTheme);

    return Theme(
      data: brightness == Brightness.light
          ? materialTheme.light()
          : materialTheme.dark(),
      child: child,
    );
  }
}