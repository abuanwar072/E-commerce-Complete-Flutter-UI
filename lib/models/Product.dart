import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  final int id;
  final String title, description;
  final List<String> images;
  final List<Color> colors;
  final double rating, price;
  bool isFavorite, isPopular;

  Product({
    @required this.id,
    @required this.images,
    @required this.colors,
    @required this.title,
    @required this.price,
    @required this.description,
    this.rating = 0.0,
    this.isFavorite = false,
    this.isPopular = false,
  });
  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}

// Our demo Products

class Products with ChangeNotifier {
  List<Product> _demoProducts = [
    Product(
      id: 1,
      images: [
        "assets/images/ps4_console_white_1.png",
        "assets/images/ps4_console_white_2.png",
        "assets/images/ps4_console_white_3.png",
        "assets/images/ps4_console_white_4.png",
      ],
      colors: [
        Color(0xFFF6625E),
        Color(0xFF836DB8),
        Color(0xFFDECB9C),
        Colors.white,
      ],
      title: "Wireless Controller for PS4™",
      price: 64.99,
      description: description,
      rating: 4.8,
      isFavorite: true,
      isPopular: true,
    ),
    Product(
      id: 2,
      images: [
        "assets/images/Image Popular Product 2.png",
      ],
      colors: [
        Color(0xFFF6625E),
        Color(0xFF836DB8),
        Color(0xFFDECB9C),
        Colors.white,
      ],
      title: "Nike Sport White - Man Pant",
      price: 50.5,
      description: description,
      rating: 4.1,
      isPopular: true,
    ),
    Product(
      id: 3,
      images: [
        "assets/images/glap.png",
      ],
      colors: [
        Color(0xFFF6625E),
        Color(0xFF836DB8),
        Color(0xFFDECB9C),
        Colors.white,
      ],
      title: "Gloves XC Omega - Polygon",
      price: 36.55,
      description: description,
      rating: 4.1,
      isFavorite: true,
      isPopular: true,
    ),
    Product(
      id: 4,
      images: [
        "assets/images/wireless headset.png",
      ],
      colors: [
        Color(0xFFF6625E),
        Color(0xFF836DB8),
        Color(0xFFDECB9C),
        Colors.white,
      ],
      title: "Logitech Head",
      price: 20.20,
      description: description,
      rating: 4.1,
      isFavorite: true,
      isPopular: true,
    ),
    Product(
      id: 5,
      images: [
        "assets/images/bagpack.png",
      ],
      colors: [
        Color(0xFFF6625E),
        Color(0xFF836DB8),
        Color(0xFFDECB9C),
        Colors.white,
      ],
      title: "Bagpack",
      price: 25.90,
      description: description,
      rating: 4.4,
      isFavorite: true,
      isPopular: true,
    ),
    Product(
      id: 6,
      images: [
        "assets/images/violin.png",
      ],
      colors: [
        Color(0xFFF6625E),
        Color(0xFF836DB8),
        Color(0xFFDECB9C),
        Colors.white,
      ],
      title: "Violin",
      price: 49.99,
      description: description,
      rating: 4.7,
      isFavorite: false,
      isPopular: true,
    ),
    Product(
      id: 7,
      images: [
        "assets/images/cooking_pan.png",
      ],
      colors: [
        Color(0xFFF6625E),
        Color(0xFF836DB8),
        Color(0xFFDECB9C),
        Colors.white,
      ],
      title: "cooking pan",
      price: 44.99,
      description: description,
      rating: 4.3,
      isFavorite: true,
      isPopular: true,
    ),
    Product(
      id: 8,
      images: [
        "assets/images/headphones.png",
      ],
      colors: [
        Color(0xFFF6625E),
        Color(0xFF836DB8),
        Color(0xFFDECB9C),
        Colors.white,
      ],
      title: "Headphone",
      price: 30.99,
      description: description,
      rating: 4.2,
      isFavorite: false,
      isPopular: true,
    ),
    Product(
      id: 9,
      images: [
        "assets/images/kettle.png",
      ],
      colors: [
        Color(0xFFF6625E),
        Color(0xFF836DB8),
        Color(0xFFDECB9C),
        Colors.white,
      ],
      title: "Kettle",
      price: 19.99,
      description: description,
      rating: 4.0,
      isFavorite: true,
      isPopular: true,
    ),
  ];

  List<Product> get allProducts {
    return [..._demoProducts];
  }

  List<Product> get favoritesProducts {
    return _demoProducts.where((product) => product.isFavorite).toList();
  }

  void removeFromFavorites() {
    notifyListeners();
  }
}

const String description =
    "Wireless Controller for PS4™ gives you what you want in your gaming from over precision control your games to sharing …";
