import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_order_management/data/models/base_models/base_response_model.dart';
import 'package:flutter_order_management/data/models/order_models/order_model.dart';
import 'package:flutter_order_management/data/models/order_models/order_request_model.dart';
import 'package:flutter_order_management/data/models/product_models/product_model.dart';
import 'package:flutter_order_management/data/sources/api/api_service.dart';

part 'order_management_event.dart';
part 'order_management_state.dart';

class OrderManagementBloc extends Bloc<OrderManagementEvent, OrderManagementState> {
  IAPIService apiService = APIService();
  OrderManagementBloc(this.apiService) : super(OrderManagementInitialState()) {
    on(orderManagementEventControl);
  }
  List<OrderModel> allOrders = [];
  List<ProductModel> allProducts = [];
  Future<void> orderManagementEventControl(OrderManagementEvent event, Emitter<OrderManagementState> emit) async {
    if (event is OrderManagementProcessStartEvent) {
      emit(OrderManagementProcessLoading());
      BaseListResponse<OrderModel>? orderResponse = await apiService.getAllOrders();
      BaseListResponse<ProductModel>? productResponse = await apiService.getAllProducts();
      try {
        if (orderResponse != null && productResponse != null) {
          allOrders.addAll(orderResponse.model!);
          allProducts.addAll(productResponse.model!);
          emit(OrderManagementProcessSuccesful(allOrders, allProducts));
        }
      } catch (e) {
        log(e.toString(), error: "OrderManagementProcessError");
        emit(OrderManagementProcessError(e.toString()));
      }
    } else if (event is OrderManagementUpdateEvent) {
      BaseListResponse<OrderModel>? orderResponse = await apiService.updateOrder(event.orderRequestModel, event.orderId);
      try {
        if (orderResponse != null) {
          var index = allOrders.indexWhere((element) => element.orderId == orderResponse.model!.first.orderId);
          allOrders[index] = orderResponse.model!.first;
          emit(OrderManagementProcessSuccesful(allOrders, allProducts));
        }
      } catch (e) {
        log(e.toString(), error: "OrderManagementUpdateError");
        emit(OrderManagementProcessError(e.toString()));
      }
    } else if (event is OrderManagementSocketCreateEvent) {
      allOrders.insert(0, event.model);
      emit(OrderManagementProcessSuccesful(allOrders, allProducts));
    } else if (event is OrderManagementSocketUpdateEvent) {
      var index = allOrders.indexWhere((element) => element.orderId == event.model.orderId);
      allOrders[index] = event.model;
      emit(OrderManagementProcessSuccesful(allOrders, allProducts));
    }
  }
}
