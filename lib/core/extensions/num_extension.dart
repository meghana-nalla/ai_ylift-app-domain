// class IntConverter {
//   const IntConverter._();
//
//   static int fromJson(dynamic value) {
//     if (value is String) return int.tryParse(value) ?? 0;
//     if (value is double) return value.toInt();
//     if (value is int) return value;
//     return 0;
//   }
//
//   static int? fromJsonNullable(dynamic value) {
//     if (value is String) return int.tryParse(value);
//     if (value is double) return value.toInt();
//     if (value is int) return value;
//     return null;
//   }
// }
//
// class DoubleConverter {
//   const DoubleConverter._();
//
//   static double fromJson(dynamic value) {
//     if (value is String) return double.tryParse(value) ?? 0.0;
//     if (value is num) return value.toDouble();
//     return 0.0;
//   }
//
//   /// Formula
//   ///
//   /// final percentage = 1 - ((a / b) * 100);
//   static double getPercentage(num a, num b) {
//     final percentage = 1 - (a / b);
//     return percentage * 100;
//   }
// }
