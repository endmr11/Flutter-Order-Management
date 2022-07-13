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
