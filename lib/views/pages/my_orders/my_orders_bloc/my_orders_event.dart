part of 'my_orders_bloc.dart';

abstract class MyOrdersEvent extends Equatable {
  const MyOrdersEvent();

  @override
  List<Object> get props => [];
}

class MyOrdersProcessStartEvent extends MyOrdersEvent {}
class MyOrdersProcessSocketUpdateEvent extends MyOrdersEvent {
  final OrderModel model;

  const MyOrdersProcessSocketUpdateEvent(this.model);

  @override
  List<Object> get props => [UniqueKey()];
}