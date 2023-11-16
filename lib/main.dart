import 'package:flutter/material.dart';
import 'package:shop_app/screens/init_screen.dart';

import 'routes.dart';
import 'theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Flutter Way - Template',
      theme: AppTheme.lightTheme(context),
      // initialRoute: SplashScreen.routeName,
      initialRoute: InitScreen.routeName,
      routes: routes,
    );
  }
}
