part of 'order_management_bloc.dart';

abstract class OrderManagementEvent extends Equatable {
  const OrderManagementEvent();

  @override
  List<Object> get props => [];
}

class OrderManagementProcessStart extends OrderManagementEvent {}
