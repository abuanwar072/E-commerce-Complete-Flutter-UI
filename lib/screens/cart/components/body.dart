import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/Cart.dart';

import '../../../size_config.dart';
import 'cart_card.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final cartItems = cart.items.values.toList();
    final itemsKeys = cart.items.keys.toList();
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Dismissible(
            key: Key(cartItems[index].id.toString()),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              cart.removeItem(itemsKeys[index]);
            },
            background: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Color(0xFFFFE6E6),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Spacer(),
                  SvgPicture.asset("assets/icons/Trash.svg"),
                ],
              ),
            ),
            child: CartCard(
              id: cartItems[index].id,
              title: cartItems[index].title,
              price: cartItems[index].price,
              images: cartItems[index].images,
              quantity: cartItems[index].quantity,
            ),
          ),
        ),
      ),
    );
  }
}
