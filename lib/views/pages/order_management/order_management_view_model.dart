import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_order_management/core/services/socket/socket_config.dart';
import 'package:flutter_order_management/data/models/order_models/order_model.dart';
import 'package:flutter_order_management/views/pages/order_management/bloc/order_management_bloc.dart';
import 'package:flutter_order_management/views/pages/order_management/order_management.dart';
import 'package:flutter_order_management/views/pages/order_management/order_management_resources.dart';

abstract class OrderManagementViewModel extends State<OrderManagement> with OrderManagementResources {
  @override
  void initState() {
    orderManagementBloc = OrderManagementBloc();
    orderManagementBloc?.add(OrderManagementProcessStartEvent());
    socket = SocketConfig.socket;
    socket?.on('createOrderResponse', (val) {
      Map<String, dynamic> jsonVal = val;
      OrderModel model = OrderModel.fromJson(jsonVal);
      log('Result => $model', name: "createOrderResponse");
      setState(() {
        allOrders.insert(0, model);
      });
    });
    socket?.on('updateOrderResponse', (val) {
      Map<String, dynamic> jsonVal = val;
      OrderModel model = OrderModel.fromJson(jsonVal);
      log('Result => $model', name: "updateOrderResponse");
      var index = allOrders.indexWhere((element) => element.orderId == model.orderId);
      setState(() {
        allOrders[index] = model;
      });
    });
    socket?.on('deleteOrderResponse', (val) => log('Result => $val', name: "deleteOrderResponse"));
    super.initState();
  }

  @override
  void dispose() {
    orderManagementBloc?.close();
    super.dispose();
  }
}
