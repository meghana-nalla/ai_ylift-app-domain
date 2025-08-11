import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class TrainingManagement extends StatefulWidget {
  @override
  _TrainingManagementState createState() => _TrainingManagementState();
}

class _TrainingManagementState extends State<TrainingManagement> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Statistics'),
            Tab(text: 'Finances'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          StatisticsView(fromDate: fromDate, toDate: toDate, onDateChange: _updateDates),
          FinancesView(),
        ],
      ),
    );
  }

  void _updateDates(DateTime from, DateTime to) {
    setState(() {
      fromDate = from;
      toDate = to;
    });
  }
}

class StatisticsView extends StatelessWidget {
  final DateTime fromDate;
  final DateTime toDate;
  final Function(DateTime, DateTime) onDateChange;

  StatisticsView({required this.fromDate, required this.toDate, required this.onDateChange});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildDateFilter(),
        Expanded(
          child: _buildStatisticsTable(context),
        ),
      ],
    );
  }

  Widget _buildDateFilter() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(labelText: 'From'),
              controller: TextEditingController(text: DateFormat('yyyy-MM-dd').format(fromDate)),
              // onTap: () async {
              //   final date = await showDatePicker(
              //     context: context,
              //     initialDate: fromDate,
              //     firstDate: DateTime(2000),
              //     lastDate: DateTime.now(),
              //   );
              //   if (date != null) onDateChange(date, toDate);
              // },
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(labelText: 'To'),
              controller: TextEditingController(text: DateFormat('yyyy-MM-dd').format(toDate)),
              // onTap: () async {
              //   final date = await showDatePicker(
              //     context: context,
              //     initialDate: toDate,
              //     firstDate: DateTime(2000),
              //     lastDate: DateTime.now(),
              //   );
              //   if (date != null) onDateChange(fromDate, date);
              // },
            ),
          ),
          SizedBox(width: 16),
          Row(
            children: [
                ElevatedButton(
                onPressed: () {
                // TODO: Implement show report logic
                },
                child: Text('Show'),
                ),
                ElevatedButton(
                onPressed: () {
                // TODO: Implement show report logic
                },
                child: Text('Show All'),
                ),]),
        ],
      ),
    );
  }

  Widget _buildStatisticsTable(context) {
    // TODO: replace sample data
    final List<Map<String, dynamic>> statistics = [
      {'title': 'Training 1', 'purchasedCount': 10, 'inProgress': 5, 'totalLectures': 20, 'totalViews': 100, 'finished': 3},
      {'title': 'Training 2', 'purchasedCount': 15, 'inProgress': 8, 'totalLectures': 25, 'totalViews': 150, 'finished': 5},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width - 32,
    ),child:DataTable(
        columns: [
          DataColumn(label: Text('Training')),
          DataColumn(label: Text('Purchased')),
          DataColumn(label: Text('In Progress')),
          DataColumn(label: Text('Total Lectures')),
          DataColumn(label: Text('Lectures Viewed')),
          DataColumn(label: Text('Finished')),
        ],
        rows: statistics.map((stat) => DataRow(
          cells: [
            DataCell(Text(stat['title'])),
            DataCell(Text(stat['purchasedCount'].toString())),
            DataCell(Text(stat['inProgress'].toString())),
            DataCell(Text(stat['totalLectures'].toString())),
            DataCell(Text(stat['totalViews'].toString())),
            DataCell(Text(stat['finished'].toString())),
          ],
        )).toList(),
      ),
    ));
  }
}



class FinancesView extends StatefulWidget {
  @override
  _FinancesViewState createState() => _FinancesViewState();
}

class _FinancesViewState extends State<FinancesView> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  int currentPage = 1;
  int perPage = 11;
  double total = 0;
  List<Map<String, dynamic>> finances = [];

  @override
  void initState() {

    super.initState();
    loadFinances();
  }

  void loadFinances() {
    // TODO: Implement API call to load finances
    // This should update the 'finances' list and 'total'
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildDateFilter(context),
        _buildTotalProfit(),
        Expanded(child: _buildFinancesTable(context)),
        _buildPagination(),
      ],
    );
  }



  Widget _buildDateFilter(context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(child: Text('From')),
          Expanded(
            flex: 3,
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              ),
              controller: TextEditingController(text: DateFormat('yyyy-MM-dd').format(fromDate)),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: fromDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (date != null) setState(() => fromDate = date);
              },
            ),
          ),
          SizedBox(width: 16),
          Expanded(child: Text('To')),
          Expanded(
            flex: 3,
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              ),
              controller: TextEditingController(text: DateFormat('yyyy-MM-dd').format(toDate)),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: toDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (date != null) setState(() => toDate = date);
              },
            ),
          ),
          SizedBox(width: 16),
          Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement show report logic
                  },
                  child: Text('Show'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement show report logic
                  },
                  child: Text('Show All'),
                ),]),
        ],
      ),
    );
  }

  Widget _buildTotalProfit() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          'Total profit: \$${total.toStringAsFixed(2)}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }




  Widget _buildFinancesTable(context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
  constraints: BoxConstraints(
  minWidth: MediaQuery.of(context).size.width - 32,
  ),child:DataTable(
        columns: [
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Training')),
          DataColumn(label: Text('Owner')),
          DataColumn(label: Text('Amount')),
          DataColumn(label: Text('Your commission')),
          DataColumn(label: Text('Discount')),
        ],
        rows: finances.map((finance) => DataRow(
          cells: [
            DataCell(Text(DateFormat('MMMM d, y, h:mm:ss a').format(DateTime.parse(finance['transactionDate'])))),
            DataCell(
              GestureDetector(
                onTap: () {
                  // TODO: Navigate to training details
                },
                child: Text(finance['title'], style: TextStyle(color: Colors.blue)),
              ),
            ),
            DataCell(Text(finance['ownerName'])),
            DataCell(Text('\$${(finance['amount'] / 100).toStringAsFixed(2)}')),
            DataCell(Text('\$${(finance['systemCommission'] / 100).toStringAsFixed(2)}')),
            DataCell(Text('${finance['discount'] ?? 0}%')),
          ],
        )).toList(),
      ),
    ));
  }

  Widget _buildPagination() {
    // TODO: Implement pagination
    return Container();
  }
}
