
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_order_management/views/pages/my_orders/my_orders.dart';

import 'my_orders_bloc/my_orders_bloc.dart';
import 'my_orders_resources.dart';

abstract class MyOrdersViewModel extends State<MyOrders> with MyOrdersResources {
  @override
  void initState() {
    context.read<MyOrdersBloc>().add(MyOrdersProcessStartEvent());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
