import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../constants.dart';

class PreferencesListTile extends StatelessWidget {
  const PreferencesListTile({
    super.key,
    required this.titleText,
    required this.subtitleTxt,
    required this.isActive,
    required this.press,
  });

  final String titleText, subtitleTxt;
  final bool isActive;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      title: Text(
        titleText,
        style: Theme.of(context).textTheme.titleSmall,
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: defaultPadding / 2),
        child: Text(
          subtitleTxt,
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: Theme.of(context).textTheme.bodyMedium!.color),
        ),
      ),
      trailing: CupertinoSwitch(
        onChanged: (value) {
          press;
        },
        activeColor: primaryColor,
        value: isActive,
      ),
    );
  }
}
