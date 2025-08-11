import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:YLift/core/controllers/z-index_export.dart';



class BearerTokenInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final global = Get.find<GlobalController>();
    if (global.authToken.value.tokToken != '')
      options.headers['Authorization'] = 'Bearer ${global.authToken.value.tokToken}';
    super.onRequest(options, handler);
  }
}