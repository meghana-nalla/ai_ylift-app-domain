import 'package:web/web.dart' as html;

class AuthCookieHandler {

  static const String _bearerTokenKey = 'AuthieToken';

  static void saveAuthData(String authieCookie) {
    html.window.localStorage.setItem(_bearerTokenKey, authieCookie);
  }

  static String? getBearerToken() {
    return html.window.localStorage.getItem(_bearerTokenKey);
  }

  static void clearAuthData() {
    html.window.localStorage.removeItem(_bearerTokenKey);
  }

  static bool isAuthenticated() {
    return getBearerToken() != null;
  }
}
