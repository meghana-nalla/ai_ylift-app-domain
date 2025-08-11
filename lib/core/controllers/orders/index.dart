import 'package:YLift/core/controllers/global.dart';
import 'package:galaxy_models/galaxy_models.dart';
import 'package:get/get.dart';
import 'package:YLift/models/urls/api.dart';

class OrdersController extends GetxController {
  final GlobalController global = Get.find<GlobalController>();

  Future<void> initializeOrderHistoryData() async {
    global.orderHistory.value = [];
    global.orderHistoryCount.value = 0;
    await getOrders();
  }

  Future<List<OrderSimple>> getOrders({
    int? limit = 10,
    int? offset = 0,
  }) async {
    global.orderHistory.clear();
    try {
      if ((limit! + offset!) < global.orderHistory.length) {
        print('Fetching orders from memory');
        global.orderHistoryCount.value = global.orderHistory.length;
        return global.orderHistory.sublist(offset, (limit + offset));
      }

      print('Fetching orders from backend');
      final PhantomResponse response = await global.api.getData(
        ApiUrl.userOrderHistory.withQuery({
          'profileId': global.user.value.profileId.toString(),
          'limit': '$limit',
          'offset': '$offset',
          'sort': 'orderDate',
        }),
      );

      if (!response.isSuccess) {
        throw (response.message ??
            'an unknown error occurred whilst fetching orders');
      }

      final ordersData = response.data as Map<String, dynamic>;
      //int totalOrders = ordersData['totalCount'] as int;
      final rOrders = ordersData['history'] as List<dynamic>;
      if (rOrders.length == 0) {
        return [];
      }
      if (rOrders.length < (limit + offset)) {
        if (rOrders.length == global.orderHistory.length) {
          return global.orderHistory;
        }
      }
      final ordersToReturn = OrderSimple.fromList(rOrders);
      global.orderHistory.addAll(OrderSimple.fromList(rOrders));
      global.orderHistory.sort((a, b) {
        final dateA = a.orderDate;
        final dateB = b.orderDate;

        if (dateA == null && dateB == null) return 0;
        if (dateA == null) return 1;
        if (dateB == null) return -1;

        return dateB.compareTo(dateA);
      });
      global.orderHistoryCount.value = global.orderHistory.length;
      return ordersToReturn;
    } catch (e, stackTrace) {
      print('Error in OrdersController.getOrders(): $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }

  Future<List<OrderSimple>> fetchQuickOrders() async {
    try {
      PhantomResponse response = await global.api.getData(
        ApiUrl.quickOrdersList.path,
      );
      if (response.data != null && response.data!['count'] > 0) {
        final List<dynamic> ordersData = response.data!['orders'];
        final List<OrderSimple> quickOrders =
            ordersData
                .map(
                  (order) =>
                      OrderSimple.fromJson(order as Map<String, dynamic>),
                )
                .toList();
        return quickOrders;
      }
    } catch (e) {
      print('Error in OrdersController.getQuickOrders(): $e');
      return [];
    }
    return [];
  }

  Future<PhantomResponse> placeQuickOrder(
    String orderId,
    String? cardId,
  ) async {
    PhantomResponse response = await global.api.putData(
      ApiUrl.quickOrders.path,
      {
        'orderId': orderId,
        'cardId': cardId,
        'orderIdInt': int.parse(orderId),
      },
    );
    if (response.isSuccess) {
      final orderData = response.data!["cart"] as Map<String, dynamic>;
      final order = OrderSimple.fromJson(orderData);
      global.orderHistory.add(order);
      global.simpleCart.value.cartItems = [];
      global.refresh();
      await global.blowOutCarts();
      return response;
    } else {
      return response;
    }
  }

  Future<void> createScheduleOrder(
    int orderId,
    String name,
    String description,
    String frequency,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final response = await global.api.postData(
        '${ApiUrl.scheduleOrder.path}/$orderId',
        {
          "name": name,
          "description": description,
          "frequency": frequency,
          "startDate": startDate.toIso8601String(),
          "endDate": endDate.toIso8601String(),
          "requiresConfirmation": true,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Scheduled order created successfully!');
      } else {
        print('Failed to create order. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<List<ScheduledOrder>> getAllScheduledOrders() async {
    try {
      final response = await global.api.getData(ApiUrl.scheduleOrder.path);

      if (response.statusCode == 200) {
        final data =
            response.data['scheduledOrders'] as List<dynamic>; // get the list
        return data.map((json) => ScheduledOrder.fromJson(json)).toList();
      } else {
        print('Failed to fetch orders. Status: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching scheduled orders: $e');
      return [];
    }
  }

  Future<ScheduledOrder?> getScheduledOrder(String id) async {
    try {
      final response = await global.api.getData('${ApiUrl.scheduleOrder.path}/$id');

      if (response.statusCode == 200) {
        //final data = response.data;
        final data = response.data['scheduledOrder'];
        print('API Response: ${response.data}'); // 👈 this will show you the raw JSON
        return ScheduledOrder.fromJson(data);
      } else {
        print('Failed to fetch order. Status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching scheduled order: $e');
      return null;
    }
  }

  Future<void> deleteScheduledOrder(String id) async {
    try {
      final response = await global.api.deleteData('${ApiUrl.scheduleOrder.path}/$id');

      if (response.statusCode == 200) {
        print('Phantom Response delete schedule order : ${response.message}');
      } else {
        print('Failed to delete scheduled order: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching scheduled order: $e');
      return null;
    }
  }



}
