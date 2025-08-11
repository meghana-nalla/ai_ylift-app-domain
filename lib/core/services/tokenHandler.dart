import 'dart:convert';
import 'package:galaxy_models/galaxy_models.dart';


class AuthenticationHandler {
  static AuthToken parseAuthResponse(String response) {
    try {
      final jsonStart = response.indexOf('{');
      final jsonEnd = response.lastIndexOf('}') + 1;
      final jsonStr = response.substring(jsonStart, jsonEnd);

      final json = jsonDecode(jsonStr);

      return AuthToken.fromJson(json);
    } catch (e) {
      throw FormatException('Failed to parse authentication response: $e');
    }
  }
       vvvveJwtPayload(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) throw FormatException('Invalid JWT format');

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      return json.decode(decoded);
    } catch (e) {
      throw FormatException('Failed to decode JWT: $e');
    }
  }
}
