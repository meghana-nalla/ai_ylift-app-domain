import 'package:get/get.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:YLift/core/controllers/z-index_export.dart';
import 'package:galaxy_models/galaxy_models.dart';

class OnboardController extends GetxController {
  final GlobalController global = Get.find<GlobalController>();

  Map<String, dynamic>? basicInformationForm;
  Map<String, dynamic>? medicalLicenseForm;
  Map<String, dynamic>? shippingInformationForm;
  Map<String, dynamic>? billingInformationForm;


  OnboardingProcess _process = OnboardingProcess.basicInformation;
  OnboardingProcess get process => _process;
  String? errorMessage;


  void setErrorMessage(String? msg) {
      errorMessage = msg;
  }

  Future<void> setProcess(OnboardingProcess process) async {
    _process = process;
  }

  Future<Map<String, dynamic>> processConstructPayload(OnboardingProcess currentProcess){
    try {
      return Future.value(constructPayload(currentProcess));
    } catch (e, s) {
      print('Error constructing payload: $e\n$s');
      return Future.value({});
    }
  }


  Map<String, dynamic> constructPayload(OnboardingProcess currentProcess) {
    final basePayload = global.signUpPayload;

    if (basicInformationForm != null) {
      basePayload["firstName"] = basicInformationForm!['firstName'];
      basePayload["lastName"] = basicInformationForm!['lastName'];
      basePayload["practiceName"] = basicInformationForm!['practiceName'];
      basePayload["phone"] = basicInformationForm!['phoneNumber'];
      basePayload["secondaryEmail"] = basicInformationForm!['email'];
    }

    if (medicalLicenseForm != null && medicalLicenseForm!.isNotEmpty) {
      basePayload["specialty"] = medicalLicenseForm;
    } else {
      basePayload['specialty'] = {};
    }

    // next comes billing and payment ...
    if (billingInformationForm != null) {
      final firstName = billingInformationForm!['nameFirst'] ?? billingInformationForm!['firstName'];
      final lastName = billingInformationForm!['nameLast'] ?? billingInformationForm!['lastName'];
      final fullName = '$firstName $lastName';

      // setup the billing address
      basePayload["billingAddress"] = {
        "firstName": firstName,
        "lastName": lastName,
        "name": fullName,
        "line1": billingInformationForm!['address1'],
        "line2": billingInformationForm!['address2'],
        "city": billingInformationForm!['city'],
        "state": billingInformationForm!['state'],
        "zip": billingInformationForm!['zipCode'],
        "phone": basePayload['phone'],
      };

      // if month is less than 10 add a 0 in front
      final month = billingInformationForm!['cardExpiryMonth'].length == 1
          ? "0${billingInformationForm!['cardExpiryMonth']}"
          : billingInformationForm!['cardExpiryMonth'];

      // setup the cardDetails
      basePayload["cardDetails"] = {
        "name": fullName,
        "cardNumber": billingInformationForm!['cardNumber'],
        "expiryMonth": month,
        "expiryYear": billingInformationForm!['cardExpiryYear'],
        "cvv": billingInformationForm!['cardCvv'],
      };
      basePayload["cardDetailsCreate"] = {
        "name": fullName,
        "cardNumber": billingInformationForm!['cardNumber'],
        "expiryMonth": month,
        "expiryYear": billingInformationForm!['cardExpiryYear'],
        "cvv": billingInformationForm!['cardCvv'],
      };
      // setup the customerProfile (card info is in cardDetails)
      basePayload["customerProfile"] = {
        "cardNumber": "",
        "expirationDate": "",
        "nameFirst": firstName,
        "firstName": firstName,
        "nameLast": lastName,
        "lastName": lastName,
        "address": billingInformationForm!['address1'],
        "address2": billingInformationForm!['address2'],
        "city": billingInformationForm!['city'],
        "state": billingInformationForm!['state'],
        "zip": billingInformationForm!['zipCode'],
        "phoneNumber": shippingInformationForm?['phone'] ?? "string",
        "default": billingInformationForm!['default'],
      };
    }

    // now, handle shipping information
    if (shippingInformationForm != null) {
      basePayload['shippingAddress'] = {
        'name': shippingInformationForm!['name'],
        'phone': shippingInformationForm!['phone'],
        'line1': shippingInformationForm!['line1'],
        'line2': shippingInformationForm!['line2'] ?? '',
        'city': shippingInformationForm!['city'],
        'state': shippingInformationForm!['state'],
        'zip': shippingInformationForm!['zip'],
        'isSameShipping': shippingInformationForm!['isSameBilling'],
        'country': 'United States',
        'isDeleted': false,
        'valid': true,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      };
    }

    if (currentProcess.index == OnboardingProcess.values.last.index) {
      basePayload['signUpProcess'] = 4;
    }

    return basePayload;
  }


  Future<void> goToNextProcess(Map<String, dynamic> formData, OnboardingProcess nextProcess) async {

    setErrorMessage(null);
    switch (process) {
      case OnboardingProcess.basicInformation:
        basicInformationForm = formData;
        break;
      case OnboardingProcess.billingInformation:
        billingInformationForm = formData;
        break;
      case OnboardingProcess.shippingInformation:
        shippingInformationForm = formData;
        break;
      case OnboardingProcess.medicalLicense:
        medicalLicenseForm = formData;
        break;
      case OnboardingProcess.confirm:
        break;

    }

    print('Going to next process: $nextProcess');

    try {
      if (process == OnboardingProcess.confirm) {
        return;
      } else {
        final payload = await processConstructPayload(process);
        await global.auth.updateSignUpData(payload);
      }
      _process = nextProcess;
      global.refresh();
    } catch (e, s) {
      print('Error updating onboarding status: $e\n$s');
      final rError = '$e';
        errorMessage = rError.split(': ').last;
        global.refresh();
      return;
    }
  }
}