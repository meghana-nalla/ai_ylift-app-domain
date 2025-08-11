// import 'package:intl/intl.dart';
//
// class DateTimeUtils {
//   const DateTimeUtils._();
//
//   static DateTime fromJson(dynamic value) {
//     if (value == -1) {
//       return DateTime.now();
//     }
//
//     if (value is! String) {
//       throw Exception('Invalid DateTime value: $value');
//     }
//     try {
//       // Try ISO 8601 parsing first
//       try {
//         return DateTime.parse(value);
//       } catch (_) {}
//
//       // Then try formatted strings
//       value = value.replaceFirst('EST ', '');
//       value = value.replaceFirst('EDT ', '');
//       final formatter = DateFormat("EEE MMM dd HH:mm:ss yyyy");
//       final format = formatter.tryParse(value);
//       if (format != null) return format;
//
//       // Finally try milliseconds
//       final millisecondsSinceEpoch = int.tryParse(value);
//       if (millisecondsSinceEpoch != null) {
//         return DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
//       }
//
//       throw Exception('Could not parse datetime: $value');
//     } catch (e, s) {
//       print('$e\n$s');
//       throw Exception('Failed to parse datetime: $value');
//     }
//   }
//
//   static DateTime? fromJsonNullable(dynamic value){
//     try{
//       return fromJson(value);
//     } catch (e){
//       return null;
//     }
//   }
// }
