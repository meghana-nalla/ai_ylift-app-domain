import 'dart:developer';

import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/core/constants/index.dart';
import 'package:YLift/models/simple/version_data.dart';
import 'package:dio/dio.dart';

const _frontendVersionUrl = '$API_WEB_LINK/health/version/frontend/release';
const _backendVersionUrl = '$API_WEB_LINK/health/version';

class VersionService {
  const VersionService._();

  static final _dio = Dio();

  static Future<VersionCode> checkFrontendVersion() async {
    try {
      final response = await _dio.get(_frontendVersionUrl);
      if (response.data is! String) return YLiftConstant.frontendVersion;
      final latestVersion = VersionCode.fromString(response.data);
      log('$latestVersion', name: 'Front-end Version');
      return latestVersion;
    } catch (e) {
      log('$e', name: 'Front-end Version');
      return YLiftConstant.frontendVersion;
    }
  }

  static Future<VersionCode> checkBackendVersion() async {
    try {
      final response = await _dio.get(_backendVersionUrl);
      if (response.data is! String) return YLiftConstant.backendVersion;
      final latestVersion = VersionCode.fromString(response.data);
      log('$latestVersion', name: 'Back-end Version');
      return latestVersion;
    } catch (e) {
      log('$e', name: 'Back-end Version');
      return YLiftConstant.backendVersion;
    }
  }
}
