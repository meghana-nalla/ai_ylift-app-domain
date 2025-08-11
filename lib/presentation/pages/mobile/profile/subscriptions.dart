import 'package:YLift/models/api/z-index_export.dart';
import 'package:YLift/presentation/components/z-index_export.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:YLift/core/controllers/z-index_export.dart';

import 'package:galaxy_models/galaxy_models.dart';


class ProfileSubscriptionsScreen extends StatefulWidget {
  const ProfileSubscriptionsScreen({super.key});

  @override
  _ProfileSubscriptionsScreenState createState() => _ProfileSubscriptionsScreenState();
}

class _ProfileSubscriptionsScreenState extends State<ProfileSubscriptionsScreen> with SingleTickerProviderStateMixin {
  final GlobalController controller = Get.find<GlobalController>();

  late TabController _tabController;


  final List<String> tabs = [
    'My Subscription',
    'Campaign',
    'Channel',
    'Product',
  ]; // at some point this list should be dynamic

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _loadSubscriptions();
  }
  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }
  Future<void> _loadSubscriptions() async {
    if(controller.profile.value.recurrings == null){
      controller.profile.value.recurrings = await controller.userController.getRecurring(controller.profile.value.info!.profileId.toString());
    }
    setState(() { });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title:AnimatedRouteDisplay(
          parentRoute: 'Subscriptions',
          childRoute: tabs[_tabController.index],
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: tabs.map((String name) => Tab(text: '${name}s')).toList(),
          indicatorColor: Theme.of(context).colorScheme.primary,
          labelColor: Theme.of(context).colorScheme.onSurface,
          unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: tabs.map((String name) {
          return _buildTabContent(name);
        }).toList(),
      ),
    );
  }


  Widget _buildTabContent(String tabName) {
    List<Recurring> allSubscriptions = controller.profile.value.recurrings ?? [];
    switch (tabName) {
      case 'My Subscription':
        return SubscriptionList(subscriptions: allSubscriptions);
      default:
        return SubscriptionList(subscriptions: allSubscriptions.where((s) => s.type == tabName).toList());
    }
  }
}

class SubscriptionList extends StatelessWidget {
  final List<Recurring> subscriptions;

  SubscriptionList({required this.subscriptions});

  @override
  Widget build(BuildContext context) {
    return subscriptions.isEmpty
        ? Center(child: Text('No subscriptions found'))
        : ListView(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Amount')),
              DataColumn(label: Text('Frequency')),
              DataColumn(label: Text('Start Date')),
              DataColumn(label: Text('Last Payment')),
              DataColumn(label: Text('Next Payment')),
              DataColumn(label: Text('Action')),
            ],
            rows: subscriptions.map((subscription) {
              return DataRow(
                cells: [
                  DataCell(Text(subscription.name)),
                  DataCell(Text(
                    subscription.status,
                    style: TextStyle(
                      color: subscription.status == 'active' ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  DataCell(Text('\$${_toDecimal(subscription.amount)}')),
                  DataCell(Text('${subscription.intervalLength} ${subscription.intervalUnit}')),
                  DataCell(Text(_formatDate(subscription.startDate))),
                  DataCell(Text(_formatDate(subscription.lastPaymentDate))),
                  DataCell(Text(_formatDate(subscription.nextPaymentDate))),
                  DataCell(
                    subscription.status == 'active'
                        ? ElevatedButton(
                      child: Text('Edit'),
                      onPressed: () => _showSubscriptionDetails(context, subscription),
                    )
                        : Text('-'),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  String _toDecimal(int amount) {
    return (amount / 100).toStringAsFixed(2);
  }

  String _formatDate(DateTime? date) {
    return date != null ? DateFormat('MM/dd/yyyy').format(date) : '-';
  }

  void _showSubscriptionDetails(BuildContext context, Recurring subscription) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(subscription.name),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Status: ${subscription.status}'),
                Text('Amount: \$${_toDecimal(subscription.amount)}'),
                Text('Frequency: ${subscription.intervalLength} ${subscription.intervalUnit}'),
                Text('Start Date: ${_formatDate(subscription.startDate)}'),
                Text('Last Payment: ${_formatDate(subscription.lastPaymentDate)}'),
                Text('Next Payment: ${_formatDate(subscription.nextPaymentDate)}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel Subscription'),
              onPressed: () {
                // TODO: Implement cancel subscription logic
                // ^ Note:  this is a task for after the desktop version is created
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}