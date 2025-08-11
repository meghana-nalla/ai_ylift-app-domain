import 'package:flutter/material.dart';
import 'package:YLift/core/controllers/global.dart';
import 'order_failed.dart';
import 'order_success.dart';
import 'package:get/get.dart';

class ProcessingOrderPage extends StatefulWidget {
  @override
  _ProcessingOrderPageState createState() => _ProcessingOrderPageState();
}

class _ProcessingOrderPageState extends State<ProcessingOrderPage> {
  final GlobalController controller = Get.find<GlobalController>();

  @override
  void initState() {
    super.initState();
    _simulateProcessing();
  }

  void _simulateProcessing() async {

   // var (success, message) = await controller.basket.createOrder(controller.cart.value.checkout!.ready!);
   //
   //  // final random = Random(); // random.nextBool()
   //  if (success) {
   //    Navigator.of(context).pushReplacement(
   //      MaterialPageRoute(
   //        builder: (context) => OrderSuccessPage(orderNumber: 400),
   //      ),
   //    );
   //  } else {
   //    Navigator.of(context).pushReplacement(
   //      MaterialPageRoute(
   //        builder: (context) => OrderFailurePage(message: message),
   //      ),
   //    );
   //  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Processing Order...', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}