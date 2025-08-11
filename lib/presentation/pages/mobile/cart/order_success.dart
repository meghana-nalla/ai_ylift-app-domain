import 'package:flutter/material.dart';


// TODO: Implement OrderSuccessPage Desgin
class OrderSuccessPage extends StatelessWidget {
  final int orderNumber;

  const OrderSuccessPage({Key? key, required this.orderNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 100),
            SizedBox(height: 20),
            Text('Thank you, your order has been placed!', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Order #$orderNumber', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 30),
            ElevatedButton(
              child: Text('Go Home'),
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
    );
  }
}