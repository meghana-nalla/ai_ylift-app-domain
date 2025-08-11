import 'dart:convert';

import 'package:YLift/core/constants/index.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

import '../controllers/global.dart';

// const _videoBaseUrl = 'https://ylift.app/media/api/video';
// const _videoBaseUrl = 'http://127.0.0.1:8000/api/optimized/variant/video';

class ImageRepository {
  const ImageRepository();

  Future<String> getAsyncImageUrl(String uuid) async {
    final url = Uri.parse('$API_WEB_LINK/${ApiUrl.getImage.path}/$uuid');
    return '$url';
  }

  String getImageUrl(String uuid) {
    return '$API_WEB_LINK/${ApiUrl.getImage.path}/$uuid';
  }

  String getProductImageUrl(String productId) {
    return '$API_WEB_LINK/${ApiUrl.getProductImage.path}/$productId';
  }

  String getVideoUrl(String uuid) {
    return '$API_WEB_LINK/${ApiUrl.getVideo.path}/$uuid';
  }

  static String getBannerImage(String uuid){
    return '$API_WEB_LINK/${ApiUrl.getBannerImage.path}/$uuid';
  }

  // Future<String> getVideoUrl(String uuid) async {
  //   final url = Uri.parse('$_videoBaseUrl/$uuid');
  //   final response = await http.get(url);
  //
  //   if (response.statusCode >= 200 && response.statusCode < 300) {
  //     final data = jsonDecode(response.body) as Map<String, dynamic>;
  //     final imageUrl = data['optimized_url'] as String?;
  //     if (imageUrl == null) {
  //       throw Exception('No video found ($url)');
  //     }
  //
  //     return imageUrl;
  //   } else {
  //     throw Exception('API Error(${response.statusCode}: ${response.body}');
  //   }
  // }

  // // function to get the live stream of a video
  // Future<String> getVideoLiveStream(String uuid) async {
  //   final url = Uri.parse('$_videoBaseUrl/$uuid');
  //   final response = await http.get(url);
  //
  //   if (response.statusCode >= 200 && response.statusCode < 300) {
  //     final videoUrl = jsonDecode(response.body);
  //     return videoUrl;
  //   } else {
  //     throw Exception('API Error(${response.statusCode}: ${response.body})');
  //   }
  // }
}
