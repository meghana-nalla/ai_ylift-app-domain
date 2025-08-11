// import 'package:flutter/material.dart';
//
// class TrainingTabs extends StatefulWidget {
//   @override
//   _TrainingTabsState createState() => _TrainingTabsState();
// }
//
// class _TrainingTabsState extends State<TrainingTabs> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           color: Colors.grey[300],
//           child: TabBar(
//             controller: _tabController,
//             tabs: const [
//               Tab(text: 'Trainings'),
//               Tab(text: 'Online Courses'),
//             ],
//             labelColor: Colors.black,
//             unselectedLabelColor: Colors.grey,
//             indicatorColor: Colors.black,
//           ),
//         ),
//         Expanded(
//           child: TabBarView(
//             controller: _tabController,
//             children: [
//               _buildTrainingsTab(),
//               _buildOnlineCoursesTab(),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTrainingsTab() {
//     return Container(
//       color: Color(0xFFBEB19E),
//       padding: EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Enjoy Y LIFT Network Benefits',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
//           ),
//           SizedBox(height: 8),
//           Text(
//             'After registering for trainings',
//             style: TextStyle(fontSize: 14, color: Colors.white),
//           ),
//           SizedBox(height: 16),
//           _buildBenefitItem('Master the latest minimally invasive techniques'),
//           _buildBenefitItem('Get exclusive top-tier pricing on products'),
//           _buildBenefitItem('Use of all Media Kit promotional materials'),
//           _buildBenefitItem('Patient leads sent to you'),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBenefitItem(String text) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           Icon(Icons.check, color: Colors.white, size: 20),
//           SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               text,
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildOnlineCoursesTab() {
//     return Center(
//       child: Text('Online Courses Content'),
//     );
//   }
// }