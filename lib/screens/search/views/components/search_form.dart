import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop/theme/input_decoration_theme.dart';

class SearchForm extends StatelessWidget {
  const SearchForm({
    super.key,
    this.formKey,
    this.isEnabled = true,
    this.onSaved,
    this.validator,
    this.onChanged,
    this.onTabFilter,
    this.onFieldSubmitted,
    this.focusNode,
    this.autofocus = false,
  });

  final GlobalKey<FormState>? formKey;
  final bool isEnabled;
  final ValueChanged<String?>? onSaved, onChanged, onFieldSubmitted;
  final FormFieldValidator<String>? validator;
  final VoidCallback? onTabFilter;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: TextFormField(
        autofocus: autofocus,
        focusNode: focusNode,
        enabled: isEnabled,
        onChanged: onChanged,
        onSaved: onSaved,
        onFieldSubmitted: onFieldSubmitted,
        validator: validator,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: "Find something...",
          filled: false,
          border: secodaryOutlineInputBorder(context),
          enabledBorder: secodaryOutlineInputBorder(context),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SvgPicture.asset(
              "assets/icons/Search.svg",
              height: 24,
              color: Theme.of(context).iconTheme.color!.withOpacity(0.3),
            ),
          ),
          suffixIcon: SizedBox(
            width: 40,
            child: Row(
              children: [
                const SizedBox(
                  height: 24,
                  child: VerticalDivider(width: 1),
                ),
                Expanded(
                  child: IconButton(
                    onPressed: onTabFilter,
                    icon: SvgPicture.asset(
                      "assets/icons/Filter.svg",
                      height: 24,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
