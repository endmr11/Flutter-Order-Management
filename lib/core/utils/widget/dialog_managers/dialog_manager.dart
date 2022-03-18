import 'package:flutter/material.dart';

class DialogManager {
  DialogManager._();
  static final DialogManager _instance = DialogManager._();
  static DialogManager get i => _instance;

  void showSnacBar({required BuildContext context, required String? text}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text ?? "")),
    );
  }

  Future<void> showClassicAlertDialog({required BuildContext context, required AlertDialog alertDialog}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  }
}
