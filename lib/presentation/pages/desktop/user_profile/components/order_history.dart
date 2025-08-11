import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:galaxy_models/galaxy_models.dart';
import '../../__primary_shopping/components/quick_reorder_dialog.dart';
import 'package:galaxy_ui/galaxy_ui.dart';

class OrderHistoryPanel extends StatefulWidget {
  const OrderHistoryPanel({super.key});

  @override
  State<OrderHistoryPanel> createState() => _OrderHistoryPanelState();
}

class _OrderHistoryPanelState extends State<OrderHistoryPanel> {
  final global = Get.find<GlobalController>();
  List<OrderSimple>? orders;

  int _currentPage = 1;
  String mostRecentDate = "";
  String leastRecentDate = "";
  static const int _limit = 10;
  bool _isLoading = true;

  void goToOrderPage(String orderId) {
    global.vroute.navigateTo('/order/confirm?orderId=$orderId');
  }

  Future<void> fetchOrders(int newPage) async {
    if (global.orderHistoryCount > 0) {
      int pageToDisplay = (newPage > 0) ? newPage : 1;
      int lastPage = (global.orderHistoryCount / _limit).ceil();

      pageToDisplay = pageToDisplay.clamp(1, lastPage);

      if (pageToDisplay == 0 && global.orderHistoryCount > 0) {
        pageToDisplay = 1;
      }

      _isLoading = true;

      try {
        var fetchOrders = await global.orders.getOrders(
          limit: _limit,
          offset: (pageToDisplay - 1) * _limit,
        );
        if (fetchOrders.isEmpty) {
          _currentPage = pageToDisplay - 1;
          return;
        } else {
          _currentPage = pageToDisplay;
          orders = fetchOrders;
        }
      } catch (e) {
        print("Error fetching orders: $e");
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    fetchOrders(_currentPage);
  }

  String _formatStatus(String status) {
    switch (status) {
      case 'COMPLETED':
        return 'Completed';
      case 'COMPLETED_PARTIALLY_PAID':
        return 'Partially Paid';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (orders == null) {
      return const SizedBox(
        height: 400,
        width: double.infinity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'You have not made any purchase yet!',
                style: TextStyle(
                  fontFamily: 'Acid Grotesk',
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (orders!.isEmpty) {
      return const Text('You have not made any purchase yet!');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (false) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.tune),
                ),
              ),
              SizedBox(
                width: 240,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Order number'),
                    SearchBar(
                      backgroundColor: WidgetStateColor.resolveWith(
                        (states) => Colors.transparent,
                      ),
                      side: WidgetStateBorderSide.resolveWith(
                        (states) => const BorderSide(
                          color: Color(0xFFD9D9D9),
                          width: 2,
                        ),
                      ),
                      leading: const Icon(
                        Icons.search,
                        color: Color(0xFFD9D9D9),
                      ),
                      elevation: WidgetStateProperty.resolveWith(
                        (states) => 0.0,
                      ),
                    ),
                  ],
                ),
              ),
              const GapX(),
              SizedBox(
                width: 120,
                child: YLiftTextField(
                  labelText: 'From',
                  hintText: leastRecentDate,
                  controller: TextEditingController(),
                ),
              ),
              const GapX(),
              SizedBox(
                width: 120,
                child: YLiftTextField(
                  labelText: 'To',
                  hintText: mostRecentDate,
                  controller: TextEditingController(),
                ),
              ),
              const GapX(),
              YLiftFilledButton(
                onPressed: () {},
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 24,
                ),
                child: const Text('Search'),
              ),
            ],
          ),
        ],
        SizedBox(
          width: double.infinity,
          child: DataTable(
            columns: const <DataColumn>[
              DataColumn(label: Text('Order #')),
              // DataColumn(label: Text('Order Date')),
              DataColumn(label: Text('Type')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Total')),
              DataColumn(label: Text('Reorder')),
            ],
            rows: List.generate(
              orders!.length,
              (index) {
                final order = orders![index];
                return DataRow(
                  cells: [
                    DataCell(
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.label ?? '',
                            style: TextStyle(fontSize: 13.33),
                          ),
                          Text(
                            (order.orderDate ?? order.createdAt).yMMMd(
                              withTime: true,
                            ),
                            style: TextStyle(fontSize: 11.11),
                          ),
                        ],
                      ),
                      onTap:
                          () =>
                              order.status != 'PENDING'
                                  ? goToOrderPage(order.orderId!)
                                  : null,
                    ),
                    DataCell(_OrderTypeText(order)),
                    DataCell(_OrderStatusText(order)),
                    DataCell(Text(order.orderTotal.display())),
                    DataCell(
                      UnderlinedTextButton(
                        onPressed: () {
                          if (order.isLegacyOrder == true) {
                            global.vroute.navigateTo(
                              '/order/confirm?orderId=${order.orderId}',
                            );
                            return;
                          }
                          showDialog(
                            context: context,
                            builder:
                                (context) =>
                                    QuickReorderDialog(previousOrder: order),
                          );
                        },
                        text:
                            order.status != 'PENDING'
                                ? (order.isLegacyOrder == true
                                    ? 'View'
                                    : 'Reorder')
                                : 'View',
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        const GapY(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OrderHistoryPaginationWidget(
              totalNumItems: global.orderHistoryCount.value,
              itemsPerPage: _limit,
              currentPage: _currentPage,
              onPageChanged: (page) async {
                await fetchOrders(page);
              },
            ),
            // YLiftOutlinedButton(
            //   onPressed: () {},
            //   child: const Text('Export to CSV'),
            // ),
          ],
        ),
      ],
    );
  }
}

class OrderHistoryPaginationWidget extends StatefulWidget {
  final int totalNumItems;
  final int itemsPerPage;
  final int currentPage;
  final Function(int) onPageChanged;

  const OrderHistoryPaginationWidget({
    super.key,
    required this.totalNumItems,
    required this.itemsPerPage,
    required this.currentPage,
    required this.onPageChanged,
  });

  @override
  State<OrderHistoryPaginationWidget> createState() =>
      _OrderHistoryPaginationWidgetState();
}

class _OrderHistoryPaginationWidgetState
    extends State<OrderHistoryPaginationWidget> {
  void _changePage(int change) {
    widget.onPageChanged(change);
    //
    // final totalPages = (widget.totalNumItems / widget.itemsPerPage).ceil();
    // final newPage = widget.currentPage + change;
    // if (newPage >= 1 && newPage <= totalPages) {
    //   widget.onPageChanged(newPage);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () => _changePage(widget.currentPage - 5),
          icon: const Icon(Icons.keyboard_double_arrow_left),
        ),
        IconButton(
          onPressed: () => _changePage(widget.currentPage - 1),
          icon: const Icon(Icons.chevron_left),
        ),
        SizedBox(
          width: 40,
          child: Text(
            widget.currentPage.toString(),
            textAlign: TextAlign.center,
          ),
        ),
        IconButton(
          onPressed: () => _changePage(widget.currentPage + 1),
          icon: const Icon(Icons.chevron_right),
        ),
        IconButton(
          onPressed: () => _changePage(widget.currentPage + 5),
          icon: const Icon(Icons.keyboard_double_arrow_right),
        ),
      ],
    );
  }
}

class _OrderTypeText extends StatelessWidget {
  final OrderSimple order;
  const _OrderTypeText(this.order);

  @override
  Widget build(BuildContext context) {
    String orderType;
    String? tooltipMessage;

    switch (order.type) {
      case 'ORDER':
        orderType = 'Order';
        break;
      case 'MANUAL_ORDER':
        tooltipMessage = 'Order created by Y Lift Admin';
        orderType = 'Manual Order';
        break;
      default:
        orderType = order.type;
        break;
    }

    if (orderType == 'Order') return Text(orderType);

    return Tooltip(
      message: tooltipMessage,
      margin: EdgeInsets.only(left: 72),
      verticalOffset: 12,
      child: Text(orderType),
    );
  }
}

class _OrderStatusText extends StatelessWidget {
  final OrderSimple order;
  const _OrderStatusText(this.order);

  @override
  Widget build(BuildContext context) {
    String orderStatus;
    switch (order.status) {
      case 'COMPLETED':
        orderStatus = 'Completed';
        break;
      case 'COMPLETED_PARTIALLY_PAID':
        orderStatus = 'Partially Paid';
        break;
      default:
        orderStatus = order.status;
    }

    if (orderStatus == 'Partially Paid' && order.termPayments != null && order.termPayments!.isNotEmpty) {
      final lastPayment = order.termPayments!.last;
      final dueDate = lastPayment.lateTermPaymentDate;

      return Tooltip(
        message: dueDate != null
            ? 'Next payment due on ${dueDate.yMMMd()}'
            : 'Next payment due date not available',
        child: Text(orderStatus),
      );
    }
    return Text(orderStatus);
  }
}
