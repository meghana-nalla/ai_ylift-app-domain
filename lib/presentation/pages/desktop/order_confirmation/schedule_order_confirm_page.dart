
import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/core/repositories/image_repository.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/models/api/z-index_export.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScheduleOrderConfirmationPage extends StatefulWidget {
  const ScheduleOrderConfirmationPage({super.key});

  @override
  State<ScheduleOrderConfirmationPage> createState() => _ScheduleOrderConfirmationPageState();
}

class _ScheduleOrderConfirmationPageState extends State<ScheduleOrderConfirmationPage> {
  final _errorImageUrl = ImageRepository.getBannerImage(
    'c10dbac0-91b8-4b8a-8d32-e153b17aaf80',
  );

  final global = Get.find<GlobalController>();
  late final Future<ScheduledOrder?> scheduledOrderFuture;
  ScheduledOrder? scheduledOrder;

  String? get _scheduledOrderId => Uri.base.queryParameters['id'];

  Future<ScheduledOrder?> getScheduledOrder() async {
    try {
      if (_scheduledOrderId == null) return null;

      final response = await global.api.getData(
        '${ApiUrl.scheduleOrder.path}/${_scheduledOrderId}',
      );

      if (response.isSuccess) {
        return ScheduledOrder.fromJson(response.data['scheduledOrder']);
      } else {
        return null;
      }
    } catch (e, s) {
      print('Error fetching scheduled order: $e\n$s');
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    scheduledOrderFuture = getScheduledOrder();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (global.isAuthenticated.isFalse) {
        global.vroute.navigateTo('/login', redirectPath: '${Uri.base.path}?${Uri.base.query}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_scheduledOrderId == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return FutureBuilder<ScheduledOrder?>(
      future: scheduledOrderFuture,
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
          final scheduledOrder = snapshot.data!;
          return GalaxyPageScaffold(
            //backgroundColor: YLiftColor.beige,
            showGalaxyFooter: false,
            children: [
              _buildThankYouPanel(scheduledOrder),
              const SizedBox(height: 32),
              _buildOrderSummaryPanel(scheduledOrder),
              const GapY(factor: 4),
            ],
          );
        } else {
          return _buildErrorPanel(context);
        }
      },
    );
  }

  Widget _buildThankYouPanel(ScheduledOrder order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "🎉 Your scheduled order has been successfully created!",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text("Scheduled Order ID: ${order.id}", style: const TextStyle(fontSize: 16)),
        Text("Order ID: ${order.orderId}", style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildOrderSummaryPanel(ScheduledOrder order) {
    String formatDate(DateTime? date) {
      if (date == null) return 'N/A';
      return date.yMMMMd();
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Scheduled Order Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _summaryRow('Frequency', order.frequency),
            _summaryRow('Start Date', formatDate(order.startDate)),
            _summaryRow('End Date', formatDate(order.endDate)),
            _summaryRow('Next Execution', formatDate(order.nextExecutionDate)),
            _summaryRow('Status', order.status),
            _summaryRow('Requires Confirmation', order.requiresConfirmation ? 'Yes' : 'No'),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 180, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildErrorPanel(BuildContext context) {
    return GalaxyPageScaffold(
      padding: MediaQuery.of(context).size.width < 640
          ? const EdgeInsets.only(top: 32)
          : YLiftConstant.pagePadding,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Scheduled order not found...",
            style: TextStyle(
              color: Color(0xFFBBBBBB),
              fontSize: 36,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: MediaQuery.of(context).size.width < 640
                ? MediaQuery.of(context).size.width
                : 640,
            child: const SelectableText.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'Please try again or contact support at '),
                  TextSpan(text: '(212)-861-7787', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: ' or '),
                  TextSpan(text: 'info@ylift.com.', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),
        Image.network(
          _errorImageUrl,
          errorBuilder: (context, error, stackTrace) => Image.asset('msc/images/ys_logo.png'),
          width: MediaQuery.of(context).size.width < 640
              ? MediaQuery.of(context).size.width
              : 640,
        ),
      ],
    );
  }
}



//
// class ScheduleOrderConfirmationPage extends StatelessWidget {
//   const ScheduleOrderConfirmationPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final id = Uri.base.queryParameters['id'];
//     print('Navigated with ID: $id');
//     return Scaffold(
//       body: Center(
//         child: Text('Schedule Order ID: $id'),
//       ),
//     );
//   }
// }

