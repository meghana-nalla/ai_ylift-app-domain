import 'package:YLift/models/simple/z-index_export.dart';
import 'package:YLift/models/z-index_export.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/presentation/components/_complex/dropdowns/card_payment_dropdown.dart';
class TrainingPaymentPage extends StatefulWidget {
  const TrainingPaymentPage({super.key});

  @override
  State<TrainingPaymentPage> createState() => _TrainingPaymentPageState();
}

class _TrainingPaymentPageState extends State<TrainingPaymentPage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedCard;
  bool cardsLoaded = true;
  bool newCardPanelOpen = false;
  bool saving = false;
  bool isProcessingPayment = false;

  bool get isCardSelected => selectedCard != null;

  int? oneTimeAmount;
  int? monthlyAmount;

  void getAmounts() async {
    final prefs = SharedPreferencesAsync();
    oneTimeAmount = await prefs.getInt('oneTimePaymentAmount');
    monthlyAmount = await prefs.getInt('monthlyPaymentAmount');
  }

  CardPayment? oneTimeCardPayment;
  CardPayment? subscriptionCardPayment;

  String? errorMessage;
  String? _validate() {
    if (oneTimeCardPayment == null) return 'Please select a card payment for one-time payment';
    if (subscriptionCardPayment == null) return 'Please select a card payment for subscription payment';

    return null;
  }

  void processPayment() async {
    try {
      setState(() {
        isProcessingPayment = true;
        errorMessage = _validate();
      });
      if (errorMessage != null) return;

      final prefs = SharedPreferencesAsync();
      final trainingName = await prefs.getString('trainingName');

      final global = Get.find<GlobalController>();
      final profileId = global.user.value.profileId;

      final payload = <String, dynamic>{
        'trainingName': trainingName,
        'profileId': profileId,
        'subscriptionCardId': subscriptionCardPayment!.id,
        'oneTimePaymentCardId': oneTimeCardPayment!.id,
      };

      final response = await global.api.post(ApiUrl.trainingPayment.path, payload);
      print(response);

      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 3), () {});
      setState(() {
        isProcessingPayment = false;
      });

      // Navigate to the next screen or show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment Successful')),
      );
    } catch (e) {
    } finally {
      setState(() {
        isProcessingPayment = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 600,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 240),
              const Text(
                'Training payment',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const GapY(),
              const Text('Training name: YLift Provider'),
              Text('Fee: ${oneTimeAmount ?? 'Getting amount...'}'),
              const Text('Payment occurrence: One-time'),
              const SizedBox(height: 16),
              // CardPaymentDropdown(
              //   onSelected: (card) {
              //     setState(() {
              //       oneTimeCardPayment = card;
              //     });
              //   },
              // ),
              const GapY(factor: 3),
              const Text('Monthly subscription'),
              Text('Fee: ${monthlyAmount ?? 'Getting amount...'}'),
              const Text('Charged annually'),
              const SizedBox(height: 16),
              // CardPaymentDropdown(
              //   onSelected: (card) {
              //     setState(() {
              //       subscriptionCardPayment = card;
              //     });
              //   },
              // ),
              const GapY(factor: 3),
              if (errorMessage != null)
                Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              SizedBox(
                width: double.infinity,
                child: YLiftFilledButton(
                  onPressed: isProcessingPayment ? null : processPayment,
                  child: isProcessingPayment ? const Text('Processing payment') : const Text('Pay'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
