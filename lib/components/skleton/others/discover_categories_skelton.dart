import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../skelton.dart';

class DiscoverCategoriesSkelton extends StatelessWidget {
  const DiscoverCategoriesSkelton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) => const DiscoverCategorySkelton(),
    );
  }
}

class DiscoverCategorySkelton extends StatelessWidget {
  const DiscoverCategorySkelton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
          horizontal: defaultPadding, vertical: defaultPadding * 0.75),
      child: Row(
        children: [
          Skeleton(
            height: 32,
            width: 32,
            radious: 8,
          ),
          SizedBox(width: defaultPadding),
          Expanded(
            flex: 2,
            child: Skeleton(),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
