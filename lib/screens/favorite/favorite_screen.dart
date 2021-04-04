import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/coustom_bottom_nav_bar.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/screens/favorite/components/favorite_body.dart';

import '../../enums.dart';

class FavoriteScreen extends StatelessWidget {
  static const String routeName = "/favorite";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: FavoriteBody(),
      bottomNavigationBar:
          CustomBottomNavBar(selectedMenu: MenuState.favourite),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    final favoritesProducts = Provider.of<Products>(context).favoritesProducts;
    return AppBar(
      title: Column(
        children: [
          Text(
            "Your Favorites",
            style: TextStyle(color: Colors.black),
          ),
          Text(
            "${favoritesProducts.length} items",
            style: Theme.of(context).textTheme.caption.copyWith(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
