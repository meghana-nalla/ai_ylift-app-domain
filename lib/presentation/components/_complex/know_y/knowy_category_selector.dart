import 'package:flutter/material.dart';

class KnowYCategorySelector extends StatefulWidget {
  @override
  _KnowYCategorySelectorState createState() => _KnowYCategorySelectorState();
}

class _KnowYCategorySelectorState extends State<KnowYCategorySelector> {
  // List of categories
  final List<String> categories = [
    'All Topics',
    'Aesthetic Medicine',
    'Aesthetic Surgery',
  ];

  // Variable to store the currently selected category
  String selectedCategory = 'All Topics'; // Default to the first category

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 50, // Set height to fit the buttons
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              String category = categories[index];
              bool isSelected = category == selectedCategory;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCategory = category; // Update the selected category
                  });
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Chip(
                    label: Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                    backgroundColor: isSelected ? Colors.black : Colors.grey[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 20),
        // Display the currently selected category
        Text(
          'Selected Category: $selectedCategory',
          style: TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}