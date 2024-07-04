import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../skelton.dart';

class BannerLSkelton extends StatelessWidget {
  const BannerLSkelton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const AspectRatio(
      aspectRatio: 1.1,
      child: Stack(
        children: [
          Skeleton(),
          Padding(
            padding: EdgeInsets.all(defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacer(),
                Skeleton(
                  width: 160,
                  height: 24,
                ),
                SizedBox(height: defaultPadding / 2),
                Skeleton(
                  width: 200,
                  height: 24,
                ),
                Spacer(),
                Skeleton(width: 80)
              ],
            ),
          )
        ],
      ),
    );
  }
}
