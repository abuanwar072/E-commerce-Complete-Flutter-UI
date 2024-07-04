import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../skelton.dart';

class BannerMWithCounterSkelton extends StatelessWidget {
  const BannerMWithCounterSkelton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.87,
      child: Stack(
        children: [
          const Skeleton(radious: 0),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Skeleton(
                width: 200,
                height: 24,
              ),
              const SizedBox(height: defaultPadding / 2),
              const Skeleton(
                width: 160,
                height: 24,
              ),
              const SizedBox(height: defaultPadding),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (_) => const Padding(
                    padding: EdgeInsets.only(right: defaultPadding / 2),
                    child: Skeleton(
                      height: 40,
                      width: 40,
                      radious: defaultPadding / 2,
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
