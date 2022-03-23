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

AlertDialog cartViewAlertDialog(String? title, List<Widget>? content, String? totalPrice) {
  return AlertDialog(
    title: Text(title ?? ""),
    content: SingleChildScrollView(
      child: Column(
        children: [
          Column(
            children: content ?? [],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  "Toplam Fiyat:",
                ),
                Text(
                  "$totalPrice₺",
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

AlertDialog loadingAlertDialog() {
  return AlertDialog(
    title: const Text("Yükleniyor"),
    content: SingleChildScrollView(
      child: ListBody(
        children: const [
          Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        ],
      ),
    ),
    actions: const [],
  );
}
