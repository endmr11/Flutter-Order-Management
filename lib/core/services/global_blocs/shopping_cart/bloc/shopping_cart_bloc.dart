import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_order_management/data/models/base_models/base_response_model.dart';
import 'package:flutter_order_management/data/models/order_models/order_model.dart';
import 'package:flutter_order_management/data/models/order_models/order_request_model.dart';
import 'package:flutter_order_management/data/models/product_models/product_model.dart';
import 'package:flutter_order_management/data/sources/api/api_service.dart';

part 'shopping_cart_event.dart';
part 'shopping_cart_state.dart';

class ShoppingCartBloc extends Bloc<ShoppingCartEvent, ShoppingCartState> {
  ShoppingCartBloc() : super(ShoppingCartInitialState()) {
    on(shoppingCartEventControl);
  }
  final apiService = APIService();
  Future<void> shoppingCartEventControl(ShoppingCartEvent event, Emitter<ShoppingCartState> emit) async {
    if (event is ShoppingCartAddEvent) {
      emit(ShoppingCartAddedState(event.product));
    } else if (event is ShoppingCartAddOrder) {
      emit(ShoppingCartOrderLoading());
      BaseListResponse<OrderModel>? response = await apiService.setOrder(event.orderRequestModel);
      if (response != null) {
        emit(ShoppingCartOrderSuccesful());
      } else {
        emit(ShoppingCartOrderError());
      }
    }
  }
}
