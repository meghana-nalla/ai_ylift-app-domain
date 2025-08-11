import 'package:web/web.dart' as html;
import 'dart:ui_web' as ui;

import 'package:flutter/material.dart';

const _docusignUrl =
    'https://na3.docusign.net/Member/PowerFormSigning.aspx?PowerFormId=362952d5-defa-49e3-a0ef-d2d2f0d68c7d&env=na3&acct=1b26f5e5-cd07-4889-a086-2d9a901b90ae&v=2';
const _iframeViewName = 'docusign-view';

class DocusignDialog extends StatefulWidget {
  const DocusignDialog({super.key});

  static void show(BuildContext context) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const DocusignDialog(),
    );
  }

  @override
  State<DocusignDialog> createState() => _DocusignDialogState();
}

class _DocusignDialogState extends State<DocusignDialog> {
  void initializeDocusignIframe() {
    // ui.platformViewRegistry.registerViewFactory(
    //   _iframeViewName,
    //   (int viewId) {
    //     final iframe = html.IFrameElement()
    //       ..style.border = 'none'
    //       ..src = _docusignUrl
    //       ..width = '100%'
    //       ..height = '100%'
    //       ..style.width = '100%'
    //       ..style.height = '100%';
    //     return iframe;
    //   },
    // );
  }

  @override
  void initState() {
    initializeDocusignIframe();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 800,
        height: 1200,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                children: [
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.clear),
                  ),
                ],
              ),
              const Expanded(
                child: HtmlElementView(viewType: _iframeViewName),
              )
            ],
          ),
        ),
      ),
    );
  }
}
