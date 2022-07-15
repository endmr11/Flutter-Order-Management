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

  const OrderManagementUpdateEvent(this.orderRequestModel, this.orderId);

  @override
  List<Object> get props => [UniqueKey(), orderRequestModel, orderId];
}

class OrderManagementSocketCreateEvent extends OrderManagementEvent {
  final OrderModel model;

  const OrderManagementSocketCreateEvent(this.model);

  @override
  List<Object> get props => [UniqueKey()];
}

class OrderManagementSocketUpdateEvent extends OrderManagementEvent {
  final OrderModel model;

  const OrderManagementSocketUpdateEvent(this.model);

  @override
  List<Object> get props => [UniqueKey()];
}
