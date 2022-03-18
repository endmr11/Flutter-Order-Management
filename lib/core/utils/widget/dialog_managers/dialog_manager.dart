import 'package:flutter/material.dart';

class DialogManager {
  DialogManager._();
  static final DialogManager _instance = DialogManager._();
  static DialogManager get i => _instance;

  void showSnacBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }
}
