import 'package:YLift/core/constants/color.dart';
import 'package:YLift/core/constants/constant.dart';
import 'package:flutter/material.dart';

import '../../../pages/auth/having_trouble/index.dart';
import '../../report_issue_button.dart';

class ErrorTile extends StatelessWidget {
  final String? title;
  final String? message;
  final String? errorCode;
  final void Function()? onClose;
  final String? errorMessage;

  const ErrorTile({
    super.key,
    this.title,
    this.message,
    this.errorCode,
    this.onClose,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: YLiftColor.orange.withValues(alpha: 0.1),
        border: Border.all(color: YLiftColor.orange),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(
            Icons.error_outline,
            color: YLiftColor.orange,
            size: 32,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text(
                  title ?? 'Something went wrong, please try again later.',
                  style: const TextStyle(
                    color: YLiftColor.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                Text(
                  message ??
                      'Need assistance? Contact ${YLiftConstant.yliftPhoneNumber} or ${YLiftConstant.yliftEmail}.',
                  style: const TextStyle(
                    color: YLiftColor.orange,
                    fontSize: 13.33,
                  ),
                ),
                ReportIssueButton(errorMessage: errorMessage!),
                if (errorCode != null)
                  Text(
                    errorCode!,
                    style: const TextStyle(
                      color: YLiftColor.orange,
                      fontSize: 13.33,
                    ),
                  ),
              ],
            ),
          ),
          if (onClose != null)
            SizedBox.square(
              dimension: 24,
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: onClose,
                icon: const Icon(
                  Icons.close,
                  color: YLiftColor.orange,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
