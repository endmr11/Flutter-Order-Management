part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [UniqueKey()];
}

class LoginInitialState extends LoginState {}

class LoginProcessLoading extends LoginState {}

class LoginProcessSuccesful extends LoginState {}

class LoginProcessError extends LoginState {
  final String error;

  const LoginProcessError(this.error);
  @override
  List<Object> get props => [UniqueKey(), error];
}
