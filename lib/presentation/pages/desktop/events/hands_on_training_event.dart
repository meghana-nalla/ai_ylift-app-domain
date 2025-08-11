import 'package:YLift/core/constants/hardcoded_id.dart';
import 'package:YLift/core/controllers/global.dart';
import 'package:YLift/presentation/pages/desktop/__primary_courses/components/events_checkout/event_checkout_dialog.dart';
import 'package:YLift/presentation/pages/desktop/__primary_courses/components/video_checkout/video_checkout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
import 'package:YLift/presentation/components/_complex/footer.dart';
import 'package:get/get.dart';
import 'package:web/web.dart' as web;

class HandsOnTrainingPage extends StatefulWidget {
  @override
  _GalaxyProtoTypeState createState() => _GalaxyProtoTypeState();
}

class _GalaxyProtoTypeState extends State<HandsOnTrainingPage> {
  final global = Get.find<GlobalController>();
  final GlobalKey _bottomSectionKey = GlobalKey();

  static const String _pendingVideoDialogKey = 'pendingVideoDialog';

  void _saveVideoDialogAction(String videoId) {
    // web.window.localStorage.setItem(_pendingVideoDialogKey, videoId);
  }

  void _handleGetTicketsNow() {
    if (global.isAuthenticated.isFalse) {
      _saveVideoDialogAction(HardcodedId.eventTwoDay);
      global.vroute.navigateTo('/login');
      return;
    }
    if (global.user.value.hasVirtualContentById(HardcodedId.eventTwoDay)) {
      // User already has the content, show the video checkout dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('You already bought this ticket'),
          );
        },
      );
      return;
    }
    showDialog(
      context: context,
      builder: (context) {
        return EventCheckoutDialog(virtualProductId: HardcodedId.eventTwoDay);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 120),
            EventsTopSection(
              bottomSectionKey: _bottomSectionKey,
              onGetTicketsPressed: _handleGetTicketsNow,
            ),
            SizedBox(height: 40),
            EventsMiddleSection(
              hasPurchased60Box: global.user.value.hasVirtualContentById(
                HardcodedId.eventTwoDay,
              ),
              hasPurchased40BoxBody:
                  global.user.value.hasVirtualContentById(
                    HardcodedId.eventZoeID,
                  ) ||
                  global.user.value.hasVirtualContentById(
                    HardcodedId.eventTwoDay,
                  ),
              hasPurchased40BoxFace:
                  global.user.value.hasVirtualContentById(
                    HardcodedId.eventAmyID,
                  ) ||
                  global.user.value.hasVirtualContentById(
                    HardcodedId.eventTwoDay,
                  ),
              on60BoxPressed: () {
                // Check if the user is logged in
                if (global.isAuthenticated.isFalse) {
                  _saveVideoDialogAction(HardcodedId.eventTwoDay);
                  global.vroute.navigateTo('/login');
                  return;
                }
                showDialog(
                  context: context,
                  builder: (context) {
                    return EventCheckoutDialog(
                      virtualProductId: HardcodedId.eventTwoDay,
                    );
                  },
                );
              },
              on40BoxBodyPressed: () {
                // Check if the user is logged in
                if (global.isAuthenticated.isFalse) {
                  _saveVideoDialogAction(HardcodedId.eventZoeID);
                  global.vroute.navigateTo('/login');
                  return;
                }
                showDialog(
                  context: context,
                  builder: (context) {
                    return EventCheckoutDialog(
                      virtualProductId: HardcodedId.eventZoeID,
                    );
                  },
                );
              },
              on40BoxFacePressed: () {
                // Check if the user is logged in
                if (global.isAuthenticated.isFalse) {
                  _saveVideoDialogAction(HardcodedId.eventAmyID);
                  global.vroute.navigateTo('/login');
                  return;
                }
                showDialog(
                  context: context,
                  builder: (context) {
                    return EventCheckoutDialog(
                      virtualProductId: HardcodedId.eventAmyID,
                    );
                  },
                );
              },
            ),
            SizedBox(height: 30),
            Container(
              key: _bottomSectionKey, //
              child: EventsBottomSection(
                onLimitedSlotsPressed: () {
                  print("Tickets box tapped!");
                  // Navigate or scroll as needed
                },
              ),
            ),
            GalaxyFooter(),
          ],
        ),
      ),
    );
  }
}
