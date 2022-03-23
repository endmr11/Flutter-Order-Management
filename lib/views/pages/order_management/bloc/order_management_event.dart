part of 'order_management_bloc.dart';

abstract class OrderManagementEvent extends Equatable {
  const OrderManagementEvent();

  @override
  List<Object> get props => [UniqueKey()];
}

class OrderManagementProcessStartEvent extends OrderManagementEvent {}

class OrderManagementUpdateEvent extends OrderManagementEvent {
  final String orderId;
  final OrderRequestModel orderRequestModel;

  const OrderManagementUpdateEvent(this.orderRequestModel,this.orderId);

  @override
  List<Object> get props => [UniqueKey(), orderRequestModel,orderId];
}
