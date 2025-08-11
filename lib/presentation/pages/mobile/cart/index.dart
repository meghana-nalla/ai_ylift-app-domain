import 'package:YLift/presentation/pages/mobile/cart/mobile_cart_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import 'package:YLift/presentation/pages/mobile/cart/shopping.dart';
import 'package:YLift/core/controllers/global.dart';

import 'checkout.dart';



class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final GlobalController controller = Get.find<GlobalController>();
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    final Uri videoUrl = Uri.parse("https://ylift.app/api/v2/mars/file/public/media/empty_cart.mp4");
    _videoController = VideoPlayerController.networkUrl(videoUrl)
      ..initialize().then((_) {
        setState(() {
          _videoController.setLooping(true);
          _videoController.play();
        });
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  bool checkout = false;
  void setCheckout(bool value) {
    controller.vroute.navigateTo('/checkout');
    // setState(() {
    //   checkout = value;
    // });
  }

  @override
  Widget build(BuildContext context) {
    if (controller.isAuthenticated.isFalse) {
      return _buildNotLoggedIn(context);
    } else {
      if (checkout) {
        return CheckOutOrderSummary(); // widget that displays checkout info
      } else {
        return const MobileCartPage();
        return ShoppingReviewCartScreen(onCheckout: () => setCheckout(true));
      }
    }
  }

  Widget _buildNotLoggedIn(BuildContext context) {
    return Stack(
      children: [
        SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _videoController.value.size.width,
              height: _videoController.value.size.height,
              child: VideoPlayer(_videoController),
            ),
          ),
        ),
        Positioned(
          bottom: 25, // This places the button 25 units from the bottom
          left: 0,
          right: 0,
          child: Center(
            child: ElevatedButton(
              // onPressed: () => controller.auth0
              //     .loginWithRedirect(redirectUrl: CURRENT_REDIRECT_URI),
              // TODO: Change to new login endpoint
              onPressed: (){
                controller.vroute.navigateTo('/login');
              },
              child: Text('Sign In / Sign Up Now'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(150, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
