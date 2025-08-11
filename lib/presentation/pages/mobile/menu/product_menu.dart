import 'package:YLift/core/constants/color.dart';
import 'package:flutter/material.dart';

class ProductMenu extends StatelessWidget {
  final Color? backgroundColor;
  final bool? buyNow;
  final Widget child;
  final Widget replaceChild;
  final VoidCallback? onAddToCart;
  final VoidCallback? onBuy;
  final bool? isAuthenticated;
  final VoidCallback? onLogin;

  const ProductMenu({
    super.key,
    this.backgroundColor = Colors.white,
    this.buyNow = false,
    required this.child,
    required this.replaceChild,
    this.onAddToCart,
    this.onBuy,
    this.isAuthenticated,
    this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        color: backgroundColor,
        notchMargin: 5.0,
        clipBehavior: Clip.antiAlias,
        child: Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                if (isAuthenticated == true) ...[
                  if (buyNow! == false) ...[
                    child,
                  ],
                  Spacer(),
                  FilledButton(
                    onPressed: onAddToCart,
                    style: FilledButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      backgroundColor: YLiftColor.yellow,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8))),
                    ),

                    child: Text('Add to Cart',
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.white
                        )
                    ),
                  ),
                  FilledButton(
                      onPressed: onAddToCart,
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        backgroundColor: YLiftColor.orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(8),
                                bottomRight: Radius.circular(8))),
                      ),
                      child: Text('Buy Now', style: TextStyle(
                          fontSize: 13,
                          color: Colors.white
                      ),)
                  )
                ] else
                  ...[
                    replaceChild,
                    Spacer(),
                    FilledButton(
                        onPressed: onLogin,
                        style: FilledButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8))),
                        ),
                        child: Text('Login for Pricing', style: TextStyle(
                            fontSize: 13,
                            color: Colors.white
                        ),
                        )
                    )
                  ],
              ],
            )
        )
    );
  }
}
