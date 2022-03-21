import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_order_management/data/models/product_models/product_model.dart';

part 'shopping_cart_event.dart';
part 'shopping_cart_state.dart';

class ShoppingCartBloc extends Bloc<ShoppingCartEvent, ShoppingCartState> {
  ShoppingCartBloc() : super(ShoppingCartInitialState()) {
    on(shoppingCartEventControl);
  }

  Future<void> shoppingCartEventControl(ShoppingCartEvent event, Emitter<ShoppingCartState> emit) async {
    if (event is ShoppingCartAddEvent) {
      emit(ShoppingCartAddedState(event.product));
    }
  }
}
