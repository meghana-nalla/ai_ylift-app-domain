import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:YLift/presentation/pages/mobile/profile/shopping/resale_certificates.dart';
import 'package:YLift/presentation/pages/mobile/profile/shopping/speacialty.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:YLift/core/controllers/z-index_export.dart';
import '../orders/index.dart';
import 'medical_license.dart';

class ProfileShoppingScreen extends StatefulWidget {
  @override
  _ProfileShoppingScreenState createState() => _ProfileShoppingScreenState();
}

class _ProfileShoppingScreenState extends State<ProfileShoppingScreen> with SingleTickerProviderStateMixin {
  final GlobalController controller = Get.find<GlobalController>();

  late TabController _tabController;

  final List<String> tabs = [
    'Order History',
    'Medical License',
    'Specialty',
    'Resale Certificate',
    'Current Promotions',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }
  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: AnimatedRouteDisplay(
          parentRoute: 'Shop Y',
          childRoute: tabs[_tabController.index],
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: tabs.map((String name) => Tab(text: name)).toList(),
          indicatorColor: Theme.of(context).colorScheme.primary,
          labelColor: Theme.of(context).colorScheme.onSurface,
          unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: tabs.map((String name) {
          return _buildTabContent(name);
        }).toList(),
      ),
    );
  }

  Widget _buildTabContent(String tabName) {
    switch (tabName) {
      case 'Order History':
        return OrderHistoryView();
      case 'Medical License':
        return MedicalLicensesView();
        case 'Specialty':
          return SpecialtySettings();
      case 'Resale Certificate':
        return ResaleCertificatesList();

      default:
        return Center(child: Text('Content for $tabName'));
    }
  }
}


