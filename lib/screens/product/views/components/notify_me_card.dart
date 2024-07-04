import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../constants.dart';

class NotifyMeCard extends StatelessWidget {
  const NotifyMeCard({
    super.key,
    this.isNotify = false,
    required this.onChanged,
  });

  final bool isNotify;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding, vertical: defaultPadding / 2),
        child: Container(
          decoration: BoxDecoration(
            color: isNotify ? primaryColor : Colors.transparent,
            borderRadius: const BorderRadius.all(
              Radius.circular(defaultBorderRadious),
            ),
            border: Border.all(
              color: isNotify
                  ? Colors.transparent
                  : Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .color!
                      .withOpacity(0.1),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Row(
              children: [
                SizedBox(
                  height: 40,
                  width: 40,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: EdgeInsets.zero,
                      side: const BorderSide(color: Colors.white10),
                    ),
                    child: SvgPicture.asset(
                      "assets/icons/Notification.svg",
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: defaultPadding),
                Expanded(
                  child: Text(
                    "Notify when product back to stock.",
                    style: TextStyle(
                        color: isNotify
                            ? Colors.white
                            : Theme.of(context).textTheme.bodyLarge!.color,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                CupertinoSwitch(
                  onChanged: onChanged,
                  value: isNotify,
                  activeColor: primaryMaterialColor.shade900,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
