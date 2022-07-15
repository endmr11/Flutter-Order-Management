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
  IAPIService apiService = APIService();
  ShoppingCartBloc(this.apiService) : super(ShoppingCartInitialState()) {
    on(shoppingCartEventControl);
  }
  List<ProductModel> cartProducts = [];
  List<int> cartProductCount = [];
  Future<void> shoppingCartEventControl(ShoppingCartEvent event, Emitter<ShoppingCartState> emit) async {
    if (event is ShoppingCartAddEvent) {
      if (!cartProducts.contains(event.product)) {
        cartProductCount.add(1);
        cartProducts.add(event.product);
        emit(const ShoppingCartAddedState(true));
        add(const ShoppingCartRefreshEvent());
      } else {
        emit(const ShoppingCartAddedState(false));
        add(const ShoppingCartRefreshEvent());
      }
    } else if (event is ShoppingCartRemoveEvent) {
      cartProducts.removeWhere((element) => element.productId == event.product.productId);
      cartProductCount.removeAt(0);
      add(const ShoppingCartRefreshEvent());
    } else if (event is ShoppingCartAddOrder) {
      emit(ShoppingCartOrderLoading());
      try {
        BaseListResponse<OrderModel>? response = await apiService.setOrder(event.orderRequestModel);
        if (response != null) {
          cartProducts.clear();
          cartProducts = [];
          cartProductCount.clear();
          cartProductCount = [];
          emit(ShoppingCartOrderSuccesful());
          add(const ShoppingCartRefreshEvent());
        }
      } catch (e) {
        emit(ShoppingCartOrderError(e.toString()));
      }
    } else if (event is ShoppingProductCountIcrementEvent) {
      cartProductCount[event.index] += 1;
      add(const ShoppingCartRefreshEvent());
    } else if (event is ShoppingProductCountDecreaseEvent) {
      cartProductCount[event.index] -= 1;
      add(const ShoppingCartRefreshEvent());
    } else if (event is ShoppingCartRefreshEvent) {
      emit(ShoppingCartLoadedState(cartProducts, cartProductCount));
    }
  }
}
