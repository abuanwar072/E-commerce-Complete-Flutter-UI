import 'package:flutter/material.dart';

import '../constants.dart';

class OutlinedActiveButton extends StatelessWidget {
  const OutlinedActiveButton({
    super.key,
    required this.text,
    required this.press,
    this.isActive = false,
  });

  final String text;
  final VoidCallback press;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: press,
      style: isActive
          ? OutlinedButton.styleFrom(
              backgroundColor: primaryColor, foregroundColor: Colors.white)
          : null,
      child: Text(text),
    );
  }
}
