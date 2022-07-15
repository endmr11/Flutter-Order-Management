import 'package:flutter/material.dart';

class ClassicAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(50);
  const ClassicAppBar({Key? key, required this.title, required this.centerTitle}) : super(key: key);

  final String? title;
  final bool? centerTitle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title ?? ""),
      centerTitle: centerTitle,
    );
  }
}

class CustomActionAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(50);
  const CustomActionAppBar({Key? key, required this.title, required this.centerTitle, required this.actions}) : super(key: key);

  final String? title;
  final bool? centerTitle;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title ?? ""),
      centerTitle: centerTitle,
      actions: actions,
    );
  }
}
