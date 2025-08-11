import 'package:flutter/material.dart';
import 'package:YLift/core/constants/color.dart';

class ImageGalery extends StatelessWidget {
  final String? imageUrl;
  final bool? backButton;
  final BoxFit? fit;
  final VoidCallback? onBack;
  final VoidCallback? onShare;

  //final Icon? iconButton;

  const ImageGalery({
    super.key,
    required this.imageUrl,
    this.backButton = false,
    this.fit,
    this.onBack,
    this.onShare,
    //this.iconButton,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(imageUrl!,),
              fit: fit,
              onError: (error, stackTrace) => Image.asset('msc/images/Placeholder_Product.png'),
            )
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FloatingActionButton.small(
                    backgroundColor: Colors.grey,
                    onPressed: onBack,
                    child: const Icon(Icons.arrow_back, color: Colors.white)
                ),
                FloatingActionButton.small(
                    backgroundColor: YLiftColor.orange,
                    onPressed: onShare,
                    child: const Icon(Icons.share, color: Colors.white)
                ),
                // IconButton(onPressed: onBack, icon: Icon(Icons.arrow_back)),
                // IconButton(onPressed: onBack, icon: Icon(Icons.share))
              ]
          ),
        )
    );
  }
}
