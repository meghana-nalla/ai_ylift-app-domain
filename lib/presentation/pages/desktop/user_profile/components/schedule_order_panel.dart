import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/models/api/z-index_export.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:YLift/presentation/pages/desktop/order_confirmation/schedule_order_confirm_page.dart';
import '../../__primary_shopping/components/quick_reorder_dialog.dart';
import 'package:galaxy_ui/galaxy_ui.dart';

class ScheduledOrdersPanel extends StatefulWidget {
  const ScheduledOrdersPanel({super.key});

  @override
  State<ScheduledOrdersPanel> createState() => _ScheduledOrdersPanelState();
}

class _ScheduledOrdersPanelState extends State<ScheduledOrdersPanel> {
  final global = Get.find<GlobalController>();
  List<OrderSimple>? orders;
  List<ScheduledOrder>? scheduledOrders;

  bool _isLoading = true;

  Future<void> fetchScheduledOrders() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final fetchedOrders = await global.orders.getAllScheduledOrders();
      setState(() {
        scheduledOrders = fetchedOrders;
      });
    } catch (e) {
      print("Error fetching scheduled orders: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }




  @override
  void initState() {
    super.initState();
    _isLoading = true;
    fetchScheduledOrders();
  }


  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: double.infinity,
      child: DataTable(
        columns: const <DataColumn>[
          DataColumn(label: Text('Order #')),
          // DataColumn(label: Text('Schedule Order #')),
          DataColumn(label: Text('Frequency')),
          DataColumn(label: Text('Start Date')),
          DataColumn(label: Text('End date')),
          DataColumn(label: Text('Next \nOrder Date')),
          DataColumn(label: Text('Actions')),
          // DataColumn(label: Text("Execution Counts")),
        ],
        rows: List.generate(
          scheduledOrders?.length ?? 0,
              (index) {
            final order = scheduledOrders![index];
            return DataRow(

              cells: [
                DataCell(

                  SizedBox(
                    width: 200,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order Id: '+order.orderId.toString(),
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            'Id: ${order.id.toString()}', // assuming order.id is int
                            style: const TextStyle(fontSize: 10),
                          ),

                        ],
                      ),
                    ),
                  ),
                  onTap: () async {
                    final scheduledOrder = await global.orders.getScheduledOrder(order.id);
                    if (scheduledOrder != null) {

                      global.vroute.navigateTo('/order/schedule?id=${order.id}');

                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (_) => ScheduledOrderConformationPage(scheduledOrder: scheduledOrder),
                      //   ),
                      // );

                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Could not fetch order')),
                      );
                    }
                  },
                ),
                DataCell(Text(
                  order.frequency.toString(),
                  style: TextStyle(fontSize: 13.33),
                ),),
                DataCell(Text(
                  order.startDate.yMMMMd(),
                  style: TextStyle(fontSize: 13.33),
                ),),
                DataCell(Text(
                  order.endDate.yMMMMd(),
                  style: TextStyle(fontSize: 13.33),
                ),),
                DataCell(Text( order.nextExecutionDate != null ?
                order.nextExecutionDate!.yMMMMd() : '-',
                  style: TextStyle(fontSize: 13.33),
                ),),
                DataCell(
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.redAccent),
                    tooltip: 'Delete',
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text('Delete Order'),
                          content: Text('Are you sure you want to delete this scheduled order?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Cancel')),
                            TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text('Delete')),
                          ],
                        ),
                      );

                      if (confirm != true) return;

                      await global.orders.deleteScheduledOrder(order.id.toString());

                      // Optionally remove from UI list if you're not refetching
                      setState(() {
                        scheduledOrders!.removeAt(index);
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Deleted scheduled order ${order.id}')),
                      );
                    },
                  ),
                ),



              ],
            );
          },
        ),
      ),
    );
  }
}