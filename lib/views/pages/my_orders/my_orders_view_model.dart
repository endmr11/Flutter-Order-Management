import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_order_management/core/services/socket/socket_config.dart';
import 'package:flutter_order_management/data/models/order_models/order_model.dart';
import 'package:flutter_order_management/data/sources/database/local_database_helper.dart';
import 'package:flutter_order_management/views/pages/my_orders/bloc/my_orders_bloc.dart';
import 'package:flutter_order_management/views/pages/my_orders/my_orders.dart';

import 'my_orders_resources.dart';

abstract class MyOrdersViewModel extends State<MyOrders> with MyOrdersResources {
  @override
  void initState() {
    super.initState();
    myOrdersBloc = MyOrdersBloc();
    myOrdersBloc?.add(MyOrdersProcessStartEvent());
    socket = SocketConfig.socket;
    socket?.on('updateOrderResponse', (val) {
      Map<String, dynamic> jsonVal = val;
      OrderModel model = OrderModel.fromJson(jsonVal);
      log('Result => $model', name: "updateOrderResponse");
      if (model.userId == LocaleDatabaseHelper.i.currentUserId) {
        var index = allOrders.indexWhere((element) => element.orderId == model.orderId);
        setState(() {
          allOrders[index] = model;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    myOrdersBloc?.close();
  }
}
