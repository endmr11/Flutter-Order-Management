part of 'shopping_cart_bloc.dart';

abstract class ShoppingCartEvent extends Equatable {
  const ShoppingCartEvent();

  @override
  List<Object> get props => [UniqueKey()];
}

class ShoppingCartAddEvent extends ShoppingCartEvent {
  final ProductModel product;

  const ShoppingCartAddEvent(this.product);

  @override
  List<Object> get props => [UniqueKey(), product];
}

class ShoppingCartRemoveEvent extends ShoppingCartEvent {
  final ProductModel product;

  const ShoppingCartRemoveEvent(this.product);

  @override
  List<Object> get props => [UniqueKey(), product];
}

class ShoppingProductCountIcrementEvent extends ShoppingCartEvent {
  final int index;

  const ShoppingProductCountIcrementEvent(this.index);

  @override
  List<Object> get props => [UniqueKey(), index];
}

class ShoppingProductCountDecreaseEvent extends ShoppingCartEvent {
  final int index;

  const ShoppingProductCountDecreaseEvent(this.index);

  @override
  List<Object> get props => [UniqueKey(), index];
}

class ShoppingCartRefreshEvent extends ShoppingCartEvent {
  const ShoppingCartRefreshEvent();

  @override
  List<Object> get props => [UniqueKey()];
}

class ShoppingCartAddOrder extends ShoppingCartEvent {
  final OrderRequestModel orderRequestModel;

  const ShoppingCartAddOrder(this.orderRequestModel);

  @override
  List<Object> get props => [UniqueKey(), orderRequestModel];
}
