import 'package:YLift/core/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_ui/galaxy_ui.dart';

class CookieSettingsPanel extends StatelessWidget {
  final void Function() onAccept;
  final void Function() onReject;

  const CookieSettingsPanel({
    super.key,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 32),
      height: 200,
      alignment: Alignment.center,
      child: SizedBox(
        width: YLiftConstant.pageWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cookies Settings',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'In addition to cookies that are strictly necessary for the operation of this website, we use cookies and similar technologies to personalize content and enhance your experience. By clicking "Accept," you consent to their use as described in our Cookie Policy.',
                  ),
                ),
                const SizedBox(width: 64),
                Column(
                  children: [
                    SizedBox(
                      width: 240,
                      child: RoundedFilledButton(
                        onPressed: onAccept,
                        child: const Text(
                          'Accept Cookies',
                          style: TextStyle(letterSpacing: 1.4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: onReject,
                        child: Text(
                          'Reject All',
                          style: TextStyle(decoration: TextDecoration.underline, letterSpacing: 1.4, fontSize: 13.33),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
