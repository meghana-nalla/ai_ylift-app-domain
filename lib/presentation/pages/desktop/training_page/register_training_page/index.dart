import 'dart:typed_data';

import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/components/_complex/desktop_view/page_scaffold.dart';
import 'package:YLift/presentation/components/_complex/dialogs/select_address_field.dart';
import 'package:YLift/presentation/components/_complex/dropdowns/card_payment_dropdown.dart';
import 'package:YLift/presentation/components/_complex/panels/wallets_panel.dart';
import 'package:YLift/presentation/pages/desktop/training_page/register_training_page/components/registration_step.dart';
import 'package:YLift/presentation/pages/desktop/training_page/register_training_page/components/text_field_label.dart';
import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:signature/signature.dart';
import 'package:galaxy_ui/galaxy_ui.dart';

class RegisterTrainingPage extends StatefulWidget {
  const RegisterTrainingPage({super.key});

  @override
  State<RegisterTrainingPage> createState() => _RegisterTrainingPageState();
}

class _RegisterTrainingPageState extends State<RegisterTrainingPage> {
  final GlobalController global = Get.find();
  static const _textFieldWidth = 320.0;
  static const _textFieldLabelStyle = TextStyle(fontSize: 12);

  final formKey = GlobalKey<FormState>();
  final healthCareProvider = TextEditingController();
  final providerEmail = TextEditingController();
  // final licensedState = TextEditingController();
  String? licensedState;
  String? usStateErrorMessage;
  final officeLocation = TextEditingController();
  String? formErrorMessage;

  final documentFormKey = GlobalKey<FormState>();
  Uint8List? pdfBytes;
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final initialsController = TextEditingController();
  final signatureController = SignatureController();
  String? signatureErrorMessage;

  AddressSimple? billingAddress; // This only used for MagnYm training
  int? tax;
  String? taxErrorMessage;

  CardPayment? oneTimePaymentCard;
  String? oneTimePaymentErrorMessage;

  CardPayment? monthlyPaymentCard;
  String? monthlyPaymentErrorMessage;

  int registrationStep = 1;

  Map<String, dynamic> trainingPayload = {
    'firstName': '',
    'lastName': '',
    'healthCarProvider': '',
    'providerEmail': '',
    'licensedState': '',
    'officeLocation': '',
    'signature': '',
    'registrationStep': 1,
  };

  // FIRST STEP
  void saveRegisterTrainingForm() async {
    try {
      setState(() {
        usStateErrorMessage = null;
      });
      if (licensedState == null) {
        setState(() {
          usStateErrorMessage = 'Enter license state';
        });
      }
      final isFormValid = formKey.currentState!.validate();
      if (!isFormValid || usStateErrorMessage != null) return;

      final form = <String, dynamic>{
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'healthCareProvider': healthCareProvider.text,
        'providerEmail': providerEmail.text,
        'licensedState': licensedState!,
        'officeLocation': officeLocation.text,
        // 'signature': '',
        // 'registrationStep': 1,
      };
      await global.training.signUpForm(form);
      getPDF();
      setState(() {
        registrationStep = 2;
      });
    } catch (e) {
      formErrorMessage = 'Failed to save form, please try again later.';
    } finally {
      setState(() {});
    }
  }

  bool isFetchingPdf = false;
  String? pdfErrorMessage;
  void getPDF() async {
    if (isFetchingPdf) return;
    try {
      isFetchingPdf = true;
      final bytes = await global.training.getDocumentPdf();
      setState(() {
        pdfBytes = bytes;
      });
    } catch (e, s) {
      pdfErrorMessage = 'Failed to retrieve document, please try again later.\n'
          'If this keeps happening, please contact support at info@ylift.com or call +1 (212) 861-7787';
      print('$e, $s');
    } finally {
      setState(() {
        isFetchingPdf = false;
      });
    }
  }

  // SECOND STEP
  void signDocument() async {
    try {
      setState(() {
        signatureErrorMessage = null;
      });
      if (signatureController.isEmpty) {
        setState(() {
          signatureErrorMessage = 'Please sign the document';
        });
        return;
      }

      final signatureImage = await signatureController.toPngBytes();

      await global.training.signDocumentPdf(
        form: {
          'name': '${firstNameController.text} ${lastNameController.text}',
          'state': licensedState!,
          'address': officeLocation.text,
        },
        signatureImage: signatureImage!,
      );

      setState(() {
        registrationStep = 3;
      });
    } catch (e) {
      signatureErrorMessage = 'Failed to sign document, please try again later.';
    } finally {
      setState(() {});
    }
  }

  void calculateTax(int addressId) async {
    try{
      setState(() {
        taxErrorMessage = null;
      });

      final taxAmount = await global.basket.calculateTax(
        addressId: addressId,
        amount: 4000,
      );
      setState(() {
        tax = taxAmount;
      });
    } catch (e){
      setState(() {
        taxErrorMessage = 'Error calculating tax, please try different address or try again later';
      });
    }

  }

  // THIRD STEP
  void payOneTime() async {
    final trainingName = global.trainingInterest.value.tagName!;
    try {
      setState(() {
        oneTimePaymentErrorMessage = null;
      });
      if(trainingName == 'MagnYm' && billingAddress == null){
        setState(() {
          oneTimePaymentErrorMessage = 'Please select a billing address';
        });
        return;
      }
      if (oneTimePaymentCard == null) {
        setState(() {
          oneTimePaymentErrorMessage = 'Please select a card';
        });
        return;
      }

      int? tax;
      if(trainingName == 'MagnYm' && billingAddress != null){
        final addressId = int.parse(billingAddress!.addressId);
        tax = await global.basket.calculateTax(
          addressId: addressId,
          amount: 4000,
        );
      }

      await global.training.oneTimePayment(
        trainingName: trainingName,
        profileId: global.user.value.profileId,
        paymentCardId: oneTimePaymentCard!.id,
        tax: tax,
      );

      setState(() {
        registrationStep = 4;
      });
    } catch (e) {
      print('error paying one time: $e');
      oneTimePaymentErrorMessage = 'Error paying one time, please try again later.';
    } finally {
      setState(() {});
    }
  }

  void payMonthlySubscription() async {
    setState(() {
      monthlyPaymentErrorMessage = null;
    });
    if (monthlyPaymentCard == null) {
      print('no card selected');
      setState(() {
        monthlyPaymentErrorMessage = 'Please select a card';
      });
      return;
    }
    print('paying monthly subscription');
    try {
      await global.training.monthlyPayment(
        trainingName: global.trainingInterest.value.tagName!,
        profileId: global.user.value.profileId,
        paymentCardId: monthlyPaymentCard!.id,
      );
      setState(() {
        registrationStep = 5;
      });
    } catch (e) {
      print('error paying monthly subscription: $e');
      monthlyPaymentErrorMessage = 'Error paying monthly subscription, please try again later.';
    } finally {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    if (!global.isAuthenticated.value) {
      global.vroute.navigateTo('/login', redirectPath: '/training');
      return;
    }
    final tagName = global.trainingInterest.value.tagName;
    if(tagName == null || tagName.isEmpty){
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        global.vroute.navigateTo('/training');
      });
      return;
    }
    final user = global.user.value;
    final formData = global.training.trainingsLog['details'] as Map<String, dynamic>?;
    firstNameController.text = formData?['firstName'] ?? user.firstName ?? '';
    lastNameController.text = formData?['lastName'] ?? user.lastName ?? '';
    providerEmail.text = formData?['providerEmail'] ?? user.email;
    officeLocation.text = formData?['officeLocation'] ?? '';
    licensedState = formData?['licensedState'];
    healthCareProvider.text = formData?['healthCareProvider'] ?? '';
    registrationStep = global.training.trainingsLog['step'] ?? 1;
    if (registrationStep == 2) {
      getPDF();
    }
    print('registration step: $registrationStep');
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    healthCareProvider.dispose();
    providerEmail.dispose();
    officeLocation.dispose();
    signatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GalaxyPageScaffold(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (registrationStep < 5) ...[
          Form(
            key: formKey,
            child: RegistrationStep(
              step: 1,
              isExpanded: registrationStep == 1,
              isCompleted: registrationStep > 1,
              title: '${global.trainingInterest.value.supportText} ${global.trainingInterest.value.name}',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      TextFieldLabel(
                        label: 'First Name',
                        width: _textFieldWidth,
                        child: TextFormField(
                          controller: firstNameController,
                          validator: (value) => value!.isEmpty ? 'Enter first name' : null,
                          decoration: InputDecoration(
                            helperText: '',
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      TextFieldLabel(
                        label: 'Last Name',
                        width: _textFieldWidth,
                        child: TextFormField(
                          controller: lastNameController,
                          validator: (value) => value!.isEmpty ? 'Enter last name' : null,
                          decoration: InputDecoration(
                            helperText: '',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      TextFieldLabel(
                        label: 'Health Care Provider',
                        width: _textFieldWidth,
                        child: TextFormField(
                          controller: healthCareProvider,
                          validator: (value) => value!.isEmpty ? 'Enter health care provider' : null,
                          decoration: InputDecoration(
                            helperText: '',
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      TextFieldLabel(
                        label: 'Provider Email',
                        width: _textFieldWidth,
                        child: TextFormField(
                          controller: providerEmail,
                          // validator: (value) => value!.isEmpty ? 'Enter provider email' : null,
                          decoration: InputDecoration(
                            helperText: '',
                          ),
                          validator: (value) {
                            final isEmailInvalid = value == null || !EmailValidator.validate(value);
                            if (isEmailInvalid) return 'Enter a valid email address';
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      TextFieldLabel(
                        label: 'Licensed State',
                        width: _textFieldWidth,
                        child: DropdownMenu(
                          enableSearch: false,
                          requestFocusOnTap: false,
                          expandedInsets: EdgeInsets.zero,
                          menuHeight: 320,
                          initialSelection: licensedState,
                          onSelected: (value) {
                            setState(() {
                              licensedState = value;
                            });
                          },
                          dropdownMenuEntries: USState.values.map((usState) {
                            return DropdownMenuEntry(value: usState.label, label: usState.label);
                          }).toList(growable: false),
                          errorText: usStateErrorMessage,
                          helperText: '',
                        ),
                      ),
                      const SizedBox(width: 16),
                      TextFieldLabel(
                        label: 'Office Full Address',
                        width: _textFieldWidth,
                        child: TextFormField(
                          controller: officeLocation,
                          validator: (value) => value!.isEmpty ? 'Enter office full address' : null,
                          decoration: InputDecoration(
                            helperText: '',
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (formErrorMessage != null)
                    Text(
                      formErrorMessage!,
                      style: TextStyle(color: YLiftColor.orange),
                    ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 240,
                    child: RoundedFilledButton(
                      onPressed: saveRegisterTrainingForm,
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 64),
          Form(
            key: documentFormKey,
            child: RegistrationStep(
              step: 2,
              isExpanded: registrationStep == 2,
              isCompleted: registrationStep > 2,
              title: 'Sign the Document',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (pdfBytes != null)
                    SizedBox(
                      height: 1080,
                      width: 960,
                      child: PdfPreview(
                        build: (format) {
                          return pdfBytes!;
                        },

                        // allowPrinting: true,
                        // allowSharing: true,
                        initialPageFormat: PdfPageFormat.a4,
                        pdfFileName: "document.pdf", // Name for downloaded/shared file
                        canDebug: true,
                        useActions: false,
                      ),
                    ),
                  if(pdfErrorMessage != null)
                    ...[
                      Text(
                        pdfErrorMessage!,
                        style: TextStyle(color: YLiftColor.orange),
                      ),
                      TextButton.icon(
                        onPressed: (){
                            getPDF();
                          },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  const SizedBox(height: 16),
                  Text('Signature', style: _textFieldLabelStyle),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          border: Border.all(
                              color: signatureErrorMessage != null
                                  ? Theme.of(context).colorScheme.error
                                  : YLiftColor.grey3),
                          color: Colors.grey.shade100,
                        ),
                        height: 240,
                        width: 400,
                        padding: const EdgeInsets.all(8),
                        child: Signature(
                          controller: signatureController,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              signatureController.undo();
                            },
                            child: const Text('Undo'),
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton(
                            onPressed: () {
                              signatureController.redo();
                            },
                            child: const Text('Redo'),
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton(
                            onPressed: () {
                              signatureController.clear();
                            },
                            child: const Text('Clear'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      signatureErrorMessage ?? '',
                      style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.error),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      SizedBox(
                        width: 240,
                        height: 40,
                        child: RoundedFilledButton(
                          padding: EdgeInsets.zero,
                          onPressed: signDocument,
                          child: const Text('Sign'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 240,
                        height: 40,
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              registrationStep -= 1;
                            });
                          },
                          child: const Text('Back'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 64),
          RegistrationStep(
            step: 3,
            isExpanded: registrationStep == 3,
            isCompleted: registrationStep > 3,
            title: 'One Time Payment',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text('One Time Payment', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Training name: ${global.trainingInterest.value.name}'),
                Text('Fee: ${global.trainingInterest.value.oneTimeFee.toCurrency()}'),
                const Text('Payment occurrence: One-time'),
                const SizedBox(height: 16),
                if(global.trainingInterest.value.tagName == 'MagnYm')...[
                  SelectAddressField(
                    onSelectedAddress: (address) {
                      setState(() {
                        billingAddress = address;
                      });
                      calculateTax(int.parse(address.addressId));

                    },
                  ),
                  const SizedBox(height: 16),
                  _TaxMessage(taxAmount: tax, errorMessage: taxErrorMessage),
                  if(tax != null) Text('Total: ${(global.trainingInterest.value.oneTimeFee + tax!).toCurrency()}'),
                ],

                const SizedBox(height: 16),
                Row(
                  children: [
                    SizedBox(
                      width: 320,
                      child: CardPaymentDropdown(
                        onSelected: (card) {
                          setState(() {
                            oneTimePaymentCard = card;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 120,
                      child: RoundedFilledButton(
                        onPressed: payOneTime,
                        child: const Text('Pay'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    YLiftFilledButton(
                      child: const Text('Add New Payment Method'),
                      onPressed: () {
                        showDialog<CardPayment>(
                          context: context,
                          builder: (context) {
                            return CardPaymentDialog(
                              updateWalletPanel: () {},
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),

                if (oneTimePaymentErrorMessage != null)
                  Text(
                    oneTimePaymentErrorMessage!,
                    style: TextStyle(color: YLiftColor.orange),
                  ),
                // const SizedBox(height: 32),
                // SizedBox(
                //   width: 240,
                //   height: 40,
                //   child: OutlinedButton(
                //     onPressed: () {
                //       setState(() {
                //         registrationStep -= 1;
                //       });
                //     },
                //     child: const Text('Back'),
                //   ),
                // ),
              ],
            ),
          ),
          const SizedBox(height: 64),
          RegistrationStep(
            step: 4,
            isExpanded: registrationStep == 4,
            isCompleted: registrationStep > 4,
            title: 'Monthly Subscription Payment',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text('Monthly Subscription', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Fee: ${20000.toCurrency()} / month'),
                Text('Payment occurrence: Charged annually (Total: ${240000.toCurrency()})'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    SizedBox(
                      width: 320,
                      child: CardPaymentDropdown(
                        onSelected: (card) {
                          setState(() {
                            monthlyPaymentCard = card;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 120,
                      child: RoundedFilledButton(
                        onPressed: () {
                          payMonthlySubscription();
                        },
                        child: const Text('Pay'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    YLiftFilledButton(
                      child: const Text('Add New Payment Method'),
                      onPressed: () {
                        showDialog<CardPayment>(
                          context: context,
                          builder: (context) {
                            return CardPaymentDialog(
                              updateWalletPanel: () {},
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
                if (monthlyPaymentErrorMessage != null)
                  Text(
                    monthlyPaymentErrorMessage!,
                    style: TextStyle(color: YLiftColor.orange),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 64),
          Padding(
            padding: const EdgeInsets.only(left: 56),
            child: Text('After completing all steps, you will be redirected automatically'),
          ),
          const SizedBox(height: 160),
        ] else ...[
          RegistrationStep(
            step: 5,
            isExpanded: registrationStep == 5,
            isCompleted: registrationStep == 5,
            title: 'Registration Completed',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Training name: ${global.trainingInterest.value.tagName}'),
                Text('Instructions: ${global.trainingInterest.value.supportText}'),
              ],
            ),
          ),
        ],
      ],
    );
  }
}


class _TaxMessage extends StatelessWidget {
  final int? taxAmount;
  final String? errorMessage;
  const _TaxMessage({super.key, this.taxAmount, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    if(errorMessage != null){
      return Text('Tax: $errorMessage', style: TextStyle(color: YLiftColor.orange));
    }
    if(taxAmount != null){
      return Text('Tax: ${taxAmount!.toCurrency()}');
    }
    return Text('Tax: Select an address');
  }
}
