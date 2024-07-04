import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../skelton.dart';

class SeconderyProductSkelton extends StatelessWidget {
  const SeconderyProductSkelton({
    super.key,
    this.isSmall = false,
    this.padding = const EdgeInsets.all(defaultPadding / 2),
  });

  final bool isSmall;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      height: 114,
      width: 256,
      child: Row(
        children: [
          const AspectRatio(
            aspectRatio: 1.15,
            child: Skeleton(),
          ),
          const SizedBox(width: defaultPadding / 2),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Skeleton(
                    height: 12,
                    width: 80,
                  ),
                  const Spacer(),
                  const Skeleton(),
                  if (!isSmall) const SizedBox(height: defaultPadding / 2),
                  if (!isSmall) const Skeleton(),
                  const Spacer(),
                  const Skeleton(
                    width: 40,
                    height: 12,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
