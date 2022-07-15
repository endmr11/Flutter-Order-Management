import 'package:flutter/material.dart';

Widget classicButton({required String text, required void Function()? customOnPressed}) {
  return ElevatedButton(
    onPressed: customOnPressed,
    child: Text(text),
  );
}
