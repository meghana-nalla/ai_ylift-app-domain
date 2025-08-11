import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class OrderHistoryView extends StatefulWidget {
  @override
  _OrderHistoryViewState createState() => _OrderHistoryViewState();
}

class _OrderHistoryViewState extends State<OrderHistoryView> {
  List<Map<String, dynamic>> orders = [];
  bool isLoading = true;
  TextEditingController nameController = TextEditingController();
  DateTime? createdAfter;
  DateTime? createdBefore;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    // Simulating API call
    await Future.delayed(Duration(seconds: 2));
    // TODO: Replace with actual API call
    setState(() {
      orders = [
        {
          'id': '1',
          'label': 'ORD-001',
          'createdAt': DateTime(2023, 6, 1),
          'status': 'Completed',
          'amount': 9999,
          'orderItems': [
            {'product': {'name': 'Product A'}, 'quantity': 2, 'unitPrice': 2500, 'amount': 5000},
            {'product': {'name': 'Product B'}, 'quantity': 1, 'unitPrice': 4999, 'amount': 4999},
          ],
        },
        {
          'id': '2',
          'label': 'ORD-002',
          'createdAt': DateTime(2023, 6, 15),
          'status': 'Processing',
          'amount': 7500,
          'orderItems': [
            {'product': {'name': 'Product C'}, 'quantity': 3, 'unitPrice': 2500, 'amount': 7500},
          ],
        },
      ];
      isLoading = false;
    });
  }

  List<Map<String, dynamic>> _filterOrders() {
    return orders.where((order) {
      bool nameMatch = nameController.text.isEmpty ||
          order['orderItems'].any((item) =>
              item['product']['name'].toLowerCase().contains(nameController.text.toLowerCase()));
      bool dateMatch = (createdAfter == null || order['createdAt'].isAfter(createdAfter!)) &&
          (createdBefore == null || order['createdAt'].isBefore(createdBefore!));
      return nameMatch && dateMatch;
    }).toList();
  }

  Future<void> _exportToCsv() async {
    List<List<dynamic>> csvData = [
      ['Order ID', 'Date', 'Item', 'Quantity', 'Unit Price', 'Total Item Cost']
    ];

    for (var order in _filterOrders()) {
      for (var item in order['orderItems']) {
        csvData.add([
          order['label'],
          DateFormat('yyyy-MM-dd HH:mm:ss').format(order['createdAt']),
          item['product']['name'],
          item['quantity'],
          (item['unitPrice'] / 100).toStringAsFixed(2),
          (item['amount'] / 100).toStringAsFixed(2),
        ]);
      }
    }

    String csv = const ListToCsvConverter().convert(csvData);
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/order_history.csv';
    final file = File(path);
    await file.writeAsString(csv);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('CSV file saved to: $path')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        nameController.clear();
                        setState(() {});
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'From'),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: createdAfter ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            setState(() => createdAfter = date);
                          }
                        },
                        controller: TextEditingController(
                          text: createdAfter != null ? DateFormat('yyyy-MM-dd').format(createdAfter!) : '',
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'To'),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: createdBefore ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            setState(() => createdBefore = date);
                          }
                        },
                        controller: TextEditingController(
                          text: createdBefore != null ? DateFormat('yyyy-MM-dd').format(createdBefore!) : '',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => setState(() {}),
                      child: Text('Filter'),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _exportToCsv,
                      child: Text('Export to CSV'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : _buildOrderTable(),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderTable() {
    final filteredOrders = _filterOrders();
    return filteredOrders.isEmpty
        ? Center(child: Text('No orders found'))
        : SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text('Order #')),
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Total')),
        ],
        rows: filteredOrders.map((order) {
          return DataRow(
            cells: [
              DataCell(
                Text(order['label']),
                onTap: () {
                  // TODO : Implement Navigate to the order details
                  print('Navigate to order ${order['id']}');
                },
              ),
              DataCell(Text(DateFormat('yyyy-MM-dd HH:mm').format(order['createdAt']))),
              DataCell(Text(order['status'])),
              DataCell(Text('\$${(order['amount'] / 100).toStringAsFixed(2)}')),
            ],
          );
        }).toList(),
      ),
    );
  }
}