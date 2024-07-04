import 'package:flutter/material.dart';

import '../constants.dart';

Future<dynamic> customModalBottomSheet(
  BuildContext context, {
  bool isDismissible = true,
  double? height,
  required Widget child,
}) {
  return showModalBottomSheet(
    context: context,
    clipBehavior: Clip.hardEdge,
    isScrollControlled: true,
    isDismissible: isDismissible,
    enableDrag: isDismissible,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(defaultBorderRadious * 2),
        topRight: Radius.circular(defaultBorderRadious * 2),
      ),
    ),
    builder: (context) => SizedBox(
      height: height ?? MediaQuery.of(context).size.height * 0.75,
      child: child,
    ),
  );
}
