import 'package:flutter/material.dart';

import '../../constants.dart';

class CheckboxUnderlineListTile extends StatelessWidget {
  const CheckboxUnderlineListTile({
    super.key,
    required this.onChanged,
    required this.value,
    required this.title,
    this.numOfItems,
    this.trailing,
  });

  final ValueChanged<bool?>? onChanged;
  final bool value;
  final String title;
  final int? numOfItems;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CheckboxListTile(
          activeColor: primaryColor,
          onChanged: onChanged,
          value: value,
          title: Text.rich(
            TextSpan(
              text: title,
              children: [
                if (numOfItems != null)
                  WidgetSpan(
                    child: Text(
                      "  ($numOfItems)",
                      style: TextStyle(
                        color: value
                            ? Theme.of(context).textTheme.bodyLarge!.color
                            : Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          secondary: trailing != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding / 2),
                  child: trailing,
                )
              : null,
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
        ),
        const Divider(height: 1),
      ],
    );
  }
}
