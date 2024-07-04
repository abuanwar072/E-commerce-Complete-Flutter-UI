import 'package:flutter/material.dart';
import 'package:shop/components/buy_full_ui_kit.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BuyFullKit(
      images: [
        "assets/screens/Cart_1.png",
        "assets/screens/Cart_2.png",
        "assets/screens/Cart_3.png",
        "assets/screens/Cart_4.png",
        "assets/screens/Cart_5.png",
        "assets/screens/Cart_6.png",
      ],
    );
  }
}
