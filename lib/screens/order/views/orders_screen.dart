import 'package:flutter/material.dart';
import 'package:shop/components/buy_full_ui_kit.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BuyFullKit(images: [
      "assets/screens/Orders.png",
      "assets/screens/Cancel order - Select a reason.png"
    ]);
  }
}
