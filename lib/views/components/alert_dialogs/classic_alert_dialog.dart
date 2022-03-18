import 'package:flutter/material.dart';

AlertDialog classicAlertDialog({required String? title, required List<Widget>? content, required List<Widget> actions}) {
  return AlertDialog(
    title: Text(title ?? ""),
    content: SingleChildScrollView(
      child: ListBody(
        children: content ?? [],
      ),
    ),
    actions: actions,
  );
}
