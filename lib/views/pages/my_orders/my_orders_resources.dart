import 'package:flutter_order_management/data/models/order_models/order_model.dart';
import 'package:flutter_order_management/data/models/product_models/product_model.dart';
import 'package:flutter_order_management/views/pages/my_orders/bloc/my_orders_bloc.dart';

mixin MyOrdersResources {
  MyOrdersBloc? myOrdersBloc;
  bool isLoading = false;
    List<OrderModel> allOrders = [];
  List<ProductModel> allProducts = [];
}
