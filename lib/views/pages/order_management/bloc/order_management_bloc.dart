import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_order_management/data/models/order_models/order_model.dart';
import 'package:flutter_order_management/data/sources/api/api_service.dart';

part 'order_management_event.dart';
part 'order_management_state.dart';

class OrderManagementBloc extends Bloc<OrderManagementEvent, OrderManagementState> {
  OrderManagementBloc() : super(OrderManagementInitialState()) {
    on(orderManagementEventControl);
  }

  final apiService = APIService();

  Future<void> orderManagementEventControl(OrderManagementEvent event, Emitter<OrderManagementState> emit) async {
    if (event is OrderManagementProcessStart) {
      emit(OrderManagementProcessLoading());
      OrderResponseModel? response = await apiService.getAllOrders();
      if (response != null) {
        emit(OrderManagementProcessSuccesful(response.model!));
      } else {
        emit(OrderManagementProcessError());
      }
    }
  }
}
