import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget classicTextFormField({
  required BuildContext context,
  required TextEditingController? controllerText,
  required String? dataText,
  Widget?  prefixIcon,
  Widget?  suffixIcon,
  bool? obscureText,
}) {
  return TextFormField(
    validator: (value) {
      if (value == null || value.isEmpty) {
        return AppLocalizations.of(context)!.formWarning;
      }
      return null;
    },
    controller: controllerText,
    obscureText: obscureText ?? false,
    decoration: InputDecoration(
      prefixIcon: prefixIcon,
      enabled: true,
      labelText: dataText,
      suffixIcon: suffixIcon,
    ),
  );
}
