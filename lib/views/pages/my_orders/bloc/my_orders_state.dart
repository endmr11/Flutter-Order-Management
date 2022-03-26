part of 'my_orders_bloc.dart';

abstract class MyOrdersState extends Equatable {
  const MyOrdersState();

  @override
  List<Object> get props => [UniqueKey()];
}

class MyOrdersInitialState extends MyOrdersState {}

class MyOrdersProcessLoading extends MyOrdersState {}

class MyOrdersProcessSuccesful extends MyOrdersState {
  final List<OrderModel> allOrders;
  final List<ProductModel> allProducts;

  const MyOrdersProcessSuccesful(this.allOrders, this.allProducts);
  @override
  List<Object> get props => [UniqueKey(), allOrders, allProducts];
}

class MyOrdersProcessError extends MyOrdersState {}
