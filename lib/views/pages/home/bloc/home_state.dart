part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitialState extends HomeState {}

class HomeProcessLoading extends HomeState {}

class HomeProcessSuccesful extends HomeState {
  final List<ProductModel> allProducts;

  const HomeProcessSuccesful(this.allProducts);
  @override
  List<Object> get props => [allProducts];
}

class HomeProcessError extends HomeState {}
