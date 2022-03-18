import 'package:flutter/material.dart';

/* Widget classicAppBar({required String? title, required bool? centerTitle})  {
  return AppBar(
    title: Text(title ?? ""),
    centerTitle: centerTitle,
  );
}

Widget customActionsAppBar({required String? title, required bool? centerTitle, required List<Widget>? actions}) {
  return AppBar(
    title: Text(title ?? ""),
    centerTitle: centerTitle,
    actions: actions,
  );
}
 */

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
