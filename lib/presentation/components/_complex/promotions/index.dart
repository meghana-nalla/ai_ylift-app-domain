import 'dart:async';

import 'package:YLift/core/constants/index.dart';
import 'package:YLift/core/controllers/z-index_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';

class PromotionsPage extends StatelessWidget {
  final controller = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Promotions'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            controller.vroute.returnToHome();
          },
        ),
      ),
      body: Column(
        children: [
          Obx(() => ListView.builder(
                itemCount: controller.promotions.length,
                itemBuilder: (context, index) {
                  return PromotionItem(promotion: controller.promotions[index]);
                },
              )),
        ],
      ),
    );
  }
}

class PromotionItem extends StatefulWidget {
  final PromotionSimple promotion;

  PromotionItem({required this.promotion});

  @override
  _PromotionItemState createState() => _PromotionItemState();
}

class _PromotionItemState extends State<PromotionItem> {
  final htmlUnescape = HtmlUnescape();
  bool _expanded = false;

  String get _truncatedInfo {
    final unescapedInfo = htmlUnescape.convert(widget.promotion.info);
    final firstLine = unescapedInfo.split('\n').first;
    return firstLine.length > 100 ? firstLine.substring(0, 100) + '...' : firstLine;
  }

  int? get _productId {
    final productId = widget.promotion.destinationPath.split('/').last;
    return int.tryParse(productId);
  }

  bool get hasProductId => _productId != null;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                //crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Expanded(
                  //   child: Html(
                  //     data: _truncatedInfo,
                  //     style: {
                  //       "body": Style(
                  //         fontSize: FontSize(18.0),
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     },
                  //   ),
                  // ),
                  Column(
                    children: [
                      Text('Ends in'),
                      CountdownTimer(endTime: widget.promotion.expireAt),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Center(
                child: Image.network(
                  widget.promotion.imageUrl,
                  height: MediaQuery.of(context).size.height * 0.3,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      PLACEHOLDER_IMAGE,
                      height: MediaQuery.of(context).size.height * 0.3,
                    );
                  },
                ),
              ),
              SizedBox(height: 16.0),
              AnimatedCrossFade(
                firstChild: Html(
                  data: _truncatedInfo,
                ),
                secondChild: Html(
                  data: htmlUnescape.convert(widget.promotion.info),
                ),
                crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: Duration(milliseconds: 300),
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _expanded = !_expanded;
                      });
                    },
                    child: Text(_expanded ? 'Read Less' : 'Read More'),
                  ),
                  if (hasProductId)
                    TextButton(
                      onPressed: () {
                        final global = Get.find<GlobalController>();
                        global.vroute.navigateToProduct(_productId!);
                      },
                      child: const Text('Shop Now >'),
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

class CountdownTimer extends StatefulWidget {
  final DateTime endTime;

  CountdownTimer({required this.endTime});

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  late Duration _remaining;
  bool _showMovingCountdown = false;

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      _updateRemaining();
    });
  }

  void _updateRemaining() {
    setState(() {
      _remaining = widget.endTime.difference(DateTime.now());
      _showMovingCountdown = _remaining.inHours < 24 && _remaining.inSeconds > 0;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Text(
        _getDisplayText(),
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  String _getDisplayText() {
    if (_remaining.isNegative) {
      return 'Expired';
    } else if (_showMovingCountdown) {
      return '${(_remaining.inHours % 24).toString().padLeft(2, '0')}:${(_remaining.inMinutes % 60).toString().padLeft(2, '0')}:${(_remaining.inSeconds % 60).toString().padLeft(2, '0')}';
    } else {
      int daysLeft = _remaining.inDays;
      return '$daysLeft ${daysLeft == 1 ? 'day' : 'days'} ';
    }
  }
}
