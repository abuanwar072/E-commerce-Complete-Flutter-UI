import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../product/secondary_product_skelton.dart';
import '../skelton.dart';

class OrderStatusCardSkelton extends StatelessWidget {
  const OrderStatusCardSkelton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Skeleton(height: 12, width: 100),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
          child: Skeleton(width: 160),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            4,
            (index) => const CircleSkeleton(size: 28),
          ),
        ),
        const SizedBox(height: defaultPadding * 0.75),
        const SizedBox(
          height: 86,
          width: double.infinity,
          child: SeconderyProductSkelton(
            isSmall: true,
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}
