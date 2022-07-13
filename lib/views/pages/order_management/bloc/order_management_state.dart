part of 'order_management_bloc.dart';

abstract class OrderManagementState extends Equatable {
  const OrderManagementState();

  @override
  List<Object> get props => [UniqueKey()];
}

class OrderManagementInitialState extends OrderManagementState {}

class OrderManagementProcessLoading extends OrderManagementState {}

class OrderManagementProcessSuccesful extends OrderManagementState {
  final List<OrderModel> allOrders;
  final List<ProductModel> allProducts;

  const OrderManagementProcessSuccesful(this.allOrders, this.allProducts);
  @override
  List<Object> get props => [UniqueKey(), allOrders, allProducts];
}

class OrderManagementProcessError extends OrderManagementState {
  final String error;

  const OrderManagementProcessError(this.error);
  @override
  List<Object> get props => [UniqueKey(), error];
}
