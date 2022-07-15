import 'package:flutter/material.dart';

import 'my_orders_view.dart';

class MyOrders extends StatefulWidget {
  static const String routeName = '/my-orders'; 
  const MyOrders({Key? key}) : super(key: key);

  @override
  MyOrdersView createState() => MyOrdersView();
}
