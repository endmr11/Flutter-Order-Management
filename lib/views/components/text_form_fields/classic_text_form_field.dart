import 'package:flutter/material.dart';

Widget classicTextFormField({required TextEditingController? controllerText, required String? dataText}) {
  return TextFormField(
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter some text';
      }
      return null;
    },
    controller: controllerText,
    decoration: InputDecoration(
      border: const OutlineInputBorder(),
      hintText: dataText,
    ),
  );
}
