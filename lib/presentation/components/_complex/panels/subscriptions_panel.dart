import 'package:YLift/core/controllers/global.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
class SubscriptionsPanel extends StatefulWidget {
  const SubscriptionsPanel({super.key});

  @override
  State<SubscriptionsPanel> createState() => _SubscriptionsPanelState();
}

class _SubscriptionsPanelState extends State<SubscriptionsPanel> {
  final GlobalController global = Get.find<GlobalController>();
  bool _isLoading = false;

  final subscriptions = <TrainingSubscription>[];

  Future<void> fetchVideoContents() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final trainingCourses = await global.userController.getTrainingSubscription();
      setState(() {
        subscriptions.addAll(trainingCourses);
      });
    } catch (e, s) {
      print('$e\n$s');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    fetchVideoContents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (subscriptions.isEmpty) {
      return buildNoSubscriptionsFound(context);
    }

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: DataTable(
            dataTextStyle: TextStyle(fontSize: 13.33),
            columns: <DataColumn>[
              DataColumn(label: Text('Name')),
              // DataColumn(label: Text('Status')),
              DataColumn(label: Text('Amount')),
              // DataColumn(label: Text('Frequency')),
              // DataColumn(label: Text('Start Date')),
              // DataColumn(label: Text('Last Payment')),
              // DataColumn(label: Text('Next Payment')),
            ],
            rows: subscriptions.map<DataRow>((subscription) {
              return DataRow(
                cells: <DataCell>[
                  DataCell(Text(subscription.name)),
                  // DataCell(subscription.isActive
                  //     ? Icon(Icons.check_circle, color: Colors.green)
                  //     : Icon(Icons.cancel, color: YLiftColor.orange)),
                  DataCell(Text(subscription.amount.toCurrency())),
                  // DataCell(Text('12 months')),
                  // DataCell(Text(DateFormat.yMMMMd().format(subscription.startDate))),
                  // DataCell(Text(DateFormat.yMMMMd().format(subscription.lastPaymentDate))),
                  // DataCell(Text(DateFormat.yMMMMd().format(subscription.nextPaymentDate))),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget buildNoSubscriptionsFound(BuildContext context) {
    return Center(
      child: Container(
          height: 500,
          width: 500,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.subscriptions_sharp,
                size: 100,
              ),
              const SizedBox(height: 8),
              const Text('No Subscriptions Found 😢', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              const SizedBox(
                height: 24,
              ),
              SizedBox(
                height: 50,
                width: 200,
                child: YLiftFilledButton(
                    onPressed: () async => await global.vroute.navigateTo('/shop'),
                    child: const Text('Continue to shop')),
              )
            ],
          )),
    );
  }
}
