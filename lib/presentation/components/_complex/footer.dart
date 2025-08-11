import 'package:YLift/core/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:YLift/core/controllers/global.dart';

class GalaxyFooter extends StatelessWidget {
  GalaxyFooter({super.key});
  final controller = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: YLiftConstant.footerHeight,
          color: Colors.black,
          alignment: Alignment.center,
          child: SizedBox(
            width: YLiftConstant.pageWidth,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (false) ...[
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: GalaxyFooterSection(
                            title: "GET TO KNOW US",
                            items: ["About Us", "Partnership", "Y LIFT Home"],
                          ),
                        ),
                        Expanded(
                          child: GalaxyFooterSection(
                            title: "SHOP & TRAIN",
                            items: [
                              "Unlock Top-Tier Pricing",
                              "Provider FAQ",
                              "Exchange & Return",
                              "List Your Products"
                            ],
                          ),
                        ),
                        Expanded(
                          child: GalaxyFooterSection(
                            title: "LET US HELP YOU",
                            items: ["Manage Account", "Your Orders", "Notifications", "Contact Us"],
                          ),
                        ),
                        Expanded(
                          child: SubscriptionSection(),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Colors.grey, height: 32),
                ],
                BottomGalaxyFooter(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class GalaxyFooterSection extends StatelessWidget {
  final String title;
  final List<String> items;

  const GalaxyFooterSection({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GalaxyFooterSectionTitle(title: title),
          ...items.map((item) => GalaxyFooterSectionItem(title: item)),
        ],
      ),
    );
  }
}

class SubscriptionSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GalaxyFooterSectionTitle(title: "Subscribe"),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Email Address',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.facebook, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BottomGalaxyFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (MediaQuery
        .of(context)
        .size
        .width > 640) {
      // DESKTOP FOOTER
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // VERSION CHANGE
          Text(
            "© ${DateTime
                .now()
                .year} Y LIFT All Rights Reserved | ${YLiftConstant.version}",
            style: TextStyle(color: Colors.white),
          ),
          // Row(
          //   children: [
          //     GalaxyFooterSectionItem(title: "Terms of Use", isGalaxyFooterLink: true),
          //     SizedBox(width: 16),
          //     GalaxyFooterSectionItem(title: "Term of Sales", isGalaxyFooterLink: true),
          //     SizedBox(width: 16),
          //     GalaxyFooterSectionItem(title: "Privacy & Cookies", isGalaxyFooterLink: true),
          //   ],
          // ),
        ],
      );
    } else {
      // MOBILE FOOTER
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0), // Adjust padding as needed
            child: Text(
              "© ${DateTime.now().year} Y LIFT All Rights Reserved | ${YLiftConstant.version}",
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          // Uncomment if needed
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     GalaxyFooterSectionItem(title: "Terms of Use", isGalaxyFooterLink: true),
          //     SizedBox(width: 16),
          //     GalaxyFooterSectionItem(title: "Term of Sales", isGalaxyFooterLink: true),
          //     SizedBox(width: 16),
          //     GalaxyFooterSectionItem(title: "Privacy & Cookies", isGalaxyFooterLink: true),
          //   ],
          // ),
        ],
      );
    }
  }
}

class GalaxyFooterSectionTitle extends StatelessWidget {
  final String title;

  const GalaxyFooterSectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}

class GalaxyFooterSectionItem extends StatelessWidget {
  final String title;
  final bool isGalaxyFooterLink;

  const GalaxyFooterSectionItem({
    required this.title,
    this.isGalaxyFooterLink = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          color: isGalaxyFooterLink ? Colors.grey : Colors.white,
          decoration: isGalaxyFooterLink ? TextDecoration.underline : TextDecoration.none,
          fontSize: 14,
        ),
      ),
    );
  }
}
