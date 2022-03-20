part of 'order_management_bloc.dart';

abstract class OrderManagementState extends Equatable {
  const OrderManagementState();

  @override
  List<Object> get props => [];
}

class OrderManagementInitialState extends OrderManagementState {}

class OrderManagementProcessLoading extends OrderManagementState {}

class OrderManagementProcessSuccesful extends OrderManagementState {
   final List<OrderModel> allOrders;

  const OrderManagementProcessSuccesful(this.allOrders);
  @override
  List<Object> get props => [allOrders]; 
}

class OrderManagementProcessError extends OrderManagementState {}
