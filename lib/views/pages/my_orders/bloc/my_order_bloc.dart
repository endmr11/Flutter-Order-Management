import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_order_management/data/models/order_models/order_model.dart';
import 'package:flutter_order_management/data/models/product_models/product_model.dart';
import 'package:flutter_order_management/data/sources/api/api_service.dart';
import 'package:flutter_order_management/data/sources/database/local_database_helper.dart';

part 'my_order_event.dart';
part 'my_order_state.dart';

class MyOrdersBloc extends Bloc<MyOrdersEvent, MyOrdersState> {
  MyOrdersBloc() : super(MyOrdersInitialState()) {
    on(myOrdersEventControl);
  }
  final apiService = APIService();
  Future<void> myOrdersEventControl(MyOrdersEvent event, Emitter<MyOrdersState> emit) async {
    if (event is MyOrdersProcessStartEvent) {
      emit(MyOrdersProcessLoading());
      OrderResponseModel? orderResponse = await apiService.getMyOrders(LocaleDatabaseHelper.i.currentUserId.toString());
      ProductResponseModel? productResponse = await apiService.getAllProducts();
      try {
        if (orderResponse != null && productResponse != null) {
          emit(MyOrdersProcessSuccesful(orderResponse.model!, productResponse.model!));
        }
      } catch (e) {
        log(e.toString(), error: "MyOrdersProcessError");
        emit(MyOrdersProcessError());
      }
    }
  }
}
