
import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/core/repositories/image_repository.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/models/api/z-index_export.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:YLift/presentation/components/_complex/panels/order_summary_panel.dart';
import 'package:YLift/presentation/pages/desktop/order_confirmation/components/free_items_panel.dart';
import 'package:YLift/presentation/pages/desktop/order_confirmation/components/thank_you_panel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderConfirmationPage extends StatefulWidget {
  const OrderConfirmationPage({super.key});

  @override
  State<OrderConfirmationPage> createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
  final _errorImageUrl = ImageRepository.getBannerImage(
    'c10dbac0-91b8-4b8a-8d32-e153b17aaf80',
  );
  final global = Get.find<GlobalController>();
  late final Future<OrderSimple?> orderFuture;
  OrderSimple? order;

  bool isLoading = false;
  String? errorMessage;

  String? get _orderId => Uri.base.queryParameters['orderId'];

  // 1748668254
  Future<OrderSimple?> getOrder() async {
    try {
      if (_orderId == null) return null;

      final response = await global.api.getData(
        '${ApiUrl.getSingleOrder.path}/$_orderId',
      );

      if (response.isSuccess) {
        return OrderSimple.fromJson(response.data!['orders']);
      } else {
        return null;
      }
    } catch (e, s) {
      rethrow;
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    orderFuture = getOrder();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        if (global.isAuthenticated.isFalse) global.vroute.navigateTo('/login', redirectPath: '${Uri.base.path}?${Uri.base.query}');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_orderId == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return FutureBuilder<OrderSimple?>(
      future: orderFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text(snapshot.error.toString())),
          );
        } else if (snapshot.hasData && snapshot.data != null) {
          final order = snapshot.data!;
          return GalaxyPageScaffold(
            backgroundColor: YLiftColor.beige,
            showGalaxyFooter: false,
            children: [
              ThankYouPanel(order: order, email: order.customerEmail),
              const SizedBox(height: 32),
              OrderSummaryPanel(order: order),
              if (order.freeItems.isNotEmpty) ...[
                const SizedBox(height: 32),
                FreeItemsPanel(freeItems: order.freeItems),
              ],
              const GapY(factor: 4),
            ],
          );
        } else {
          // Handle the case where snapshot.data is null (error or no order)
          return GalaxyPageScaffold(
            padding:
                MediaQuery.of(context).size.width < 640
                    ? EdgeInsets.only(top: 32)
                    : YLiftConstant.pagePadding,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Order access doesn't exist....",
                  style: TextStyle(
                    color: Color(0xFFBBBBBB),
                    fontSize: 39,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width:
                      MediaQuery.of(context).size.width < 640
                          ? MediaQuery.of(context).size.width
                          : 640,
                  child: SelectableText.rich(
                    TextSpan(
                      style: TextStyle(),
                      children: [
                        TextSpan(
                          text:
                              'Please try again. If the problem persists, contact support team at ',
                        ),
                        TextSpan(
                          text: '(212)-861-7787',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: ' or ',
                        ),
                        TextSpan(
                          text: 'info@ylift.com.',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Image.network(
                _errorImageUrl,
                errorBuilder:
                    (context, error, stackTrace) =>
                        Image.asset('msc/images/ys_logo.png'),
                width:
                    MediaQuery.of(context).size.width < 640
                        ? MediaQuery.of(context).size.width
                        : 640,
                //height: MediaQuery.of(context).size.width < 640 ? (MediaQuery.of(context).size.height / 4) : 640,
              ),
            ],
          );
        }
      },
    );
  }
}
