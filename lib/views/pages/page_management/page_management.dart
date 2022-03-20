import 'package:flutter/material.dart';
import 'package:flutter_order_management/data/sources/database/local_database_helper.dart';
import 'package:flutter_order_management/views/components/buttons/classic_button.dart';
import 'package:flutter_order_management/views/pages/home/home.dart';
import 'package:flutter_order_management/views/pages/login/login.dart';

class PageManagement extends StatelessWidget {
  const PageManagement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (LocaleDatabaseHelper.i.currentUserType == 0) {
      return const Home();
    } else {
      return const Test();
    }
  }
}

class Test extends StatelessWidget {
  const Test({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: classicButton(
        text: "Çık",
        customOnPressed: () async {
          await LocaleDatabaseHelper.i.userSessionClear();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const Login(),
            ),
          );
        },
      ),
    );
  }
}
