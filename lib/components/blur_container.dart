import 'dart:ui';

import 'package:flutter/material.dart';

import '../constants.dart';

class BlurContainer extends StatelessWidget {
  const BlurContainer({
    super.key,
    required this.text,
    this.height = 40,
    this.width = 40,
    this.fontSize = 18,
  });

  final String text;
  final double height, width, fontSize;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(
        Radius.circular(defaultBorderRadious / 2),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          height: height,
          width: height,
          color: Colors.white12,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
