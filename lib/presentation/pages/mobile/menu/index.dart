import 'package:flutter/material.dart';

// TODO: implement the MenuScreen widget
class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                'https://ylift.app/api/v2/mars/file/public/media/logo_white_circle.png',
                width: 100,
              ),
              Text(
                'Y L I F T STORE',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.brown,
          ),
        ),
        buildMenuSection('Trending', ['Featured Products', 'Promotions']),
        buildMenuSection(
            'Popular Brands', ['Galderma', 'Benv', 'Galderma', 'See all']),
        buildMenuSection('Categories',
            ['Dermal Filler', 'Dermal Filler', 'Dermal Filler', 'See all']),
        buildMenuSection(
            'You', ['Cart', 'Favorite', 'History', 'Login / Logout']),
        buildMenuSection('Settings', ['Report', 'Help']),
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Have questions? Contact us at\n+1 (212) 861-7787\ninfo@ylift.com',
            style: TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
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
              // TODO: logic for the menu item tap
            },
          );
        }).toList(),
        Divider(),
      ],
    );
  }
}
