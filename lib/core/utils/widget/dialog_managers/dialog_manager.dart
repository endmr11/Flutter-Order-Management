import 'package:flutter/material.dart';
import 'package:flutter_order_management/views/components/alert_dialogs/classic_alert_dialog.dart';

class DialogManager {
  DialogManager._();
  static final DialogManager _instance = DialogManager._();
  static DialogManager get i => _instance;

  void showSnacBar({required BuildContext context, required String? text}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text ?? "")),
    );
  }

  Future<void> showClassicAlertDialog({
    required BuildContext context,
    required String? title,
    required List<Widget>? content,
    required List<Widget>? actions,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return classicAlertDialog(
          title: title,
          content: content ?? [const Text("Hatalı Bilgi Girdiniz!")],
          actions: actions ?? [],
        );
      },
    );
  }

  Future<void> showLoadingAlertDialog({
    required BuildContext context,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return loadingAlertDialog();
      },
    );
  }
}
