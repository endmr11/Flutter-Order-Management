part of 'shopping_cart_bloc.dart';

abstract class ShoppingCartState extends Equatable {
  const ShoppingCartState();

  @override
  List<Object> get props => [UniqueKey()];
}

class ShoppingCartInitialState extends ShoppingCartState {}

class ShoppingCartAddedState extends ShoppingCartState {
  final ProductModel product;

  const ShoppingCartAddedState(this.product);

  @override
  List<Object> get props => [product];
}
