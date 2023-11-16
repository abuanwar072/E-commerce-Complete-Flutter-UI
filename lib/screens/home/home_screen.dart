import 'package:flutter/material.dart';
import '../../components/coustom_bottom_nav_bar.dart';
import '../../enums.dart';

import 'components/body.dart';
import 'components/categories.dart';
import 'components/discount_banner.dart';
import 'components/home_header.dart';
import 'components/popular_product.dart';
import 'components/special_offers.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";

  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // SizedBox(height: getProportionateScreenHeight(20)),
              const HomeHeader(),
              // SizedBox(height: getProportionateScreenWidth(10)),
              // const DiscountBanner(),
              // const Categories(),
              // const SpecialOffers(),
              // SizedBox(height: getProportionateScreenWidth(30)),
              // const PopularProducts(),
              // SizedBox(height: getProportionateScreenWidth(30)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
