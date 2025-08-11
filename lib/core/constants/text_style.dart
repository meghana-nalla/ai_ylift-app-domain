import 'package:YLift/core/constants/color.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';

const _acidGroteskFamily = 'Acid Grotesk';

class YLiftTextStyle {
  const YLiftTextStyle._();

  static final headline = GoogleFonts.poppins(fontSize: 56);
  static const title = TextStyle(fontFamily: _acidGroteskFamily, fontSize: 26, fontWeight: FontWeight.bold);
  static final subtitle1 = GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w500);
  static final subtitle2 = GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold);
  static final bodyLarge = GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500);
  static final bodyMedium = GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500);
  static final bodySmall = GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500);

  static final descriptionGrey =
      GoogleFonts.poppins(fontSize: 11.11, fontWeight: FontWeight.w500, color: YLiftColor.grey);
}
