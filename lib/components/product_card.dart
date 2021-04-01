import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/screens/details/details_screen.dart';

import '../constants.dart';
import '../size_config.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key key,
    this.width = 140,
    this.aspectRatio = 1.02,
  }) : super(key: key);

  final double width, aspectRatio;

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
      child: SizedBox(
        width: getProportionateScreenWidth(width),
        child: GestureDetector(
          onTap: () => Navigator.pushNamed(
            context,
            DetailsScreen.routeName,
            arguments: product,
          ),
          child: Container(
            height: 230,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AspectRatio(
                  aspectRatio: 1.02,
                  child: Container(
                    padding: EdgeInsets.all(getProportionateScreenWidth(20)),
                    decoration: BoxDecoration(
                      color: kSecondaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Hero(
                      tag: product.id.toString(),
                      child: Image.asset(product.images[0]),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  product.title,
                  style: TextStyle(color: Colors.black),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$${product.price}",
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(18),
                        fontWeight: FontWeight.w600,
                        color: kPrimaryColor,
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () {
                        product.toggleFavoriteStatus();
                      },
                      child: Container(
                        padding: EdgeInsets.all(getProportionateScreenWidth(8)),
                        height: getProportionateScreenWidth(30),
                        width: getProportionateScreenWidth(30),
                        decoration: BoxDecoration(
                          color: product.isFavorite
                              ? kPrimaryColor.withOpacity(0.15)
                              : kSecondaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset(
                          "assets/icons/Heart Icon_2.svg",
                          color: product.isFavorite
                              ? Color(0xFFFF4848)
                              : Color(0xFFDBDEE4),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
