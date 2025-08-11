import 'dart:math';

import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/components/mobile_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:get/get.dart';

class MobileOrderHistoryPage extends StatefulWidget {
  const MobileOrderHistoryPage({super.key});

  @override
  State<MobileOrderHistoryPage> createState() => _MobileOrderHistoryPageState();
}

class _MobileOrderHistoryPageState extends State<MobileOrderHistoryPage> {
  final global = Get.find<GlobalController>();

  final scrollController = ScrollController();
  bool fetchingAdditionalOrders = false;
  bool hasReachedEnd = false;

  bool isLoading = false;
  final orders = <OrderSimple>[];

  int currentPage = 0;
  static const limit = 7;

  Future<void> fetchOrders() async {
    if (hasReachedEnd || isLoading) return;

    try {
      setState(() {
        if (orders.isNotEmpty) {
          fetchingAdditionalOrders = true;
        } else {
          isLoading = true;
        }
      });

      var fetchOrders = await global.orders.getOrders(
        limit: limit,
        offset: currentPage * limit,
      );

      setState(() {
        orders.addAll(fetchOrders);
        if (fetchOrders.length < limit) {
          hasReachedEnd = true;
        }
        currentPage++;
      });
    } catch (e) {
      print("Error fetching orders: $e");
    } finally {
      setState(() {
        isLoading = false;
        fetchingAdditionalOrders = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchOrders();
    scrollController.addListener(scrollListener);
  }

  void scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !fetchingAdditionalOrders &&
        !hasReachedEnd) {
      fetchOrders();
    }
  }

  void goToOrder(OrderSimple order) {
    global.vroute.navigateTo(
      '/order/confirm?orderId=${order.orderId}&fromHistory=true',
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MobileScaffold(
      title: 'Order History',
      onBackPressed: () {
        if (Uri.base.toString().contains('order_history')) {
          SystemNavigator.routeInformationUpdated(uri: Uri.parse('/profile'));
          Navigator.pop(context);
          Navigator.pop(context);
        }
        Navigator.pop(context);
      },
      body: ListView.separated(
        controller: scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: orders.length + 1,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          if (index == orders.length) {
            if (isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (fetchingAdditionalOrders) {
              return const Center(child: Text('Loading more orders...'));
            }
            if (hasReachedEnd && orders.isNotEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'No more orders to load',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }

          final order = orders[index];
          return GestureDetector(
            onTap: () => goToOrder(order),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order #${order.label}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (order.orderDate != null)
                              Text(
                                order.orderDate!.yMMMd(withTime: true),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Text(
                        order.orderTotal.toCurrency(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  Row(
                    spacing: 16,
                    children: List.generate(
                      min(order.cartItems.length, 5),
                      (index) {
                        if (index == 4) {
                          return Text(
                            'and more',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          );
                        }
                        final orderItem = order.cartItems[index];
                        return Stack(
                          children: [
                            SizedBox.square(
                              dimension: 54,
                              child: Image.network(
                                orderItem.imageUrl!,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: 2,
                              right: 2,
                              child: Text(
                                'x${orderItem.quantity}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
