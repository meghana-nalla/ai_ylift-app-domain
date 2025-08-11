import 'dart:convert';
import 'dart:io';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:dio/dio.dart';
import 'package:YLift/core/constants/index.dart';
import 'bearer.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio()
      ..interceptors.add(BearerTokenInterceptor());
  }

  Future<bool> hasNetworkConnection() async {
    try {
      for (var interface in await NetworkInterface.list()) {
        if (interface.addresses.isNotEmpty) {
          //if ()
          return await canResolveDNS(); // Connected to some network
        }
      }
      return false; // No network connection found
    } catch (e) {
      print('Error checking network interfaces: $e');
      //throw new Exception('Internet connection lost. Please try again later.');
      return false;
    }
  }

  Future<bool> canResolveDNS() async {
    try {
      await InternetAddress.lookup('google.com'); // Or any other domain
      return true;
    } catch (e) {
      print('Error while trying to connect: $e');
      return false;
    }
  }

  Future<ApiService> init() async {
    // Perform any necessary async initialization here
    return this;
  }

  Future<Response> get(String url) async {
    final apiLink = '$API_WEB_LINK/$url';
    try {
      return await _dio.get(apiLink);
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<Response> getPdf(String url) async {
    final apiLink = '$API_WEB_LINK/$url';
    Duration timeout = Duration(seconds: 60);
    try {
      return await _dio.get(
        apiLink,
        options: Options(responseType: ResponseType.bytes, receiveTimeout:timeout),
      );
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }


  Future<Response> get_straight(String url) async {
    final apiLink = '$url';
    try {
      return await _dio.get(apiLink);
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<Response> get_auth(String url) async {
    final apiLink = 'https://ylift.app/api/v3/phantom/$url';
    try {
      return await _dio.get(apiLink);
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<Response> post_login(String extension, dynamic data) async {
    final apiLink = '$API_WEB_LINK/$extension';
    try {
      return await _dio.post(
        apiLink,
        data: data.toJson(),
        options: Options(
          // headers: headers,
        ),
      );
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<Response> post(String extension, dynamic data) async {
    final apiLink = '$API_WEB_LINK/$extension';
    // final headers = {
    //   magicHeader: magicHeaderValue,
    //   'Content-Type': 'application/json',
    // };
    try {
      print('Sending POST request to: $apiLink');
      print('Request data: ${jsonEncode(data)}');
      final response = await _dio.post(
        apiLink,
        data: jsonEncode(data),  // Encode the data as JSON
        // options: Options(
        //   headers: headers,
        // ),
      );
      print('Response status code: ${response.statusCode}');
      print('Response data: ${response.data}');
      return response;
    } on DioException catch (e) {
      print('DioException caught:');
      print('  Request: ${e.requestOptions.uri}');
      print('  Response: ${e.response?.data}');
      _handleDioError(e);
      rethrow;
    }
  }

  Future<PhantomResponse> getData(String url) async {
    final apiLink = '$API_WEB_LINK/$url';
    try {
      return PhantomResponse.fromDio(await _dio.get(apiLink));

    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }



  Future<PhantomResponse> postLoginData(String extension, dynamic data) async {
    final apiLink = '$API_WEB_LINK/$extension';
    try {
      final response =  await _dio.post(apiLink, data: data?.toJson() );
      //if (response.statusCode == 200 || response.statusCode == 201) {
        return PhantomResponse.fromDio(response);
      // }
      // else {
      //   // Error
      //   _extractMessageFromResponse(response, {}, isError: true, statusCode: response.statusCode);
      // }
    } on DioException catch (e) {
      _handleDioError(e);
      if (await hasNetworkConnection()) {
        throw 'There was a problem. Please try your action again. If it still doesn\'t work, our support team is ready to help at 1-212-861-7787.';
        //rethrow;
      } else {
        rethrow;
        //throw 'Internet connection lost. Please try again later.';
      }
    }
  }

  Future<PhantomResponse> postData(String path, dynamic data, {Map<String, String>? queryParameters, Options? options}) async {
    try {
      final apiLink = '$API_WEB_LINK/$path';
      final response = await _dio.post(apiLink, data: data,queryParameters: queryParameters, options: options);
      return PhantomResponse.fromDio(response);
    } on DioException catch(e) {
      _handleDioError(e);
      rethrow;
    } catch (e, stackTrace){
      print("Error in POST_DATA request: $e");
      print("Stack trace: $stackTrace");
      rethrow;
    }
  }
  Future<PhantomResponse> postMulitData(String path, dynamic data, {Map<String, String>? queryParameters}) async {
    try {
      final apiLink = '$API_WEB_LINK/$path';
      final response = await _dio.post(apiLink, data: data,queryParameters: queryParameters, options: Options(headers: {'Content-Type': 'multipart/form-data'}));
      return PhantomResponse.fromDio(response);
    } catch (e, stackTrace) {
      print("Error in POST_DATA request: $e");
      print("Stack trace: $stackTrace");
      rethrow;
    }
  }

  Future<PhantomResponse> putData(String path, dynamic data) async {
    try {
      final apiLink = '$API_WEB_LINK/$path';
      final response = await _dio.put(apiLink, data: data);
      return PhantomResponse.fromDio(response);
    } catch (e, stackTrace) {
      print("Error in PUT_DATA request: $e");
      print("Stack trace: $stackTrace");
      rethrow;
    }
  }

  Future<PhantomResponse> deleteData(String extension, {Map<String, String>? queryParameters}) async {
    try {
    final apiLink = '$API_WEB_LINK/$extension';
    final response = await _dio.delete(apiLink, queryParameters: queryParameters);
    return PhantomResponse.fromDio(response);
    } catch (e, stackTrace) {
      print("Error in DELETE_DATA request: $e");
      print("Stack trace: $stackTrace");
      rethrow;
    }
  }


  Future<Response> put(String path, dynamic data) async {
    try {
      final apiLink = '$API_WEB_LINK/$path';
      final response = await _dio.put(apiLink, data: data);

      return response;
    } catch (e, stackTrace) {
      print("Error in PUT request: $e");
      print("Stack trace: $stackTrace");
      rethrow;
    }
  }

  Future<Response> delete(String extension) async {
    final apiLink = '$API_WEB_LINK/$extension';
    // final headers = {
    //   // magicHeader: magicHeaderValue,
    // };
    try {
      final response = await _dio.delete(
        apiLink,
        // options: Options(
        //   // headers: headers,
        // ),
      );
      return response;
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  String _extractMessageFromResponse(dynamic responseData, Map<String, String> messages, {bool isError = false, int? statusCode}) {
    if (responseData is Map<String, dynamic>) {
      if (responseData.containsKey('status')) {
        final String status = responseData['status'];
        if (messages.containsKey(status)) {
          return messages[status]!;
        } else if (responseData.containsKey('message')) {
          return responseData['message'];
        } else if (responseData.containsKey('data') && responseData['data'] is Map<String, dynamic> && responseData['data'].containsKey('message')) {
          return responseData['data']['message'];
        } else if (!isError){
          return "Success: Operation completed.";
        } else {
          return "Error: An error occurred.";
        }

      } else if (responseData.containsKey('message')) {
        return responseData['message'];
      } else if (responseData.containsKey('data') && responseData['data'] is Map<String, dynamic> && responseData['data'].containsKey('message')) {
        return responseData['data']['message'];
      }
    } else if (responseData is String) {
      return responseData; // Direct string message
    }

    if(!isError) {
      return "Success: Operation completed.";
    } else if (statusCode != null) {
      return "Error: Server returned status code $statusCode";
    } else {
      return "Error: An error occurred.";
    }
  }

  void _handleDioError(DioException e) {
    if (e.response != null) {
      // Server returned an error response
      final int? statusCode = e.response?.statusCode;
      final dynamic errorData = e.response?.data;

      String message = _extractMessageFromResponse(errorData, {}, isError: true, statusCode: statusCode);
      if (message.isNotEmpty) {
        print(message); // Return the extracted message
        throw(message);
      }
      if (statusCode == 400) {
        print("Bad Request: Please check your input.");
        throw ("Bad Request: Please check your input.");
      } else if (statusCode == 401) {
        print("Unauthorized: Please log in.");
        throw("Unauthorized: Please log in.");
      } else if (statusCode == 403) {
        print("Forbidden: You don't have permission to access this resource.");
        throw("Forbidden: You don't have permission to access this resource.");
      } else if (statusCode == 404) {
        print("Not Found: The requested resource was not found.");
        throw("Not Found: The requested resource was not found.");
      } else if (statusCode == 500) {
        print("Internal Server Error: Please try again later.");
        throw("Internal Server Error: Please try again later.");
      } else if (statusCode == 503) {
        print("Service Unavailable: The server is currently unavailable.");
        throw("Service Unavailable: The server is currently unavailable.");
      }
    } else if (e.type == DioExceptionType.connectionTimeout) {
      print("Connection Timeout: Please check your internet connection.");
      throw("Connection Timeout: Please check your internet connection.");
    } else if (e.type == DioExceptionType.receiveTimeout) {
      print("Receive Timeout: The server took too long to respond.");
      throw("Receive Timeout: The server took too long to respond.");
    } else if (e.type == DioExceptionType.sendTimeout) {
      print("Send Timeout: Failed to send the request.");
      throw("Send Timeout: Failed to send the request.");
    } else if (e.type == DioExceptionType.cancel) {
      print("Request Cancelled.");
      throw("Request Cancelled.");
    } else if (e.type == DioExceptionType.unknown) {
      print("A network error occurred. Please check your internet connection and try again.");
      throw("A network error occurred. Please check your internet connection and try again.");
    }

    print("An error occurred. Please try again later.");
    throw("An error occurred. Please try again later.");
  }
}