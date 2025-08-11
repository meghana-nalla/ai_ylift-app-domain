import 'package:flutter/widgets.dart';

extension BuildContextExtension on BuildContext {
  bool get isMobile => MediaQuery.of(this).size.shortestSide < 600;
}
