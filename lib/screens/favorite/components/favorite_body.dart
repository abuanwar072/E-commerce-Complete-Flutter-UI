import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/screens/favorite/components/favorite_card.dart';

import '../../../size_config.dart';

class FavoriteBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final favoriteProducts = productsData.favoritesProducts;
    return favoriteProducts.isNotEmpty
        ? Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: ListView.builder(
              itemCount: favoriteProducts.length,
              itemBuilder: (context, index) => ChangeNotifierProvider.value(
                value: favoriteProducts[index],
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: FavoriteCard(),
                ),
              ),
            ),
          )
        : Center(
            child: Text(
              'Let\'s Add Some Favorites...',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          );
  }
}
