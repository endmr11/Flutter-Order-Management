import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_order_management/data/models/base_models/base_response_model.dart';
import 'package:flutter_order_management/data/models/order_models/order_model.dart';
import 'package:flutter_order_management/data/models/product_models/product_model.dart';
import 'package:flutter_order_management/data/sources/api/api_service.dart';
import 'package:flutter_order_management/data/sources/database/local_database_helper.dart';

part 'my_orders_event.dart';
part 'my_orders_state.dart';

class MyOrdersBloc extends Bloc<MyOrdersEvent, MyOrdersState> {
  MyOrdersBloc() : super(MyOrdersInitialState()) {
    on(myOrdersEventControl);
  }
  final apiService = APIService();
  List<OrderModel> allOrders = [];
  List<ProductModel> allProducts = [];
  Future<void> myOrdersEventControl(MyOrdersEvent event, Emitter<MyOrdersState> emit) async {
    if (event is MyOrdersProcessStartEvent) {
      emit(MyOrdersProcessLoading());
      BaseListResponse<OrderModel>? orderResponse = await apiService.getMyOrders(LocaleDatabaseHelper.i.currentUserId.toString());
      BaseListResponse<ProductModel>? productResponse = await apiService.getAllProducts();
      try {
        if (orderResponse != null && productResponse != null) {
          allOrders.addAll(orderResponse.model!);
          allProducts.addAll(productResponse.model!);
          emit(MyOrdersProcessSuccesful(allOrders, allProducts));
        }
      } catch (e) {
        log(e.toString(), error: "MyOrdersProcessError");
        emit(MyOrdersProcessError());
      }
    } else if (event is MyOrdersProcessSocketUpdateEvent) {
      var index = allOrders.indexWhere((element) => element.orderId == event.model.orderId);
      allOrders[index] = event.model;
      emit(MyOrdersProcessSuccesful(allOrders, allProducts));
    }
  }
}
