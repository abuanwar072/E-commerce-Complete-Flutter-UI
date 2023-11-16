import 'package:flutter/material.dart';
import 'package:shop_app/screens/home/home_screen.dart';

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  static String routeName = "/";

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeScreen(),
    );
  }
}
