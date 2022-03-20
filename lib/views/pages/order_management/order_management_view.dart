import 'package:flutter/material.dart';
import 'package:flutter_order_management/data/sources/database/local_database_helper.dart';
import 'package:flutter_order_management/views/components/buttons/classic_button.dart';
import 'package:flutter_order_management/views/pages/login/login.dart';

import 'order_management_view_model.dart';

class OrderManagementView extends OrderManagementViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: classicButton(
        text: "Çıkk",
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
