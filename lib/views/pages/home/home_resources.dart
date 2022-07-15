import 'package:flutter_order_management/data/models/order_models/order_request_model.dart';

import 'home_bloc/home_bloc.dart';
import 'shopping_cart_bloc/bloc/shopping_cart_bloc.dart';

mixin HomeResources {
  final String title = 'Home';
  HomeBloc? homeBloc;
  ShoppingCartBloc? shoppingCartBloc;
  int screenIndex = 0;
  List<OrderProductModel> productList = [];
}
