import 'package:flutter/material.dart';
import 'package:flutter_order_management/data/sources/database/local_database_helper.dart';
import 'package:flutter_order_management/views/pages/home/home.dart';
import 'package:flutter_order_management/views/pages/order_management/order_management.dart';

class PageManagement extends StatelessWidget {
  const PageManagement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (LocaleDatabaseHelper.i.currentUserType == 0) {
      return const Home();
    } else {
      return const OrderManagement();
    }
  }
}
