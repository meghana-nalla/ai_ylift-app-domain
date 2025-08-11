import 'package:flutter/material.dart';

class OrderFailurePage extends StatelessWidget {
  final String message;
  OrderFailurePage({required this.message});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, color: Colors.red, size: 100),
            SizedBox(height: 20),
            Text('Sorry, your order did not process.', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Reason : $message' , style: TextStyle(fontSize: 18)),
            SizedBox(height: 30),
            ElevatedButton(
              child: Text('Return to Checkout'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}