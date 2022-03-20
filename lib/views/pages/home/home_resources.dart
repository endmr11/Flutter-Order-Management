import 'package:flutter_order_management/data/models/product_models/product_model.dart';

import 'bloc/home_bloc.dart';

mixin HomeResources {
  final String title = 'Home';
  HomeBloc? homeBloc;
  List<ProductModel> allProducts = [];
  bool? isLoading;
}
