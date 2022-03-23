import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_order_management/data/models/order_models/order_model.dart';
import 'package:flutter_order_management/data/models/order_models/order_request_model.dart';
import 'package:flutter_order_management/data/models/product_models/product_model.dart';
import 'package:flutter_order_management/data/sources/api/api_service.dart';

part 'order_management_event.dart';
part 'order_management_state.dart';

class OrderManagementBloc extends Bloc<OrderManagementEvent, OrderManagementState> {
  OrderManagementBloc() : super(OrderManagementInitialState()) {
    on(orderManagementEventControl);
  }

  final apiService = APIService();

  Future<void> orderManagementEventControl(OrderManagementEvent event, Emitter<OrderManagementState> emit) async {
    if (event is OrderManagementProcessStartEvent) {
      emit(OrderManagementProcessLoading());
      OrderResponseModel? orderResponse = await apiService.getAllOrders();
      ProductResponseModel? productResponse = await apiService.getAllProducts();
      try {
        if (orderResponse != null && productResponse != null) {
          emit(OrderManagementProcessSuccesful(orderResponse.model!, productResponse.model!));
        }
      } catch (e) {
        log(e.toString(), error: "OrderManagementProcessError");
        emit(OrderManagementProcessError());
      }
    } else if (event is OrderManagementUpdateEvent) {
      OrderResponseModel? orderResponse = await apiService.updateOrder(event.orderRequestModel, event.orderId);

      try {
        if (orderResponse != null) {
          emit(OrderManagementUpdateSuccesful(orderResponse.model!));
        }
      } catch (e) {
        log(e.toString(), error: "OrderManagementUpdateError");
        emit(OrderManagementUpdateError());
      }
    }
  }
}
