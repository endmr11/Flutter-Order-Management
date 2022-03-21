part of 'shopping_cart_bloc.dart';

abstract class ShoppingCartEvent extends Equatable {
  const ShoppingCartEvent();

  @override
  List<Object> get props => [];
}

class ShoppingCartAddEvent extends ShoppingCartEvent {
  final ProductModel product;

  const ShoppingCartAddEvent(this.product);

  @override
  List<Object> get props => [product];
}
