import 'package:YLift/core/constants/color.dart';
import 'package:YLift/presentation/components/_complex/forms/email_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:galaxy_ui/galaxy_ui.dart';

class BasicInformationPage extends StatefulWidget {
  final void Function(Map<String, dynamic> formData)? onSubmit;
  final String? errorMessage;
  final void Function(String)? onError;

  const BasicInformationPage({
    super.key,
    this.onSubmit,
    this.errorMessage,
    this.onError,
  });

  @override
  State<BasicInformationPage> createState() => _BasicInformationPageState();
}

class _BasicInformationPageState extends State<BasicInformationPage> with AutomaticKeepAliveClientMixin {
  final _formKey = GlobalKey<FormState>();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final practiceName = TextEditingController();
  final phoneNumber = TextEditingController();
  final secondaryEmail = TextEditingController();

  // for quick debugging
  void initializeFields() {
    firstName.text = 'Test';
    lastName.text = 'User';
    practiceName.text = 'Medical Practice 123';
    phoneNumber.text = "8008888888";
  }

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      initializeFields();
    }
  }

  void onNext() {
    final isFormValid = _formKey.currentState!.validate();
    if (!isFormValid) return;

    final payload = <String, dynamic>{
      'firstName': firstName.text,
      'lastName': lastName.text,
      'practiceName': practiceName.text,
      'phoneNumber': phoneNumber.text,
      'email': secondaryEmail.text.isEmpty ? null : secondaryEmail.text,
    };
    widget.onSubmit?.call(payload);
  }

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    practiceName.dispose();
    phoneNumber.dispose();
    secondaryEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: firstName,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    labelText: 'First Name*',
                    helperText: '',
                  ),
                  validator: (value) => value?.isEmpty ?? false ? 'Enter your first name' : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: lastName,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    labelText: 'Last Name*',
                    helperText: '',
                  ),
                  validator: (value) => value?.isEmpty ?? false ? 'Enter your last name' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: practiceName,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
              labelText: 'Practice Name*',
              helperText: '',
            ),
            validator: (value) => value?.isEmpty ?? false ? 'Enter a valid practice' : null,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: phoneNumber,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    labelText: 'Phone*',
                    helperText: '',
                    counterText: '',
                  ),
                  maxLength: 10,
                  validator: (value) {
                    final isEmpty = value == null || value.isEmpty;
                    if (isEmpty || value.length < 10) return 'Please enter a valid phone number';
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: EmailField(
                  labelText: 'Secondary Email',
                  controller: secondaryEmail,
                  withClearButton: true,
                  isOptional: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          if (widget.errorMessage != null)
            Text(
              widget.errorMessage!,
              style: TextStyle(color: YLiftColor.darkOrange),
            ),
          SizedBox(
            width: double.infinity,
            child: RoundedFilledButton(
              onPressed: onNext,
              child: const Text('Proceed to Step 2'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}