import 'package:flutter/material.dart';
import 'package:shop/components/buy_full_ui_kit.dart';

class ProductReviewsScreen extends StatelessWidget {
  const ProductReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BuyFullKit(images: [
      "assets/screens/reviews.png",
      "assets/screens/Add review rate.png"
    ]);
  }
}
