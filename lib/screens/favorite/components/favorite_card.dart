import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/Product.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class FavoriteCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final favoriteProduct = Provider.of<Product>(context);
    return Row(
      children: [
        SizedBox(
          width: 88,
          child: AspectRatio(
            aspectRatio: 0.88,
            child: Container(
              padding: EdgeInsets.all(getProportionateScreenWidth(10)),
              decoration: BoxDecoration(
                color: Color(0xFFF5F6F9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.asset(favoriteProduct.images[0]),
            ),
          ),
        ),
        SizedBox(
          width: 25,
        ),
        Container(
          width: getProportionateScreenWidth(156),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                favoriteProduct.title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
                maxLines: 2,
              ),
              SizedBox(height: 10),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$${favoriteProduct.price}",
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(18),
                        fontWeight: FontWeight.w600,
                        color: kPrimaryColor,
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () {
                        favoriteProduct.toggleFavoriteStatus();
                        productsData.removeFromFavorites();
                      },
                      child: Container(
                        padding: EdgeInsets.all(getProportionateScreenWidth(8)),
                        height: getProportionateScreenWidth(30),
                        width: getProportionateScreenWidth(30),
                        decoration: BoxDecoration(
                          color: kPrimaryColor.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset(
                          "assets/icons/Heart Icon_2.svg",
                          color: Color(0xFFFF4848),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
