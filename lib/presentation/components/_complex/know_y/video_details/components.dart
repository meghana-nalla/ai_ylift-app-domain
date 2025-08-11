import 'package:flutter/material.dart';

/// Display the header video widget
class KnowYDetailVideoDisplayWidget extends StatelessWidget {
  const KnowYDetailVideoDisplayWidget ({
    super.key,
    // TODO: require videoUrl
    this.videoUrl,
  });

  // TODO: require videoUrl
  final String? videoUrl;

  @override
  Widget build(BuildContext context) {

    // TODO: implement video handler & remove dummy widget
    // dummy container
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(60.0),
        color: Colors.grey,
      ),
      child: const Center(
        child: Text(
          'Detail Video Display',
        ),
      ),
    );
  }
}


/// title and price view
// TODO: Make stateful to display price authentication logic(?)
class KnowYDetailTitlePriceWidget extends StatelessWidget {
  const KnowYDetailTitlePriceWidget({
    super.key,
    required this.productName,
    required this.price,
  });

  final String productName;
  final double price;

  // format the price for the display
  String formatPrice() {
    String priceFormatted = price.toStringAsFixed(2);
    return '\$$priceFormatted';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              productName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              formatPrice(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}




/// description view
class KnowYDetailCourseDescriptionWidget extends StatelessWidget {
  const KnowYDetailCourseDescriptionWidget({
    super.key,
    required this.numChapters,
    required this.numQuizzes,
    required this.description,
  });

  final int numChapters;
  final int numQuizzes;
  final String description;

  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // chapters and quizzes
        Text (
          '${numChapters.toString()} chapters • ${numQuizzes.toString()} quizzes',
          style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
        ),

        const SizedBox(height: 8,),

        // description
        // TODO: make collapsable
        Text (
          description,
          style: const TextStyle(color: Colors.black)
        ),
      ],
    );
  }
}


/// purchase now button
class KnowYDetailPurchaseButton extends StatelessWidget {
  const KnowYDetailPurchaseButton({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        // TODO: implement purchase logic
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          padding:
          const EdgeInsets.symmetric(vertical: 14.0, horizontal: 40.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
        ),
        child: const Text(
          'Purchase Now',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

