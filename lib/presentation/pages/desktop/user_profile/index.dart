import 'package:YLift/core/constants/color.dart';
import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/core/constants/text_style.dart';
import 'package:YLift/presentation/components/_complex/panels/customer_feedback_panel.dart';
import 'package:YLift/presentation/components/_complex/panels/liked_products_panel.dart';
import 'package:YLift/presentation/components/_complex/panels/subscriptions_panel.dart';
import 'package:YLift/presentation/components/z-index_export.dart';
import 'package:YLift/presentation/pages/mobile/training/training_detail_page/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:YLift/core/controllers/global.dart';
import '../../../../core/constants/index.dart';
import '../../../components/_complex/panels/medical_license_panel.dart';
import '../../../components/_complex/panels/video_content_panel.dart';
import 'components/basic_information_panel.dart';
import 'components/order_history.dart';
import 'components/schedule_order_panel.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'components/feedbacks_panel.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final global = Get.find<GlobalController>();
  String navigation = 'myAccount';
  int selectedTab = 0;

  void setPanel(String value, int tab) {
    setState(() {
      navigation = value;
      selectedTab = tab;
    });
  }

  @override
  void initState() {
    if (global.isAuthenticated.isFalse) global.vroute.navigateTo('/login', redirectPath: '/profile');
    initTabNav();
    super.initState();
  }

  void initTabNav(){
    final url = Uri.base.toString();
    if(url.contains('#medical_license')){
      navigation = 'myAccount';
      selectedTab = 3;
    }
  }

  Widget _buildRightPanel() {
    switch (navigation) {
      case 'myAccount':
        return MyAccountPanel(
          selectedTab: selectedTab,
          onTabSelected: (index) => setPanel('myAccount', index),
        );
      case 'orders':
        return OrdersTabs(
          selectedTab: selectedTab,
          onTabSelected: (index) => setPanel('orders', index),
        );
      case 'myActivity':
        return myActivityTabs(
          selectedTab: selectedTab,
          onTabSelected: (index) => setPanel('myActivity', index),
        );
      // case 'myContent':
      //   return myContentTabs(
      //     selectedTab: selectedTab,
      //     onTabSelected: (index) => setPanel('myContent', index),
      //   );
      case 'settings':
        return SettingsTabs(
          selectedTab: selectedTab,
          onTabSelected: (index) => setPanel('settings', index),
        );
      case 'others':
        return OthersTabs(
          selectedTab: selectedTab,
          onTabSelected: (index) => setPanel('others', index),
        );
      default:
        return MyAccountPanel(
          selectedTab: selectedTab,
          onTabSelected: (index) => setPanel('myAccount', index),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GalaxyPageScaffold(
      children: [
        ProfileTile(
          leading: const Icon(Icons.person),
          username: global.user.value.name ?? '(No name)',
          // subtitle: global.user.value.description ?? '',
          subtitle: 'Account: ${global.user.value.email}',
        ),
        const GapY(),
        SizedBox(
          width: YLiftConstant.pageWidth,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: GalaxyPanel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('MY ACCOUNT'),
                      YLiftTextButton(
                        isSelected: navigation == 'myAccount' && selectedTab == 0,
                        onPressed: () => setPanel('myAccount', 0),
                        child: const Text('Profile'),
                      ),
                      YLiftTextButton(
                        isSelected: navigation == 'myAccount' && selectedTab == 1,
                        onPressed: () => setPanel('myAccount', 1),
                        child: const Text('Saved Wallets'),
                      ),
                      YLiftTextButton(
                        isSelected: navigation == 'myAccount' && selectedTab == 2,
                        onPressed: () => setPanel('myAccount', 2),
                        child: const Text('Address Book'),
                      ),
                      YLiftTextButton(
                        isSelected: navigation == 'myAccount' && selectedTab == 3,
                        onPressed: () => setPanel('myAccount', 3),
                        child: const Text('Medical License'),
                      ),
                      // YLiftTextButton(
                      //   onPressed: () => setPanel('myAccount',3),
                      //   child: const Text('Wishlist'),
                      // ),
                      const Divider(),
                      const Text('ORDERS'),
                      if(BETA)
                        YLiftTextButton(
                          isSelected: navigation == 'orders' && selectedTab == 0,
                          onPressed: () => setPanel('orders', 0),
                          child: const Text('Scheduled Orders'),
                        ),
                      YLiftTextButton(
                        isSelected: navigation == 'orders' && selectedTab == (!BETA ? 0 : 1),
                        onPressed: () => setPanel('orders', (!BETA ? 0 : 1),),
                        child: const Text('History / Reorder'),
                      ),
                      // YLiftTextButton(
                      //   isSelected: navigation == 'orders' && selectedTab == 1,
                      //   onPressed: () => setPanel('orders', 1),
                      //   child: const Text('Recurring Orders'),
                      // ),
                      // YLiftTextButton(
                      //   isSelected: navigation == 'orders' && selectedTab == 2,
                      //   onPressed: () => setPanel('orders', 2),
                      //   child: const Text('Saved Product Items'),
                      // ),
                      const Divider(),
                      const Text('MY ACTIVITY'),
                      YLiftTextButton(
                        isSelected: navigation == 'myActivity' && selectedTab == 0,
                        onPressed: () => setPanel('myActivity', 0),
                        child: const Text('Liked Products'),
                      ),

                      // const Divider(),
                      // const Text('MY CONTENT'),
                      // YLiftTextButton(
                      //   isSelected: navigation == 'myContent' && selectedTab == 0,
                      //   onPressed: () => setPanel('myContent', 0),
                      //   child: const Text('Subscriptions'),
                      // ),
                      // YLiftTextButton(
                      //   isSelected: navigation == 'myContent' && selectedTab == 0,
                      //   onPressed: () => setPanel('myContent', 0),
                      //   child: const Text('Video Content'),
                      // ),
                      const Divider(),
                      const Text('SETTINGS'),
                      YLiftTextButton(
                        isSelected: navigation == 'settings' && selectedTab == 0,
                        onPressed: () => setPanel('settings', 0),
                        child: const Text('Account & Password'),
                      ),
                      const Divider(),
                      const Text('System'),
                      YLiftTextButton(
                        isSelected: navigation == 'others' && selectedTab == 0,
                        onPressed: () => setPanel('others', 0),
                        child: const Text('Give Feedback'),
                      ),

                      // YLiftTextButton(
                      //   isSelected: navigation == 'settings' && selectedTab == 1,
                      //   onPressed: () => setPanel('settings', 1),
                      //   child: const Text('Notifications'),
                      // ),
                      // YLiftTextButton(
                      //   isSelected: navigation == 'settings' && selectedTab == 2,
                      //   onPressed: () => setPanel('settings', 2),
                      //   child: const Text('Feedback'),
                      // ),
                    ],
                  ),
                ),
              ),
              const GapX(),
              Expanded(
                flex: 3,
                child: _buildRightPanel(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

class MyAccountPanel extends StatelessWidget {
  final int selectedTab;
  final void Function(int index)? onTabSelected;

  const MyAccountPanel({
    super.key,
    required this.selectedTab,
    this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return TrainingTabs(
      selectedTab: selectedTab,
      onTabSelected: onTabSelected,
      tabs: const <Widget>[
        Text('Profile'),
        Text('Wallet'),
        Text('Address Book'),
        Text('Medical License')
        // Text('Wishlist'),
      ],
      pages: [
        // Profile
        BasicInformationPanel(),

        // Wallets
        WalletsPanel(),

        // Address Book
        AddressBookPanel(),

        // Medical License
        MedicalLicensePanel(),

        // Wishlist
        // Column(
        //   children: [
        //     Text('Wishlist content goes here'),
        //   ],
        // ),
      ],
    );
  }
}

class myActivityTabs extends StatelessWidget {
  final int selectedTab;
  final void Function(int index)? onTabSelected;
  const myActivityTabs({
    super.key,
    required this.selectedTab,
    this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return TrainingTabs(
      selectedTab: selectedTab,
      onTabSelected: onTabSelected,
      tabs: <Widget>[
        // Text('My Courses'),
        // Text('Subscriptions'),
        Text('Liked Products'),
      ],
      pages: <Widget>[
        // // My courses panel
        // MyActivityPanel(),
        //
        // // Subscriptions panel
        // SizedBox(
        //   height: 400,
        //   width: double.infinity,
        //   child: Center(
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Text(
        //           'Coming soon',
        //           style: YLiftTextStyle.title,
        //         ),
        //       ],
        //     ),
        //   ),
        // ),

        // Liked Products
        const LikedProductsPanel(),
        //const FeedbacksPanel(),
      ],
    );
  }
}


// class myContentTabs extends StatelessWidget {
//   final int selectedTab;
//   final void Function(int index)? onTabSelected;
//   const myContentTabs({
//     super.key,
//     required this.selectedTab,
//     this.onTabSelected,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return TrainingTabs(
//       selectedTab: selectedTab,
//       onTabSelected: onTabSelected,
//       tabs: <Widget>[
//         // const Text('Subscriptions'),
//         const Text('Video Content'),
//       ],
//       pages: <Widget>[
//         // const SubscriptionsPanel(),
//         const VideoContentsPanel(),
//       ],
//     );
//   }
// }

class OrdersTabs extends StatelessWidget {
  final int selectedTab;
  final void Function(int index)? onTabSelected;

  const OrdersTabs({
    super.key,
    required this.selectedTab,
    this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return TrainingTabs(
      selectedTab: selectedTab,
      onTabSelected: onTabSelected,
      tabs: <Widget>[
        if(BETA) Text('Scheduled Orders'),
        Text('History / Reorder'),
        // Text('Recurring Orders'),
        // Text('Saved Product Items'),
      ],
      pages: <Widget>[
        // Order history tab
        if(BETA)   ScheduledOrdersPanel(),
        OrderHistoryPanel(),

        // Reorder tab
        // SizedBox(
        //   height: 400,
        //   width: double.infinity,
        //   child: Center(
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Text(
        //           'Coming soon',
        //           style: YLiftTextStyle.title,
        //         ),
        //       ],
        //     ),
        //   ),
        // ),

        // Saved Products Panel / Save for later
        // const SavedProductsPanel(),
      ],
    );
  }
}

class OthersTabs extends StatelessWidget {
  final int selectedTab;
  final void Function(int index)? onTabSelected;

  const OthersTabs({
    super.key,
    required this.selectedTab,
    this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return TrainingTabs(
      selectedTab: selectedTab,
      onTabSelected: onTabSelected,
      tabs: <Widget>[
        Text('Feedbacks'),
        // Text('Recurring Orders'),
        // Text('Saved Product Items'),
      ],
      pages: <Widget>[
        // Order history tab
        FeedbacksPanel(),

        // Reorder tab
        // SizedBox(
        //   height: 400,
        //   width: double.infinity,
        //   child: Center(
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Text(
        //           'Coming soon',
        //           style: YLiftTextStyle.title,
        //         ),
        //       ],
        //     ),
        //   ),
        // ),

        // Saved Products Panel / Save for later
        // const SavedProductsPanel(),
      ],
    );
  }
}

class SettingsTabs extends StatelessWidget {
  final int selectedTab;
  final void Function(int index)? onTabSelected;

  const SettingsTabs({
    super.key,
    required this.selectedTab,
    this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return TrainingTabs(
      selectedTab: selectedTab,
      onTabSelected: onTabSelected,
      tabs: <Widget>[
        Text('Account & Password'),
        // Text('Notifications'),
        // Text('Feedback'),
      ],
      pages: <Widget>[
        // Account and Password tab
        SizedBox(
          height: 400,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 160,
                child: RoundedFilledButton(
                  onPressed: () async {
                    final email = global.user.value.email;
                    await global.auth.sendPasswordReset(email: email);

                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Reset Password Email Sent'),
                        content: Text('A reset password confirmation has been sent to your email.\nPlease proceed from there.'),
                        actions: [
                          TextButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('Reset Password'),
                ),
              ),
              // Text(
              //   'Coming soon',
              //   style: YLiftTextStyle.title,
              // ),
            ],
          ),
        ),

        // Notifications tab
        // SizedBox(
        //   height: 400,
        //   width: double.infinity,
        //   child: Center(
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Text(
        //           'Coming soon',
        //           style: YLiftTextStyle.title,
        //         ),
        //       ],
        //     ),
        //   ),
        // ),

        // Customer Feedback
        // SizedBox(
        //   height: 400,
        //   width: double.infinity,
        //   child: Center(
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Text(
        //           'Coming soon',
        //           style: YLiftTextStyle.title,
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        // CustomerFeedbackPanel(), // uncomment this once the customerFeedback is ready
      ],
    );
  }
}
