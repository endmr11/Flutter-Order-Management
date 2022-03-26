import 'package:flutter/material.dart';
import 'package:flutter_order_management/views/pages/my_orders/bloc/my_orders_bloc.dart';
import 'package:flutter_order_management/views/pages/my_orders/my_orders.dart';

import 'my_orders_resources.dart';

abstract class MyOrdersViewModel extends State<MyOrders> with MyOrdersResources {
  @override
  void initState() {
    super.initState();
    myOrdersBloc = MyOrdersBloc();
    myOrdersBloc?.add(MyOrdersProcessStartEvent());
  }

  @override
  void dispose() {
    super.dispose();
    myOrdersBloc?.close();
  }
}
