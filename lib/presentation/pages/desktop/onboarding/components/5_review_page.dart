import 'package:flutter/material.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
class AccountReviewPage extends StatefulWidget {
  final void Function()? onSubmit;

  final Map<String, dynamic> medicalLicenseForm;
  final Map<String, dynamic> shippingAddressForm;
  final Map<String, dynamic> paymentMethodForm;
  const AccountReviewPage({
    super.key,
    this.onSubmit,
    required this.medicalLicenseForm,
    required this.shippingAddressForm,
    required this.paymentMethodForm,
  });

  @override
  State<AccountReviewPage> createState() => _AccountReviewPageState();
}

class _AccountReviewPageState extends State<AccountReviewPage> {

  void completeRegistration() {
    widget.onSubmit?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const GapY(),
        VerificationRow(content: 'Basic Information'),
        SizedBox(height: 12),
        VerificationRow(content: 'Billing & Payment'),
        SizedBox(height: 12),
        VerificationRow(content: 'Shipping Information'),
        SizedBox(height: 12),
        VerificationRow(content: 'Medical License'),
        SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: RoundedFilledButton(
            onPressed: completeRegistration,
            child: const Text('Start Using Your YLS Account!!'),
          ),
        ),
      ],
    );
  }
}
