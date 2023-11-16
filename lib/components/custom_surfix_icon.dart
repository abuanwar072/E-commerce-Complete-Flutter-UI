import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSurffixIcon extends StatelessWidget {
  const CustomSurffixIcon({
    Key? key,
    required this.svgIcon,
  }) : super(key: key);

  final String svgIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SvgPicture.asset(
        svgIcon,
        height: 16,
        width: 16,
      ),
    );
  }
}
