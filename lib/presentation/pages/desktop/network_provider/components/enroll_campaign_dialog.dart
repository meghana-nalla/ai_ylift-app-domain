import 'dart:convert';

import 'package:YLift/core/constants/index.dart';
import 'package:YLift/presentation/components/_simple/us_state_dropdown.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/core/services/bearer.dart';
import 'package:YLift/models/urls/api.dart';
import 'package:YLift/presentation/components/_complex/desktop_view/gap.dart';
import 'package:YLift/presentation/components/_complex/dialogs/docusign_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:YLift/presentation/components/_complex/dropdowns/card_payment_dropdown.dart';

class EnrollCampaignDialog extends StatefulWidget {
  final int oneTimePaymentAmount;
  final int monthlyPaymentAmount;
  const EnrollCampaignDialog({
    super.key,
    required this.oneTimePaymentAmount,
    required this.monthlyPaymentAmount,
  });

  @override
  State<EnrollCampaignDialog> createState() => _EnrollCampaignDialogState();
}

class _EnrollCampaignDialogState extends State<EnrollCampaignDialog> {
  final healthCareController = TextEditingController();
  final providerEmailController = TextEditingController();
  final officeController = TextEditingController();

  USState? state;
  CardPayment? cardPayment;

  String? errorMessage;

  void enroll() async {
    // Navigator.pop(context);
    // showDialog(
    //   context: context,
    //   builder: (context) => const DocusignDialog(),
    // );
    print('ENROLLING');
    try {
      setState(() {
        errorMessage = null;
      });

      final prefs = SharedPreferencesAsync();
      prefs.setInt('oneTimePaymentAmount', widget.oneTimePaymentAmount);
      prefs.setInt('monthlyPaymentAmount', widget.monthlyPaymentAmount);

      final global = Get.find<GlobalController>();

      final queryParameters = <String, String>{'trainingName': 'YLiftProvider', 'profileId': global.user.value.profileId.toString()};
      final data = <String, dynamic>{
        'healthCareProvider': healthCareController.text,
        'providerEmail': providerEmailController.text,
        'officeLocation': officeController.text,
        'licensedState': state!.label,
        'creditCard': cardPayment?.id ?? '1234',
      };

      // TODO: Uncomment the line below when the api is fixed
      // final response = await global.api.post(ApiUrl.networkProviderEnroll.withQuery(queryParameters), data);

      global.vroute.navigateTo('/training/payment');

      // print(data);

      // DocusignDialog.show(context);

      // print(response.data);
    } catch (e) {
      print('$e');
      setState(() {
        errorMessage = '$e';
      });
    }
  }

  @override
  void dispose() {
    healthCareController.dispose();
    providerEmailController.dispose();
    officeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 800,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enroll in this Campaign',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: YLiftTextField(
                      labelText: 'Health Care Provider*',
                      controller: healthCareController,
                    ),
                  ),
                  const GapX(),
                  Expanded(
                    child: YLiftTextField(
                      labelText: 'Provider Email',
                      controller: providerEmailController,
                    ),
                  ),
                ],
              ),
              const GapY(),
              Row(
                children: [
                  Expanded(
                    child: UsStateDropdownMenu(
                      labelText: 'Licensed State',
                      onChanged: (state) {
                        setState(() {
                          this.state = state;
                        });
                      },
                    ),
                  ),
                  const GapX(),
                  Expanded(
                    child: YLiftTextField(
                      labelText: 'Office Location',
                      controller: officeController,
                    ),
                  ),
                ],
              ),
              const GapY(),
              // CardPaymentDropdown(
              //   onSelected: (card) {
              //     setState(() {
              //       cardPayment = card;
              //     });
              //   },
              // ),
              const SizedBox(height: 32),
              const Text(
                'Pricing',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                  '- ${NumberFormat.simpleCurrency(decimalDigits: 2).format(widget.oneTimePaymentAmount)}: In Person Training Fee (One Time Payment)'),
              Text(
                  '- ${NumberFormat.simpleCurrency(decimalDigits: 2).format(widget.monthlyPaymentAmount)}: Monthly Membership Fee (Automatically Charged Annually)'),
              const GapY(),
              OverflowBar(
                alignment: MainAxisAlignment.end,
                spacing: 16,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  FilledButton(
                    onPressed: enroll,
                    child: const Text('Enroll'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
