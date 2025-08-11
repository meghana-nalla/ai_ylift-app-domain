import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/core/services/bearer.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/models/api/z-index_export.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;

class TrainingController extends GetxController {
  final global = Get.find<GlobalController>();

  final RxMap<String, dynamic> trainingsLog = <String, dynamic>{}.obs;
  
  Future<void> initForm() async{
    final trainingName = global.trainingInterest.value.tagName!;
    final profileId = global.user.value.profileId;
    final queryParameters = <String, String>{
      'trainingName': trainingName,
      'profileId': '$profileId',
    };
    try {
      final response = await global.api.postData(
          'profiles/provider/trainings/init/signup', null,
          queryParameters: queryParameters);
      if (response.isSuccess) {
        final x = response.data!['trainingsLog'];
        trainingsLog.value = x!;
        log('Training registration for $trainingName has been initiated!');
      } else {
        throw Exception(
            response.message ?? 'Failed to initiate training registration');
      }
    } catch (e) {
      log("Error on training controller $e .");
    }
  }




  Future<void> signUpForm(Map<String, dynamic> data) async {
    final tagName = global.trainingInterest.value.tagName!;
    final profileId = global.user.value.profileId;
    final queryParameters = <String, String>{
      'trainingName': tagName,
      'profileId': '$profileId'
    };
    final response = await global.api.postData(
      'profiles/provider/trainings/signup/form',
      data,
      queryParameters: queryParameters,
    );

    if (response.isSuccess) {
      trainingsLog.value = response.data!['trainingsLog'];
      print('signup successfull');
    } else {
      throw Exception(response.message ?? 'Failed to sign up for training');
    }
  }

  Future<Uint8List> getDocumentPdf() async {
    // final response = await global.api.getPdf(ApiUrl.getTrainingPDF.path);
    // return response.data as Uint8List;
    final dio = Dio();
    dio.interceptors.add(BearerTokenInterceptor());
    final response = await dio.get(
      'https://ylift.app/api/v3/phantom/profiles/provider/trainings/provider/pdf',
      options: Options(responseType: ResponseType.bytes),
    );
    final pdfBytes = response.data as Uint8List;
    return pdfBytes;
  }

  Future<void> signDocumentPdf({required Map<String, dynamic> form,required Uint8List signatureImage,}) async {
    final requestData = FormData.fromMap({
      'trainingName': global.trainingInterest.value.tagName!,
      'form_data': json.encode(form),
      'signature': MultipartFile.fromBytes(filename:'signature', signatureImage),
    });

    final response = await global.api.postMulitData(ApiUrl.signTrainingPDF.path,requestData);
    if (response.isSuccess) {
      print('Document signed successfully');
    } else {
      throw Exception(response.message ?? 'Failed to sign document');
    }
  }

  Future<PhantomResponse> oneTimePayment({required String trainingName,required int profileId,required String paymentCardId, int? tax}) async {
    // Remember that tax coming from the backend is in dollars then we converted it to cents
    // so in here we need to convert it back to dollars
    final data = <String, dynamic>{
      'trainingName': global.trainingInterest.value.tagName!,
      'profileId': profileId,
      'oneTimePaymentCardId': paymentCardId,
      if(tax != null) 'tax': tax ~/ 100,
    };
    // print(data);
    // throw Exception('test');
    PhantomResponse response = await global.api.putData('profiles/provider/trainings/payment', data);
    if (response.isSuccess) {
      print('Payment successfull');
      trainingsLog.value = response.data!['trainingsLog'];
      return response;
    } else {
      throw Exception(response.message ?? 'Failed to make payment');
    }
  }

  Future<PhantomResponse> monthlyPayment({required String trainingName, required int profileId,required String paymentCardId}) async {
    final data = <String, dynamic>{
      'trainingName': global.trainingInterest.value.tagName!,
      'profileId': profileId,
      'subscriptionCardId': paymentCardId,
    };
    PhantomResponse response = await global.api.putData('profiles/provider/trainings/payment', data);
    if (response.isSuccess) {
      print('Payment successfull');
      trainingsLog.value = response.data!['trainingsLog'];
      refresh();
      return response;
    } else {
      throw Exception(response.message ?? 'Failed to make payment');
    }
  }
}
