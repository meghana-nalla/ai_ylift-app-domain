import 'package:galaxy_models/galaxy_models.dart';

class LoginResult {
  final bool success;
  final String message;
  final bool requiresRedirect;
  final PhantomResponse? phantomResponse;

  LoginResult({
    required this.success,
    required this.message,
    this.requiresRedirect = false,
    this.phantomResponse,
  });
}