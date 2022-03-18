part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [UniqueKey()];
}

class LoginProcessStart extends LoginEvent{}