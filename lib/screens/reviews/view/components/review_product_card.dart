import 'package:flutter/material.dart';
import 'package:shop/components/network_image_with_loader.dart';

import '../../../../constants.dart';

class ReviewProductInfoCard extends StatelessWidget {
  const ReviewProductInfoCard({
    super.key,
    required this.image,
    required this.title,
    required this.brand,
  });
  final String image, title, brand;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 80,
          width: 80,
          child: NetworkImageWithLoader(image),
        ),
        const SizedBox(width: defaultPadding),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                brand.toUpperCase(),
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: defaultPadding / 2),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
