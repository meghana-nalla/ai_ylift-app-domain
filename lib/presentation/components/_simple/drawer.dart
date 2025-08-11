import 'package:flutter/material.dart';

class YLiftDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          buildMenuSection('Trending', ['Featured Products', 'Promotions']),
          buildMenuSection('Popular Brands', ['Galderma', 'Benv', 'Galderma', 'See all']),
          buildMenuSection('Categories', ['Dermal Filler', 'Dermal Filler', 'Dermal Filler', 'See all']),
          buildMenuSection('You', ['Cart', 'Favorite', 'History', 'Login / Logout']),
          buildMenuSection('Settings', ['Report', 'Help']),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Have questions? Contact us at\n+1 (212) 861-7787\ninfo@ylift.com',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildMenuSection(String title, List<String> items) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      ...items.map((item) {
        return ListTile(
          title: Text(item),
          onTap: () {
          },
        );
      }).toList(),
      Divider(),
    ],
  );
}