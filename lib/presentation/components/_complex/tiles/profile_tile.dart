import 'package:YLift/core/constants/color.dart';
import 'package:YLift/core/constants/constant.dart';
import 'package:YLift/core/constants/text_style.dart';
import 'package:YLift/core/controllers/z-index_export.dart';
import 'package:YLift/presentation/components/_complex/desktop_view/gap.dart';
import 'package:YLift/presentation/components/_complex/desktop_view/panel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:galaxy_ui/galaxy_ui.dart';
class ProfileTile extends StatelessWidget {
  final Widget leading;
  final String username;
  final String subtitle;
  const ProfileTile({
    super.key,
    required this.leading,
    required this.username,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return GalaxyPanel(
      width: YLiftConstant.pageWidth,
      child: Stack(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 80,
                child: leading,
              ),
              const GapX(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(username, style: YLiftTextStyle.title),
                  Text(subtitle, style: const TextStyle(color: YLiftColor.grey)),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: YLiftFilledButton(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              backgroundColor: YLiftColor.beige,
              foregroundColor: Colors.black,
              onPressed: () async {
                final controller = Get.find<GlobalController>();
                await controller.auth.processLogout();
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Log out'),
                  SizedBox(width: 16),
                  Icon(Icons.logout, size: 16, color: Colors.black),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
