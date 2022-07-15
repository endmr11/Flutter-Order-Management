part of 'shopping_cart_bloc.dart';

abstract class ShoppingCartState extends Equatable {
  const ShoppingCartState();

  @override
  List<Object> get props => [UniqueKey()];
}

class ShoppingCartInitialState extends ShoppingCartState {}

class ShoppingCartAddedState extends ShoppingCartState {
  final bool isAdded;

  const ShoppingCartAddedState(this.isAdded);

  @override
  List<Object> get props => [UniqueKey(), isAdded];
}

class ShoppingCartLoadedState extends ShoppingCartState {
  final List<ProductModel> cartProducts;
  final List<int> cartProductCount;

  const ShoppingCartLoadedState(this.cartProducts, this.cartProductCount);

  @override
  List<Object> get props => [UniqueKey(), cartProducts, cartProductCount];
}

class ShoppingCartOrderLoading extends ShoppingCartState {}

class ShoppingCartOrderSuccesful extends ShoppingCartState {
  @override
  List<Object> get props => [UniqueKey()];
}

class ShoppingCartOrderError extends ShoppingCartState {
  final String error;

  const ShoppingCartOrderError(this.error);

  @override
  List<Object> get props => [UniqueKey(), error];
}
