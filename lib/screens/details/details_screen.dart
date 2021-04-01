import 'package:flutter/material.dart';

import '../../models/Product.dart';
import 'components/body.dart';
import 'components/custom_app_bar.dart';

class DetailsScreen extends StatelessWidget {
  static String routeName = "/details";

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context).settings.arguments as Product;
    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      appBar: CustomAppBar(rating: product.rating),
      body: Body(product: product),
    );
  }
}
